//import 'dart:math' as math;
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
//import 'package:iMomentum/app/services/multi_notifier.dart';
//import 'package:provider/provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import '../../app/common_widgets/container_linear_gradient.dart';
//import '../../app/constants/constants.dart';
//import '../../app/constants/theme.dart';
//
//class NotesDrawer extends StatefulWidget {
//  final Widget child;
//
//  const NotesDrawer({Key key, this.child}) : super(key: key);
//
//  static NotesDrawerState of(BuildContext context) =>
//      context.findAncestorStateOfType<NotesDrawerState>();
//
//  @override
//  NotesDrawerState createState() => NotesDrawerState();
//}
//
//class NotesDrawerState extends State<NotesDrawer>
//    with SingleTickerProviderStateMixin {
//  AnimationController animationController;
//  bool _canBeDragged = false;
//  final double maxSlide = 300.0;
//
//  @override
//  void initState() {
//    super.initState();
//    animationController = AnimationController(
//      vsync: this,
//      duration: Duration(milliseconds: 250),
//    );
//  }
//
//  void open() => animationController.forward();
//
//  @override
//  void dispose() {
//    animationController.dispose();
//    super.dispose();
//  }
//
//  void toggle() => animationController.isDismissed
//      ? animationController.forward()
//      : animationController.reverse();
//
//  @override
//  Widget build(BuildContext context) {
//    final themeNotifier = Provider.of<ThemeNotifier>(context);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//    final randomNotifier = Provider.of<RandomNotifier>(context);
//    bool _randomOn = (randomNotifier.getRandom() == true);
//    final imageNotifier = Provider.of<ImageNotifier>(context);
//    return GestureDetector(
//      onHorizontalDragStart: _onDragStart,
//      onHorizontalDragUpdate: _onDragUpdate,
//      onHorizontalDragEnd: _onDragEnd,
//      behavior: HitTestBehavior.translucent,
//      onTap: toggle,
//      child: AnimatedBuilder(
//        animation: animationController,
//        builder: (context, _) {
//          return Stack(
//            fit: StackFit.expand,
//            children: <Widget>[
//              BuildPhotoView(
//                imageUrl: _randomOn
//                    ? ImageUrl.randomImageUrl
//                    : imageNotifier.getImage(),
//              ),
////              Image.network(ImageUrl.randomImageUrl, fit: BoxFit.cover),
//              ContainerLinearGradient(),
//              Material(
//                color: Colors.transparent,
//                child: Stack(
//                  children: <Widget>[
//                    Transform.translate(
//                      offset:
//                          Offset(maxSlide * (animationController.value - 1), 0),
//                      child: Transform(
//                        transform: Matrix4.identity()
//                          ..setEntry(3, 2, 0.001)
//                          ..rotateY(
//                              math.pi / 2 * (1 - animationController.value)),
//                        alignment: Alignment.centerRight,
//                        child: MyNotesDrawer(),
//                      ),
//                    ),
//                    Transform.translate(
//                      offset: Offset(maxSlide * animationController.value, 0),
//                      child: Transform(
//                        transform: Matrix4.identity()
//                          ..setEntry(3, 2, 0.001)
//                          ..rotateY(-math.pi * animationController.value / 2),
//                        alignment: Alignment.centerLeft,
//                        child: widget.child,
//                      ),
//                    ),
//                    Positioned(
//                      top: MediaQuery.of(context).padding.top - 1.5,
//                      left: 22.0 + animationController.value * maxSlide,
//                      child: IconButton(
////                        iconSize: 25,
//                        icon: FaIcon(FontAwesomeIcons.bars),
//                        onPressed: toggle,
//                        color: _darkTheme ? Colors.white : lightButton,
//                      ),
//                    ),
////                    Positioned(
////                      top: 16.0 + MediaQuery.of(context).padding.top,
////                      left: animationController.value *
////                          MediaQuery.of(context).size.width,
////                      width: MediaQuery.of(context).size.width,
////                      child: Text(
////                        '',
////                        style: Theme.of(context).primaryTextTheme.bodyText2,
////                        textAlign: TextAlign.center,
////                      ),
////                    ),
//                  ],
//                ),
//              ),
//            ],
//          );
//        },
//      ),
//    );
//  }
//
//  void _onDragStart(DragStartDetails details) {
//    bool isDragOpenFromLeft = animationController.isDismissed;
//    bool isDragCloseFromRight = animationController.isCompleted;
//    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
//  }
//
//  void _onDragUpdate(DragUpdateDetails details) {
//    if (_canBeDragged) {
//      double delta = details.primaryDelta / maxSlide;
//      animationController.value += delta;
//    }
//  }
//
//  void _onDragEnd(DragEndDetails details) {
//    //I have no idea what it means, copied from Drawer
//    double _kMinFlingVelocity = 365.0;
//
//    if (animationController.isDismissed || animationController.isCompleted) {
//      return;
//    }
//    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
//      double visualVelocity = details.velocity.pixelsPerSecond.dx /
//          MediaQuery.of(context).size.width;
//
//      animationController.fling(velocity: visualVelocity);
//    } else if (animationController.value < 0.5) {
//      animationController.reverse();
//    } else {
//      animationController.forward();
//    }
//  }
//}
//
//class MyNotesDrawer extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final themeNotifier = Provider.of<ThemeNotifier>(context);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//
//    return SizedBox(
//      width: 300,
//      height: double.infinity,
//      child: Material(
//        color: _darkTheme ? darkDrawer : lightSurface,
//        child: SingleChildScrollView(
//          child: SafeArea(
//            child: Column(
//              children: <Widget>[
//                Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisSize: MainAxisSize.max,
//                  children: [
//                    SizedBox(height: 30),
//                    ListTile(
//                      leading: Text(
//                        'iMomentum Notes',
//                        style: TextStyle(
//                            fontSize: 17,
//                            fontWeight: FontWeight.w600,
//                            color: _darkTheme ? darkButton : lightButton),
//                      ),
//                    ),
//                    ListTile(
//                      leading: Icon(
//                        FontAwesomeIcons.stickyNote,
//                        color: _darkTheme ? darkButton : lightButton,
//                      ),
//                      title: Text('Notes'),
//                    ),
//                    ListTile(
//                      leading: Icon(
//                        FontAwesomeIcons.bell,
//                        color: _darkTheme ? darkButton : lightButton,
//                      ),
//                      title: Text('Reminders'),
//                    ),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.end,
//                      children: <Widget>[
//                        SizedBox(
//                          width: 230,
//                          child: Divider(
//                              color:
//                                  _darkTheme ? Colors.white24 : Colors.black12,
//                              thickness: 1),
//                        ),
//                      ],
//                    ),
//                    ListTile(
//                      leading: Text(
//                        'LABELS',
//                        style: TextStyle(
//                            fontSize: 15,
//                            color: _darkTheme ? darkButton : lightButton),
//                      ),
//                    ),
//                    ListTile(
//                      leading: Icon(
//                        FontAwesomeIcons.tag,
//                        color: _darkTheme ? darkButton : lightButton,
//                      ),
//                      title: Text('Important'),
//                    ),
//                    ListTile(
//                      leading: Icon(
//                        FontAwesomeIcons.tag,
//                        color: _darkTheme ? darkButton : lightButton,
//                      ),
//                      title: Text('Personal'),
//                    ),
//                    ListTile(
//                      leading: FaIcon(
//                        FontAwesomeIcons.edit,
//                        color: _darkTheme ? darkButton : lightButton,
//                      ),
//                      title: Text('Create/Edit labels'),
//                      onTap: () => null,
//                    ),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.end,
//                      children: <Widget>[
//                        SizedBox(
//                          width: 230,
//                          child: Divider(
//                              color:
//                                  _darkTheme ? Colors.white24 : Colors.black12,
//                              thickness: 1),
//                        ),
//                      ],
//                    ),
//                    ListTile(
//                      leading: FaIcon(
//                        FontAwesomeIcons.archive,
//                        color: _darkTheme ? darkButton : lightButton,
//                      ),
//                      title: Text('Archive'),
//                      onTap: () => null,
//                    ),
//                    ListTile(
//                      leading: FaIcon(
//                        FontAwesomeIcons.trashAlt,
//                        color: _darkTheme ? darkButton : lightButton,
//                      ),
//                      title: Text('Bin'),
//                      onTap: () => null,
//                    ),
//
////                    ListTile(
////                      leading: Icon(
////                        Icons.info_outline,
////                        color: _darkTheme ? darkButton : lightButton,
////                      ),
////                      title: Text('About us'),
////                      onTap: () {
////                        Navigator.push(context,
////                            MaterialPageRoute(builder: (_) => AboutScreen()));
////                      },
////                    ),
//                  ],
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//
//  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
//    (value)
//        ? themeNotifier.setTheme(darkTheme)
//        : themeNotifier.setTheme(lightTheme);
//    var prefs = await SharedPreferences.getInstance();
//    prefs.setBool('darkMode', value);
//  }
//}
