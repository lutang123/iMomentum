import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/utils/pages_routes.dart';
import 'package:iMomentum/screens/landing_and_signIn/start_screen.dart';
import 'package:iMomentum/screens/landing_and_signIn/start_screen3_(sign_in).dart';
import 'dart:math';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/utils/cap_string.dart';

const imageURL1 = 'assets/images/landscape.jpg';
const text1 =
    'iMomentum is a special application that keeps you focused on what is the most important with peacefulness and positivity.';

const imageURL2 = 'assets/images/landscape.jpg';
const text2 = 'Inspiration: breathe life into your Mobile App'
    '\n'
    'Photos: Inspiring photography; Quotes: Timeless wisdom; Mantras: positive concepts.';

const imageURL3 = 'assets/images/landscape.jpg';
const text3 = 'Focus: Approach each day with intent.'
    '\n'
    'Daily focus: set a daily focus reminder; Todo: organize your daily tasks';

const imageURL4 = 'assets/images/landscape.jpg';
const text4 = 'Customization: design your own app'
    '\n'
    'Personalize with your own photos, mantras and quotes';

const imageURL5 = 'assets/images/landscape.jpg';
const text5 =
    'iMomentum is a special application that keeps you focused on what is the most important with peacefulness and positivity.';

class StartScreen2 extends StatefulWidget {
  final String name;

  const StartScreen2({Key key, this.name}) : super(key: key);

  @override
  _StartScreen2State createState() => _StartScreen2State();
}

class _StartScreen2State extends State<StartScreen2> {
  String userName;

  @override
  void initState() {
    userName = widget.name;
    super.initState();
  }

  ///try sign in to another page
  // Future<void> _showSignInError(
  //     BuildContext context, PlatformException exception) async {
  //   await PlatformExceptionAlertDialog(
  //     title: Strings.signInFailed,
  //     exception: exception,
  //   ).show(context);
  // }
  //
  // Future<void> _signInAnonymously(BuildContext context) async {
  //   try {
  //     await widget.manager.signInAnonymously();
  //   } on PlatformException catch (e) {
  //     _showSignInError(context, e);
  //   }
  // }
  //
  // Future<void> _signInWithGoogle(BuildContext context) async {
  //   try {
  //     await widget.manager.signInWithGoogle();
  //   } on PlatformException catch (e) {
  //     if (e.code != 'ERROR_ABORTED_BY_USER') {
  //       _showSignInError(context, e);
  //     }
  //   }
  // }

  /// TODO: Facebook and Apple
  // Future<void> _signInWithFacebook(BuildContext context) async {
  //   try {
  //     await manager.signInWithFacebook();
  //   } on PlatformException catch (e) {
  //     if (e.code != 'ERROR_ABORTED_BY_USER') {
  //       _showSignInError(context, e);
  //     }
  //   }
  // }

  // Future<void> _signInWithApple(BuildContext context) async {
  //   try {
  //     await manager.signInWithApple();
  //   } on PlatformException catch (e) {
  //     if (e.code != 'ERROR_ABORTED_BY_USER') {
  //       _showSignInError(context, e);
  //     }
  //   }
  // }

  // Future<void> _signInWithEmailAndPassword(BuildContext context) async {
  //   final navigator = Navigator.of(context);
  //   await EmailPasswordSignInPage.show(
  //     context,
  //     onSignedIn: navigator.pop,
  //   );
  // }

  // widget.isLoading ? null : () => _signInWithGoogle(context),

  int page = 0;

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }

  final List<Widget> pages = [
    MyPageContainer(imageURL: ImageUrl.startImage, text: text1),
    MyPageContainer(imageURL: ImageUrl.startImage, text: text2),
    MyPageContainer(imageURL: ImageUrl.startImage, text: text3),
    MyPageContainer(imageURL: ImageUrl.startImage, text: text4),
    MyPageContainer(imageURL: ImageUrl.startImage, text: text5),
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
          ),
          Positioned(
            left: 30,
            right: 30,
            top: 50,
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      child: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onTap: () =>
                          Navigator.of(context).pushReplacement(PageRoutes.fade(
                        () => StartScreen(),
                      )),
                    )
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Positioned(
            left: 30,
            right: 30,
            top: 100,
            child: Text('Hi, ${userName.firstCaps}, welcome to iMomentum.',
                style: KLandingTitle),
          ),
          Positioned(
            left: 30,
            right: 30,
            bottom: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: MyFlatButton(
                        text: 'Start Now',
                        onPressed: () => Navigator.of(context).pushReplacement(
                                // PageRoutes.fade(() => SignInScreenBuilder())),
                                PageRoutes.fade(
                              () => StartScreen3(name: userName),
                            ))))
              ],
            ),
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
}

class MyPageContainer extends StatelessWidget {
  const MyPageContainer({
    Key key,
    @required this.imageURL,
    @required this.text,
  }) : super(key: key);

  final String imageURL;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageURL),
          fit: BoxFit.cover,
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child:
                MySignInContainer(child: Text(text, style: KLandingSubtitle)),
          ),
        ),
      ),
    );
  }
}

///previous note, with auth
// void _showSignInError(BuildContext context, PlatformException exception) {
//   PlatformExceptionAlertDialog(
//     title: 'Sign in failed',
//     exception: exception,
//   ).show(context);
// }

// Future<void> _signInAnonymously(BuildContext context) async {
//   try {
//     final AuthService auth = Provider.of<AuthService>(context, listen: false);
//     await auth.signInAnonymously();
//   } on PlatformException catch (e) {
//     _showSignInError(context, e);
//   }
// }

// Future<void> _signInWithGoogle(BuildContext context) async {
//   try {
//     final AuthService auth = Provider.of<AuthService>(context, listen: false);
//     await auth.signInWithGoogle();
//   } on PlatformException catch (e) {
//     if (e.code != 'ERROR_ABORTED_BY_USER') {
//       _showSignInError(context, e);
//     }
//   }
// }
