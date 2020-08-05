import 'dart:math' as math;
import 'package:animations/animations.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/shared_axis.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/home_drawer/about_screen.dart';
import 'package:iMomentum/screens/home_drawer/my_mantras.dart';
import 'package:iMomentum/screens/home_drawer/my_quote.dart';
import 'package:iMomentum/screens/home_drawer/user_screen.dart';
import 'package:iMomentum/screens/unsplash/image_gallery.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/common_widgets/avatar.dart';
import '../../app/common_widgets/container_linear_gradient.dart';
import '../../app/common_widgets/platform_alert_dialog.dart';
import '../../app/constants/constants.dart';
import '../../app/services/auth.dart';
import '../../app/constants/theme.dart';
import 'more_settings.dart';
import 'package:iMomentum/app/services/pages_routes.dart';

class MyDrawer extends StatefulWidget {
  final Widget child;

  const MyDrawer({Key key, this.child}) : super(key: key);

  static MyDrawerState of(BuildContext context) =>
      context.findAncestorStateOfType<MyDrawerState>();

  @override
  MyDrawerState createState() => new MyDrawerState();
}

class MyDrawerState extends State<MyDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool _canBeDragged = false;
  final double maxSlide = 300.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  void open() => animationController.forward();

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final randomNotifier = Provider.of<RandomNotifier>(context);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context);
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      behavior: HitTestBehavior.translucent,
      onTap: toggle,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              BuildPhotoView(
                imageUrl: _randomOn
                    ? ImageUrl.randomImageUrl
                    : imageNotifier.getImage(),
              ),
