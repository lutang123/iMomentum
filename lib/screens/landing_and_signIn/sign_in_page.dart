import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/services/auth.dart';
import 'package:iMomentum/app/services/sign_in/email_sign_in_page.dart';
import 'package:iMomentum/app/services/sign_in/sign_in_button.dart';
import 'package:iMomentum/app/services/sign_in/sign_in_manager.dart';
import 'package:iMomentum/screens/notes_screen/build_note_container.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'dart:math';

import 'package:liquid_swipe/liquid_swipe.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    Key key,
    @required this.manager,
    @required this.isLoading,
  }) : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static const Key emailPasswordKey = Key('email-password');

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
      // on PlatformExceptions needs to import services
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      //this makes the app.sign_in.screen goes from the bottom
      fullscreenDialog: true,
      builder: (context) => EmailSignInPage(),
    ));
  }

  // widget.isLoading ? null : () => _signInWithGoogle(context),

  int page = 0;

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }

  final pages = [
    Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/ocean1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: Container(
        child: Column(
          children: <Widget>[
            Text('Welcome to iMomentum, Lu'),
            SizedBox(height: 5),
            Text(
                'iMomentum is a special application that keeps you focused on what is the most important with peacefulness and positivity.')
          ],
        ),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/landscape.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: Container(
        child: Column(
          children: <Widget>[
            Text('Inspiration: breathe life into your Mobile App'),
            SizedBox(height: 5),
            Text(
                'Photos: Inspiring photography; Quotes: Timeless wisdom; Mantras: positive concepts')
          ],
        ),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/waterfall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: Container(
        child: Column(
          children: <Widget>[
            Text('Focus: Approach each day with intent'),
            SizedBox(height: 5),
            Text(
                'Daily focus: set a daily focus reminder; Todo: organize your daily tasks')
          ],
        ),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/mountain1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: Container(
        child: Column(
          children: <Widget>[
            Text('Customization: design your own app'),
            SizedBox(height: 5),
            Text('Personalize with your own photos, mantras and quotes')
          ],
        ),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/landscape2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: Container(),
    ),
  ];

  Widget _buildDot(int index) {
    double selected = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page ?? 0) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selected;
    return new Container(
      width: 25.0,
      child: Center(
        child: Material(
          color: Colors.white,
          type: MaterialType.circle,
          child: new Container(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LiquidSwipe(
            pages: pages,
            fullTransitionValue: 200,
            enableSlideIcon: false,
            enableLoop: true,
            onPageChangeCallback: pageChangeCallback,
            waveType: WaveType.liquidReveal,
//              liquidController: liquidController,
//              slidePercentCallback: slidePercentCallback,
          ),
          Positioned(
            left: 30,
            right: 30,
            bottom: 100,
            child: MySignInContainer(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: MyFlatButton(
                      text: 'Sign in with email',
                      onPressed: widget.isLoading
                          ? null
                          : () => _signInWithEmail(context),
                    )),
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: MyFlatButton(
                      text: 'Sign in with Google',
                      onPressed: widget.isLoading
                          ? null
                          : () => _signInWithGoogle(context),
                    )),
              ],
            )),
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(pages.length, _buildDot),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),
          SizedBox(height: 48.0),
          SignInButton(
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed:
                widget.isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0),
          SignInButton(
//              key: emailPasswordKey,
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed:
                widget.isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(height: 8.0),
          Text(
            'or',
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed:
                widget.isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
