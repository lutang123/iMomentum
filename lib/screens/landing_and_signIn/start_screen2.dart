import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/constants/my_strings.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/utils/pages_routes.dart';
import 'package:iMomentum/screens/landing_and_signIn/start_screen1.dart';
import 'package:iMomentum/screens/landing_and_signIn/start_screen3_(signIn).dart';
import 'dart:math';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/utils/extension_firstCaps.dart';
import 'package:provider/provider.dart';

class StartScreen2 extends StatefulWidget {
  final String name;

  const StartScreen2({Key key, this.name}) : super(key: key);

  @override
  _StartScreen2State createState() => _StartScreen2State();
}

class _StartScreen2State extends State<StartScreen2> {
  String userName;
  LiquidController liquidController;
  @override
  void initState() {
    userName = widget.name;
    liquidController = LiquidController();
    super.initState();
  }

  int page = 0;
  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }

  final List<Widget> pages = [
    MyPageContainer1(imageURL: ImageUrl.startImage1, text: Strings.text1),
    MyPageContainer2(imageURL: ImageUrl.startImage2, title: Strings.text2),
    MyPageContainer3(imageURL: ImageUrl.startImage3, text: Strings.text3),
    MyPageContainer4(imageURL: ImageUrl.startImage4, text: Strings.text4),
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
      backgroundColor: darkThemeNoPhotoColor,
      body: Stack(
        children: <Widget>[
          LiquidSwipe(
            pages: pages,
            enableSlideIcon: true,
            positionSlideIcon: 0.5,
            fullTransitionValue: 600,
            slideIconWidget: page == pages.length - 1
                ? null
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: darkThemeAppBar,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.arrow_back_ios,
                                size: 30, color: Colors.white),
                            Text('Swipe to Next', style: KSignInButtonTextD)
                          ],
                        ),
                      ),
                    ),
                  ),
            enableLoop: true,
            onPageChangeCallback: pageChangeCallback,
            waveType: WaveType.liquidReveal,
            ignoreUserGestureWhileAnimating:
                page == pages.length - 1 ? false : true,
            liquidController: liquidController,
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
          page == pages.length - 1
              ? Positioned(
                  left: 30,
                  right: 30,
                  bottom: 140,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: MyFlatButton(
                              text: 'Start Now',
                              onPressed: () => Navigator.of(context)
                                      .pushReplacement(PageRoutes.fade(
                                    () => StartScreen3(name: userName),
                                  ))))
                    ],
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(20),
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
          page == pages.length - 1
              ? Container()
              : Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: FlatButton(
                      onPressed: () {
                        liquidController.animateToPage(
                            page: pages.length - 1, duration: 500);
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text("Skip to End",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              )),
                        ),
                        decoration: BoxDecoration(
                            color: darkThemeAppBar,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                      color: Colors.black.withOpacity(0.01),
                    ),
                  ),
                ),
          page == 0
              ? Container()
              : Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: FlatButton(
                      onPressed: () {
                        liquidController.jumpToPage(
                            page: liquidController.currentPage - 1);
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            "Previous Page",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: darkThemeAppBar,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                      color: Colors.black.withOpacity(0.01),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

const double heightNum = 0.4;

class MyPageContainer1 extends StatelessWidget {
  const MyPageContainer1({
    Key key,
    @required this.imageURL,
    @required this.text,
  }) : super(key: key);

  final String imageURL;
  final String text;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageURL),
            fit: BoxFit.cover,
          ),
          gradient: KBackgroundGradient),
      constraints: BoxConstraints.expand(),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: MySignInContainer(
                height: height * heightNum,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(text,
                        style: _darkTheme
                            ? KLandingSubtitleD
                            : TextStyle(
                                fontSize: 25,
                                color: lightThemeWords.withOpacity(0.6),
                                fontWeight: FontWeight.w600,
                              ),
                        textAlign: TextAlign.center),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class MyPageContainer2 extends StatelessWidget {
  const MyPageContainer2({
    Key key,
    @required this.imageURL,
    @required this.title,
  }) : super(key: key);

  final String imageURL;
  final String title;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageURL),
            fit: BoxFit.cover,
          ),
          gradient: KBackgroundGradient),
      constraints: BoxConstraints.expand(),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: MySignInContainer(
                height: height * heightNum,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: _darkTheme ? KLandingSubtitleD : KLandingSubtitleL,
                    ),
                    SizedBox(height: 15),
                    Text('Breathe life into your device',
                        style: _darkTheme
                            ? KLandingSubtitle2D
                            : KLandingSubtitle2L,
                        textAlign: TextAlign.center),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.images,
                          color:
                              _darkTheme ? darkThemeButton : lightThemeButton),
                      title: Text('Inspiring photography with dynamic display.',
                          style: TextStyle(
                              color: _darkTheme
                                  ? darkThemeWords
                                  : lightThemeWords)),
                    ),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.quoteLeft,
                          color:
                              _darkTheme ? darkThemeButton : lightThemeButton),
                      title: Text('Timeless wisdom with daily quote.',
                          style: TextStyle(
                              color: _darkTheme
                                  ? darkThemeWords
                                  : lightThemeWords)),
                    ),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.solidHeart,
                          color:
                              _darkTheme ? darkThemeButton : lightThemeButton),
                      title: Text('Positive concept with mantras',
                          style: TextStyle(
                              color: _darkTheme
                                  ? darkThemeWords
                                  : lightThemeWords)),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class MyPageContainer3 extends StatelessWidget {
  const MyPageContainer3({
    Key key,
    @required this.imageURL,
    @required this.text,
  }) : super(key: key);

  final String imageURL;
  final String text;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageURL),
            fit: BoxFit.cover,
          ),
          gradient: KBackgroundGradient),
      constraints: BoxConstraints.expand(),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: MySignInContainer(
                height: height * heightNum,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      text,
                      style: _darkTheme ? KLandingSubtitleD : KLandingSubtitleL,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Approach each day with intent.',
                      style:
                          _darkTheme ? KLandingSubtitle2D : KLandingSubtitle2L,
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.check,
                          color:
                              _darkTheme ? darkThemeButton : lightThemeButton),
                      title: Text('Pomodoro Timer with daily focus report',
                          style: TextStyle(
                              color: _darkTheme
                                  ? darkThemeWords
                                  : lightThemeWords)),
                    ),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.check,
                          color:
                              _darkTheme ? darkThemeButton : lightThemeButton),
                      title: Text('Calendar with Task list and Reminder',
                          style: TextStyle(
                              color: _darkTheme
                                  ? darkThemeWords
                                  : lightThemeWords)),
                    ),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.check,
                          color:
                              _darkTheme ? darkThemeButton : lightThemeButton),
                      title: Text('Notes with different colors and font styles',
                          style: TextStyle(
                              color: _darkTheme
                                  ? darkThemeWords
                                  : lightThemeWords)),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class MyPageContainer4 extends StatelessWidget {
  const MyPageContainer4({
    Key key,
    @required this.imageURL,
    @required this.text,
  }) : super(key: key);

  final String imageURL;
  final String text;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageURL),
            fit: BoxFit.cover,
          ),
          gradient: KBackgroundGradient),
      constraints: BoxConstraints.expand(),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: MySignInContainer(
                height: height * heightNum,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      text,
                      style: _darkTheme ? KLandingSubtitleD : KLandingSubtitleL,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Make it your own App.',
                      style:
                          _darkTheme ? KLandingSubtitle2D : KLandingSubtitle2L,
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.cloudUploadAlt,
                          color:
                              _darkTheme ? darkThemeButton : lightThemeButton),
                      title: Text('Add your own photo.',
                          style: TextStyle(
                              color: _darkTheme
                                  ? darkThemeWords
                                  : lightThemeWords)),
                    ),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.edit,
                          color:
                              _darkTheme ? darkThemeButton : lightThemeButton),
                      title: Text('Add your own quote.',
                          style: TextStyle(
                              color: _darkTheme
                                  ? darkThemeWords
                                  : lightThemeWords)),
                    ),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.edit,
                          color:
                              _darkTheme ? darkThemeButton : lightThemeButton),
                      title: Text('Add your own mantra.',
                          style: TextStyle(
                              color: _darkTheme
                                  ? darkThemeWords
                                  : lightThemeWords)),
                    ),
                  ],
                )),
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
