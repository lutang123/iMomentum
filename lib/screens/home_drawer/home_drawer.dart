import 'dart:math' as math;
import 'package:animations/animations.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/setting_switch.dart';
import 'package:iMomentum/app/utils/shared_axis.dart';
import 'package:iMomentum/app/utils/tooltip_shape_border.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/home_drawer/my_mantras_screen.dart';
import 'package:iMomentum/screens/home_drawer/my_quote_screen.dart';
import 'package:iMomentum/screens/unsplash/image_gallery.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/common_widgets/container_linear_gradient.dart';
import '../../app/common_widgets/platform_alert_dialog.dart';
import '../../app/constants/constants.dart';
import '../../app/services/auth.dart';
import '../../app/constants/theme.dart';
import 'more_settings.dart';

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
                        color: _darkTheme ? Colors.white : lightThemeButton,
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
//    final user = Provider.of<User>(context, listen: false);

    ///error if no user name
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
        color: _darkTheme ? darkThemeDrawer : lightThemeSurface,

        ///two ways: either make it flexible, but then if keyboard pops up, everything kind of squeech together;
        ///or make it scrollable, but can't have spacer or flexible or expanded,
        ///unless using layout builder, but that one can only have one expanded.
        ///see notes in Add note screen.
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 30),
                settingTitle(context, title: 'Settings'),
                Tooltip(
                  message:
                      'This switch controls the theme color, either dark or light.',
                  textStyle: TextStyle(color: Colors.white),
                  preferBelow: false,
                  verticalOffset: 0,

                  ///can't make it a const
                  decoration: ShapeDecoration(
                    color: Color(0xf0086972).withOpacity(0.9),
                    shape: TooltipShapeBorder(arrowArc: 0.5),
                    shadows: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(2, 2))
                    ],
                  ),
                  margin: const EdgeInsets.all(30.0),
                  padding: const EdgeInsets.all(8.0),
                  child: SettingSwitch(
                    size: 20,
                    icon: FontAwesomeIcons.adjust,
                    title: 'Dark Theme',
                    value: _darkTheme,
                    onChanged: (val) {
                      _darkTheme = val;
                      _onThemeChanged(val, themeNotifier);
                    },
                  ),
                ),
                Tooltip(
                  message:
                      'This switch controls whether to show productivity feature on Home Screen.',
                  textStyle: TextStyle(color: Colors.white),
                  preferBelow: false,
                  verticalOffset: 0,

                  ///can't make it a const
                  decoration: ShapeDecoration(
                    color: Color(0xf0086972).withOpacity(0.9),
                    shape: TooltipShapeBorder(arrowArc: 0.5),
                    shadows: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(2, 2))
                    ],
                  ),
                  margin: const EdgeInsets.all(30.0),
                  padding: const EdgeInsets.all(8.0),
                  child: SettingSwitch(
                    icon: EvaIcons.bulbOutline,
                    title: 'Focus Mode',
                    value: _focusModeOn,
                    onChanged: (val) {
                      _focusModeOn = val;
                      _onFocusChanged(val, focusNotifier, context);
                    },
                  ),
                ),
                Tooltip(
                  message:
                      'This switch controls the display of background photo, either the same photo of your choice or a random one from our photo gallery.',
                  textStyle: TextStyle(color: Colors.white),
                  preferBelow: false,
                  verticalOffset: 0,
                  decoration: ShapeDecoration(
                    color: Color(0xf0086972).withOpacity(0.9),
                    shape: TooltipShapeBorder(arrowArc: 0.5),
                    shadows: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(2, 2))
                    ],
                  ),
                  margin: const EdgeInsets.all(30.0),
                  padding: const EdgeInsets.all(8.0),
                  child: SettingSwitch(
                    icon: EvaIcons.shuffle2Outline,
                    title: 'Shuffle Photos',
                    value: _randomOn,
                    onChanged: (val) {
                      _randomOn = val;
                      _onRandomChanged(val, randomNotifier, context);
                    },
                  ),
                ),

                // settingListTile(
                //   context,
                //   icon: EvaIcons.moreHorizotnalOutline,
                //   title: 'More Settings',
                //   onTap: () {
                //     final route = SharedAxisPageRoute(
                //         page: MoreSettingScreen(database: database),
                //         transitionType: _transitionType);
                //     Navigator.of(context, rootNavigator: true).push(route);
                //   },
                // ),
                settingDivider(context),
                settingTitle(context, title: 'Customizations'),
                settingListTile(
                  context,
                  icon: EvaIcons.imageOutline,
                  title: 'Choose Your Favourite Photo',
                  onTap: () {
                    final route = SharedAxisPageRoute(
                        page: ImageGallery(
                          database: database,
                        ),
                        transitionType: _transitionType);
                    Navigator.of(context, rootNavigator: true).push(route);
                  },
                ),
                settingListTile(
                  context,
                  icon: EvaIcons.edit2Outline,
                  title: 'Add Your Own Mantras',
                  onTap: () {
                    final route = SharedAxisPageRoute(
                        page: MyMantras(
                          database: database,
                        ),
                        transitionType: _transitionType);
                    Navigator.of(context, rootNavigator: true).push(route);
                  },
                ),
                settingListTile(
                  context,
                  icon: EvaIcons.edit2Outline,
                  title: 'Add Your Own Quotes',
                  onTap: () {
                    final route = SharedAxisPageRoute(
                        page: MyQuotes(
                          database: database,
                        ),
                        transitionType: _transitionType);
                    Navigator.of(context, rootNavigator: true).push(route);
                  },
                ),
                settingDivider(context),