//              Image.network(ImageUrl.randomImageUrl, fit: BoxFit.cover),
              ContainerLinearGradient(),
              Material(
                color: Colors.transparent,
                child: Stack(
                  children: <Widget>[
                    Transform.translate(
                      offset:
                          Offset(maxSlide * (animationController.value - 1), 0),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(
                              math.pi / 2 * (1 - animationController.value)),
                        alignment: Alignment.centerRight,
                        child: MyHomeDrawer(),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(maxSlide * animationController.value, 0),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(-math.pi * animationController.value / 2),
                        alignment: Alignment.centerLeft,
                        child: widget.child,
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top - 9,
                      left: 5 + animationController.value * maxSlide,
                      child: IconButton(
                        iconSize: 25,
                        icon: FaIcon(FontAwesomeIcons.bars),
                        onPressed: toggle,
                        color: _darkTheme ? Colors.white : lightButton,
                      ),
                    ),
//                    Positioned(
//                      top: 16.0 + MediaQuery.of(context).padding.top,
//                      left: animationController.value *
//                          MediaQuery.of(context).size.width,
//                      width: MediaQuery.of(context).size.width,
//                      child: Text(
//                        '',
//                        style: Theme.of(context).primaryTextTheme.bodyText2,
//                        textAlign: TextAlign.center,
//                      ),
//                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed;
    bool isDragCloseFromRight = animationController.isCompleted;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    //I have no idea what it means, copied from Drawer
    double _kMinFlingVelocity = 365.0;

    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }
}

class MyHomeDrawer extends StatelessWidget {
  final SharedAxisTransitionType _transitionType =
      SharedAxisTransitionType.horizontal;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);
//    final String firstName =
//        user.displayName.substring(0, user.displayName.indexOf(' '));

    ///for theme
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    ///for focus mode
    final focusNotifier = Provider.of<FocusNotifier>(context);
    bool _focusModeOn = focusNotifier.getFocus();

    ///for random on
    final randomNotifier = Provider.of<RandomNotifier>(context);
    //if getImage is random, means random is on
    bool _randomOn = (randomNotifier.getRandom() == true);

    ///then return
    return SizedBox(
      width: 300,
      height: double.infinity,
      child: Material(
        color: _darkTheme ? darkDrawer : lightSurface,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListTile(
                  leading: Text(
                    'Settings',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: _darkTheme ? darkButton : lightButton),
                  ),
                ),
              ),
              Flexible(
                child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.adjust,
                    color: _darkTheme ? darkButton : lightButton,
                  ),
                  title: Text('Dark Theme'),
                  trailing: Transform.scale(
                    scale: 0.9,
                    child: CupertinoSwitch(
                      activeColor: switchActiveColor,
                      trackColor: Colors.grey,
                      value: _darkTheme,
                      onChanged: (val) {
                        _darkTheme = val;
                        onThemeChanged(val, themeNotifier);
                      },
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.lightbulb,
                    color: _darkTheme ? darkButton : lightButton,
                  ),
                  title: Text('Focus Mode'),
                  trailing: Transform.scale(
                    scale: 0.9,
                    child: CupertinoSwitch(
                      activeColor: switchActiveColor,
                      trackColor: Colors.grey,
                      value: _focusModeOn,
                      onChanged: (val) {
                        _focusModeOn = val;
                        onFocusChanged(val, focusNotifier, context);
                      },
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.random,
                    color: _darkTheme ? darkButton : lightButton,
                  ),
                  title: Text('Shuffle Photos'),
                  trailing: Transform.scale(
                    scale: 0.9,
                    child: CupertinoSwitch(
                      activeColor: switchActiveColor,
                      trackColor: Colors.grey,
                      value:
                          _randomOn, //this will change based weather image is fixed or random
                      onChanged: (val) {
                        _randomOn = val;
                        onRandomChanged(val, randomNotifier, context);
                      },
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.ellipsisH,
                      color: _darkTheme ? darkButton : lightButton,
                    ),
                    title: Text('More Settings'),
                    trailing: IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: () {
                        final route = SharedAxisPageRoute(
                            page: MoreSettingScreen(),
                            transitionType: _transitionType);
                        Navigator.of(context, rootNavigator: true).push(route);

//                        Navigator.of(context, rootNavigator: true).push(
//                            MaterialPageRoute(
//                                builder: (_) => MoreSettingScreen()));
                      },
                    )),
              ),
              Divider(
                  indent: 80,
                  endIndent: 30,
                  color: _darkTheme ? Colors.white24 : Colors.black12,
                  thickness: 1),
              Flexible(
                child: ListTile(
                  leading: Text(
                    'Customization',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: _darkTheme ? darkButton : lightButton),
                  ),
                ),
              ),
              Flexible(
                child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.images,
                    color: _darkTheme ? darkButton : lightButton,
                  ),
                  title: Text('Choose Your Favourite Photo'),
                  onTap: () {
                    final route = SharedAxisPageRoute(
                        page: ImageGallery(
                          database: database,
                        ),
                        transitionType: _transitionType);
                    Navigator.of(context, rootNavigator: true).push(route);

//                    Navigator.of(context, rootNavigator: true)
//                        .push(MaterialPageRoute(
//                            builder: (_) => ImageGallery(
//                                  database: database,
//                                )));
                  },
                ),
              ),
              Flexible(
                child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.edit,
                    color: _darkTheme ? darkButton : lightButton,
                  ),
                  title: Text('Add Your Own Mantras'),
                  onTap: () {
                    final route = SharedAxisPageRoute(
                        page: MyMantras(
                          database: database,
                        ),
                        transitionType: _transitionType);
                    Navigator.of(context, rootNavigator: true).push(route);

//                    Navigator.of(context, rootNavigator: true)
//                        .push(MaterialPageRoute(
//                            builder: (_) => MyMantras(
//                                  database: database,
//                                )));
                  },
                ),
              ),
              Flexible(
                child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.edit,
                    color: _darkTheme ? darkButton : lightButton,
                  ),
                  title: Text('Add Your Own Quotes'),
                  onTap: () {
                    final route = SharedAxisPageRoute(
                        page: MyQuotes(
                          database: database,
                        ),
                        transitionType: _transitionType);
                    Navigator.of(context, rootNavigator: true).push(route);

//                    Navigator.of(context, rootNavigator: true)
//                        .push(CupertinoPageRoute(
//                            builder: (_) => MyQuotes(
//                                  database: database,
//                                )));
                  },
                ),
              ),
              Divider(
                  indent: 80,
                  endIndent: 30,
                  color: _darkTheme ? Colors.white24 : Colors.black12,
                  thickness: 1),
              Flexible(
                child: ListTile(
                  leading: Avatar(
                    photoUrl: user.photoUrl,
                    radius: 13,
                  ),
                  title: user.displayName == null
                      ? Text('Profile')
                      : Text(user.displayName),
                  onTap: () {
                    final route = SharedAxisPageRoute(
                        page: UserScreen(user: user),
                        transitionType: _transitionType);
                    Navigator.of(context, rootNavigator: true).push(route);
                  },
                ),
              ),
              Flexible(
                child: ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.signOutAlt,
                    color: _darkTheme ? darkButton : lightButton,
                  ),
                  title: Text('Sign Out'),
                  onTap: () => _confirmSignOut(context),
                ),
              ),
              Divider(
                  indent: 80,
                  endIndent: 30,
                  color: _darkTheme ? Colors.white24 : Colors.black12,
                  thickness: 1),
              Flexible(
                child: ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: _darkTheme ? darkButton : lightButton,
                  ),
                  title: Text('About us'),
                  onTap: () {
                    final route = SharedAxisPageRoute(
                        page: AboutScreen(), transitionType: _transitionType);
                    Navigator.of(context, rootNavigator: true).push(route);
                  },
                ),
              ),
//              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }

