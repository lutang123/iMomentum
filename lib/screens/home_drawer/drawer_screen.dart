import 'dart:math' as math;
import 'package:animations/animations.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/avatar.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/my_tooltip.dart';
import 'package:iMomentum/app/common_widgets/setting_switch.dart';
import 'package:iMomentum/app/constants/image_path.dart';
import 'package:iMomentum/app/constants/my_strings.dart';
import 'package:iMomentum/app/utils/shared_axis.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/home_drawer/mantras_screen.dart';
import 'package:iMomentum/screens/home_drawer/quote_screen.dart';
import 'package:iMomentum/screens/home_drawer/balance_screen.dart';
import 'package:iMomentum/screens/home_drawer/unsplash/image_gallery.dart';
import 'package:iMomentum/screens/home_drawer/user_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/constants/constants_style.dart';
import '../../app/constants/theme.dart';
import 'about_screen.dart';
import 'package:iMomentum/app/utils/extension_firstCaps.dart';

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
    ///this one, it seems doesn't matter listen is false or not.
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    ///we can not set the following two as listen : false otherwise UI will not change.
    final randomNotifier = Provider.of<RandomNotifier>(context);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context);

    double height = MediaQuery.of(context).size.height;
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
                    ? ImagePath.randomImageUrl
                    : imageNotifier.getImage(),
              ),
              Container(
                  decoration: BoxDecoration(
                      gradient: _darkTheme
                          ? KBackgroundGradientDark
                          : KBackgroundGradient)),
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
                      top: height > 700
                          ? MediaQuery.of(context).padding.top - 10
                          : MediaQuery.of(context).padding.top,
                      left: 5 + animationController.value * maxSlide,
                      child: buildIconButtonDrawer(_darkTheme),
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

  IconButton buildIconButtonDrawer(bool _darkTheme) {
    return IconButton(
        iconSize: 28,
        icon: FaIcon(FontAwesomeIcons.bars),
        onPressed: toggle,
        color: _darkTheme ? darkThemeWords : lightThemeButton);
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
    final User user = FirebaseAuth.instance.currentUser;

    ///this will get error because user name might be null
//    final String firstName =
//    user.displayName.substring(0, user.displayName.indexOf(' '));

    /// do not set listen to false here
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    ///when set listen: false, the switch button does not change
    final focusNotifier = Provider.of<FocusNotifier>(context);
    bool _focusModeOn = focusNotifier.getFocus();

    ///this one listen to false or not does not seem to matter, but why??
    final randomNotifier = Provider.of<RandomNotifier>(context);
    bool _randomOn = randomNotifier.getRandom();

    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: 300,
      height: double.infinity,
      child: Material(
        color: _darkTheme ? darkThemeDrawer : lightThemeDrawer,

        ///two ways: either make it flexible, but then if keyboard pops up, everything kind of squeeze together;
        ///or make it scrollable, but can't have spacer or flexible or expanded,
        ///unless using layout builder, but that one can only have one expanded. see notes in Add note screen.
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                settingTitle(context, title: 'Settings'),
                SettingSwitch(
                  size: 23,
                  icon: FontAwesomeIcons.adjust,
                  title: 'Dark Theme',
                  value: _darkTheme,
                  onChanged: (val) {
                    _darkTheme = val;
                    _onThemeChanged(val, themeNotifier);
                  },
                ),
                MyToolTip(
                  message: Strings.focusSwitchTip,
                  child: SettingSwitch(
                    icon: EvaIcons.bulbOutline,
                    title: 'Focus Mode',
                    value: _focusModeOn,
                    onChanged: (val) {
                      _focusModeOn = val;
                      _onFocusChanged(context, val, focusNotifier);
                    },
                  ),
                ),
                MyToolTip(
                  message: Strings.photoSwitchTip,
                  child: SettingSwitch(
                    icon: EvaIcons.shuffle2Outline,
                    title: 'Shuffle Photos',
                    value: _randomOn,
                    onChanged: (val) {
                      _randomOn = val;
                      _onRandomChanged(context, val, randomNotifier);
                    },
                  ),
                ),
                settingDivider(context),
                height > 700
                    ? settingTitle(context, title: 'Customizations')
                    : Container(),
                settingListTile(
                  context,
                  icon: EvaIcons.imageOutline,
                  title: 'Choose Your Favourite Photo',
                  onTap: () {
                    final route = SharedAxisPageRoute(

                        ///this page get context from HomeDrawer build, same as all other page
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
                settingListTile(
                  context,
                  icon: EvaIcons.clockOutline,
                  title: 'Schedule Focus Mode displaying time',
                  onTap: () {
                    final route = SharedAxisPageRoute(
                        page: ScheduleFocusTime(),
                        transitionType: _transitionType);
                    Navigator.of(context, rootNavigator: true).push(route);
                  },
                ),
                settingDivider(context),
                ListTile(
                  leading: Avatar(
                    photoUrl: user.photoURL,
                    radius: 13,
                  ),
                  title: user.displayName == null || user.displayName.isEmpty
                      ? Text('User Profile',
                          style: _listTitleTextStyle(_darkTheme))
                      : Text(user.displayName.firstCaps,
                          style: _listTitleTextStyle(_darkTheme)),
                  trailing: Icon(Icons.chevron_right,
                      color: _darkTheme ? darkThemeButton : lightThemeButton),
                  onTap: () {
                    final route = SharedAxisPageRoute(
                        page: UserScreen(), transitionType: _transitionType);
                    Navigator.of(context, rootNavigator: true).push(route);
                  },
                ),
                settingListTile(
                  context,
                  icon: FontAwesomeIcons.directions,
                  title: 'Contact Us',
                  onTap: () {
                    final route = SharedAxisPageRoute(
                        page: AboutScreen(), transitionType: _transitionType);
                    Navigator.of(context, rootNavigator: true).push(route);
                  },
                ),
                // settingListTile(
                //   context,
                //   icon: FontAwesomeIcons.directions,
                //   title: 'Contact Us',
                //   onTap: () {
                //     final route = SharedAxisPageRoute(
                //         page: AboutScreen(), transitionType: _transitionType);
                //     Navigator.of(context, rootNavigator: true).push(route);
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _listTitleTextStyle(bool _darkTheme) {
    return TextStyle(
        fontSize: 16, color: _darkTheme ? darkThemeWords : lightThemeWords);
  }

  /// this is StatelessWidget, all the method outside of build do not have context, so we need to add BuildContext context
  /// and it will still show flush bar
  ListTile settingTitle(BuildContext context, {String title}) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return ListTile(
      leading: Text(
        title,
        style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: _darkTheme ? darkThemeWords : lightThemeWords),
      ),
    );
  }

  /// at the beginning I wrapped all ListTile in a Flexible and all in a Column,
  /// it was ok, but later when I add a Tooltip, the Flexible becomes the child
  /// of ToolTip and I got error saying incorrect use of parent widget.

  ListTile settingListTile(BuildContext context,
      {IconData icon, String title, Function onTap}) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return ListTile(
        leading: Icon(
          icon,
          color: _darkTheme ? darkThemeButton : lightThemeButton,
        ),
        title: Text(title, style: _listTitleTextStyle(_darkTheme)),
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
        color: _darkTheme ? darkThemeDivider : lightThemeDivider,
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
      BuildContext context, bool value, FocusNotifier focusNotifier) async {
    focusNotifier.setFocus(value); //change the value
    var prefs = await SharedPreferences.getInstance(); //save settings
    prefs.setBool('focusMode', value);
    value
        ? _showFlushBar(
                title: Strings.focusSwitchOnTitle,
                message: Strings.focusSwitchOnSubTitle)
            .show(context)
        : _showFlushBar(
                title: Strings.focusSwitchOffTitle,
                message: Strings.focusSwitchOFFSubTitle)
            .show(context);
  }

  Future<void> _onRandomChanged(
      BuildContext context, bool value, RandomNotifier randomNotifier) async {
    randomNotifier.setRandom(value);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('randomOn', value);

    value
        ? _showFlushBar(
                title: Strings.shufflePhotoSwitchOnTitle,
                message: Strings.shufflePhotoSwitchOnSubTitle)
            .show(context)
        : _showFlushBar(
                title: Strings.shufflePhotoSwitchOffTitle,
                message: Strings.shufflePhotoSwitchOFFSubTitle)
            .show(context);
  }

  Flushbar _showFlushBar({@required title, @required message}) {
    ///should not add this line, because when it's going to be automatically
    ///dismissed, and then press this will take to black screen.
    // Navigator.pop(context);
    return Flushbar(
      isDismissible: true,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(8),
      borderRadius: 15,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundGradient: KFlushBarGradient,
      duration: Duration(seconds: 5),
      icon: Icon(
        EvaIcons.infoOutline,
        color: Colors.white,
      ),
      titleText: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(title, style: KFlushBarTitle),
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(left: 3),
        child: Text(
          message,
          style: KFlushBarMessage,
        ),
      ),
    );
  }
}