//              settingTitle(context, title: 'Support And Community'),
                settingListTile(context,
                    icon: FontAwesomeIcons.directions,
                    title: 'Guided Tour',
                    onTap: null),
//              settingListTile(
//                context,
//                icon: EvaIcons.questionMarkCircleOutline,
//                title: 'FAQ / Get Help',
//                onTap: () {
//                  final route = SharedAxisPageRoute(
//                      page: AboutScreen(), transitionType: _transitionType);
//                  Navigator.of(context, rootNavigator: true).push(route);
//                },
//              ),
//              settingListTile(context,
//                  icon: EvaIcons.moreHorizotnalOutline,
//                  title: 'More ',
//                  onTap: null),

//              settingListTile(context,
//                  icon: FontAwesomeIcons.link,
//                  title: 'iMomentum Website',
//                  onTap: null),

                settingDivider(context),
//              Flexible(
//                child: ListTile(
//                  leading: Avatar(
//                    photoUrl: user.photoUrl,
//                    radius: 13,
//                  ),
//                  title: user.displayName == null
//                      ? Text('Profile')
//                      : Text(user.displayName),
//                  trailing: Icon(Icons.chevron_right,
//                      color: _darkTheme ? darkButton : lightButton),
//                  onTap: () {
//                    final route = SharedAxisPageRoute(
//                        page: UserScreen(user: user),
//                        transitionType: _transitionType);
//                    Navigator.of(context, rootNavigator: true).push(route);
//                  },
//                ),
//              ),
//              settingDivider(context),
                settingListTile(context,
                    icon: EvaIcons.logOutOutline,
                    title: 'Sign Out',
                    onTap: () => _confirmSignOut(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget settingTitle(BuildContext context, {String title}) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return ListTile(
      leading: Text(
        title,
        style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: _darkTheme ? darkThemeButton : lightThemeButton),
      ),
    );
  }

  /// at the beginning I wrapped all ListTile in a Flexible and all in a Column,
  /// it was ok, but later when I add a Tooltip, the Flexible becomes the child
  /// of ToolTip and I got error saying incorrect use of parent widget.

  Widget settingListTile(BuildContext context,
      {IconData icon, String title, Function onTap}) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return ListTile(
        leading: Icon(
          icon,
          color: _darkTheme ? darkThemeButton : lightThemeButton,
        ),
        title: Text(title, style: TextStyle(fontSize: 15)),
        trailing: Icon(Icons.chevron_right,
            color: _darkTheme ? darkThemeButton : lightThemeButton),
        onTap: onTap);
  }

  Widget settingDivider(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Divider(
        indent: 50,
        endIndent: 50,
        color: _darkTheme ? Colors.white38 : Colors.black12,
        thickness: 1);
  }

  Future<void> _onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }

  Future<void> _onFocusChanged(
      bool value, FocusNotifier focusNotifier, BuildContext context) async {
    //save settings
    focusNotifier.setFocus(value);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('focusMode', value);

    value
        ? Flushbar(
            isDismissible: true,
            mainButton: FlatButton(
                onPressed: () => Navigator.pop(context),
                child: FlushBarButtonChild(title: 'OK')),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            borderRadius: 15,
            flushbarPosition: FlushbarPosition.BOTTOM,
            flushbarStyle: FlushbarStyle.FLOATING,
            backgroundGradient:
                LinearGradient(colors: [Color(0xF00f4c75), Color(0xF03282b8)]),
            duration: Duration(seconds: 6),
            titleText: Text(
                'This will enable productivity features on home screen.',
                style: KFlushBarTitle),
            messageText: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                'Focus on what is the most important to us.',
                style: KFlushBarMessage,
              ),
            ),
          ).show(context)
        : Flushbar(
            isDismissible: true,
            mainButton: FlatButton(
              onPressed: () => Navigator.pop(context),
              child: FlushBarButtonChild(title: 'OK'),
            ),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            borderRadius: 15,
            flushbarPosition: FlushbarPosition.BOTTOM,
            flushbarStyle: FlushbarStyle.FLOATING,
            backgroundGradient:
                LinearGradient(colors: [Color(0xF00f4c75), Color(0xF03282b8)]),
            duration: Duration(seconds: 6),
            titleText: Text(
              'This will hide productivity features on home screen.',
              style: KFlushBarTitle,
            ),
            messageText: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text('We all need some downtime in a day.',
                  style: KFlushBarMessage),
            ),
          ).show(context);
  }

  Future<void> _onRandomChanged(
      bool value, RandomNotifier randomNotifier, BuildContext context) async {
    //change the value
    randomNotifier.setRandom(value);
    //save settings
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('randomOn', value);

    value
        ? Flushbar(
            isDismissible: true,
            mainButton: FlatButton(
              onPressed: () => Navigator.pop(context),
              child: FlushBarButtonChild(title: 'OK'),
            ),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            borderRadius: 15,
            flushbarPosition: FlushbarPosition.BOTTOM,
            flushbarStyle: FlushbarStyle.FLOATING,
            backgroundGradient:
                LinearGradient(colors: [Color(0xF00f4c75), Color(0xF03282b8)]),
            duration: Duration(seconds: 6),
            titleText: Text(
              'This will enable a new photo to show every time when opening iMomentum App',
              style: KFlushBarTitle,
            ),
            messageText: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                'You can double tap on screen to change photo anytime.',
                style: KFlushBarMessage,
              ),
            ),
          ).show(context)
        : Flushbar(
            isDismissible: true,
            mainButton: FlatButton(
              onPressed: () => Navigator.pop(context),
              child: FlushBarButtonChild(title: 'OK'),
            ),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            borderRadius: 15,
            flushbarPosition: FlushbarPosition.BOTTOM,
            flushbarStyle: FlushbarStyle.FLOATING,
            backgroundGradient:
                LinearGradient(colors: [Color(0xF00f4c75), Color(0xF03282b8)]),
            duration: Duration(seconds: 6),
            titleText: Text('This will set background photo as a fixed one.',
                style: KFlushBarTitle),
            messageText: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                  'You can choose your favourite photo and change the photo anytime.',
                  style: KFlushBarMessage),
            ),
          ).show(context);
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
}