//  Future<void> onQuoteChanged(bool value, QuoteNotifier quoteNotifier) async {
//    //save settings
//    quoteNotifier.setQuote(value);
//    var prefs = await SharedPreferences.getInstance();
//    prefs.setBool('quote', value);
//  }

  Future<void> onFocusChanged(
      bool value, FocusNotifier focusNotifier, BuildContext context) async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    //save settings
    focusNotifier.setFocus(value);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('focusMode', value);

    value
        ? Flushbar(
            isDismissible: true,
            mainButton: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Ok",
                style: TextStyle(
                    color: _darkTheme ? Colors.white : Colors.black87),
              ),
            ),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            borderRadius: 10,
            flushbarPosition: FlushbarPosition.BOTTOM,
            flushbarStyle: FlushbarStyle.FLOATING,
            reverseAnimationCurve: Curves.decelerate,
            forwardAnimationCurve: Curves.elasticOut,
            backgroundGradient: LinearGradient(colors: [
              Color(0xF058b4ae).withOpacity(0.85),
              Color(0xF0ffe277).withOpacity(0.85)
            ]),
            duration: Duration(seconds: 5),
            titleText: Text(
              'This will enable productivity features on home screen.',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  color: Colors.white,
                  fontFamily: "ShadowsIntoLightTwo"),
            ),
            messageText: Text(
              'Focus on what is the most important to us.',
              style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                  fontFamily: "ShadowsIntoLightTwo"),
            ),
          ).show(context)
        : Flushbar(
            isDismissible: true,
            mainButton: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Ok",
                style: TextStyle(
                    color: _darkTheme ? Colors.white : Colors.black87),
              ),
            ),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            borderRadius: 10,
            flushbarPosition: FlushbarPosition.BOTTOM,
            flushbarStyle: FlushbarStyle.FLOATING,
            reverseAnimationCurve: Curves.decelerate,
            forwardAnimationCurve: Curves.elasticOut,
            backgroundGradient: LinearGradient(colors: [
              Color(0xF058b4ae).withOpacity(0.85),
              Color(0xF0ffe277).withOpacity(0.85)
            ]),
            duration: Duration(seconds: 5),
            titleText: Text(
              'This will hide productivity features on home screen.',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  color: Colors.white,
                  fontFamily: "ShadowsIntoLightTwo"),
            ),
            messageText: Text(
              'We need some downtime in a day',
              style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                  fontFamily: "ShadowsIntoLightTwo"),
            ),
          ).show(context);
  }

  Future<void> onRandomChanged(
      bool value, RandomNotifier randomNotifier, BuildContext context) async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    //change the value
    randomNotifier.setRandom(value);
    //save settings
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('randomOn', value);

    value
        ? Flushbar(
            isDismissible: true,
            mainButton: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Ok",
                style: TextStyle(
                    color: _darkTheme ? Colors.white : Colors.black87),
              ),
            ),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            borderRadius: 10,
            flushbarPosition: FlushbarPosition.BOTTOM,
            flushbarStyle: FlushbarStyle.FLOATING,
            reverseAnimationCurve: Curves.decelerate,
            forwardAnimationCurve: Curves.elasticOut,
            backgroundGradient: LinearGradient(colors: [
              Color(0xF058b4ae).withOpacity(0.85),
              Color(0xF0ffe277).withOpacity(0.85)
            ]),
            duration: Duration(seconds: 6),
            titleText: Text(
              'This will enable a new photo to show every time when opening iMomentum App',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  color: Colors.white,
                  fontFamily: "ShadowsIntoLightTwo"),
            ),
            messageText: Text(
              'You can double tap on screen to change photo anytime.',
              style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                  fontFamily: "ShadowsIntoLightTwo"),
            ),
          ).show(context)
        : Flushbar(
            isDismissible: true,
            mainButton: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Ok",
                style: TextStyle(
                    color: _darkTheme ? Colors.white : Colors.black87),
              ),
            ),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            borderRadius: 10,
            flushbarPosition: FlushbarPosition.BOTTOM,
            flushbarStyle: FlushbarStyle.FLOATING,
            reverseAnimationCurve: Curves.decelerate,
            forwardAnimationCurve: Curves.elasticOut,
            backgroundGradient: LinearGradient(colors: [
              Color(0xF058b4ae).withOpacity(0.85),
              Color(0xF0ffe277).withOpacity(0.85)
            ]),
            duration: Duration(seconds: 6),
            titleText: Text(
              'This will set background photo as a default one.',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  color: Colors.white,
                  fontFamily: "ShadowsIntoLightTwo"),
            ),
            messageText: Text(
              'You can choose your favourite photo and change the photo anytime',
              style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                  fontFamily: "ShadowsIntoLightTwo"),
            ),
          ).show(context);
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }
}
