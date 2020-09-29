// library top_sheet; // can't have have this

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/utils/package/bubble.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/utils/top_sheet.dart';

@immutable
class TopSheetLight extends StatefulWidget {
  final TopSheetDirection direction;
  final Color backgroundColor;
  final Widget child;
  final Color containerColor;

  TopSheetLight(
      {this.child, this.direction, this.backgroundColor, this.containerColor});

  @override
  _TopSheetLightState createState() => _TopSheetLightState();

  static Future<T> show<T extends Object>({
    @required BuildContext context,
    @required Widget child,
    direction = TopSheetDirection.TOP,
    backgroundColor = Colors
        .transparent, //this is the background color to cover the part that are not in top sheet
  }) {
    // final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    // bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Navigator.push<T>(
        context,
        PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return TopSheetLight(
                child: Container(
                  margin: EdgeInsets.only(left: 15.0, right: 15, top: 40),
                  child: Bubble(
                    alignment: Alignment.topRight,
                    nipWidth: 15,
                    nipHeight: 10,
//                    stick: true,
                    margin: BubbleEdges.only(top: 10),
                    nip: BubbleNip.rightTop,
                    color: lightThemeNoPhotoColor,
                    child: child,
                  ),

//                  CustomPaint(
//                    painter: CustomChatBubble(
//                        color: Colors.black38, isOwn: true),
//                    child: Container(
//                      padding: EdgeInsets.all(8),
//                      child: SafeArea(
//                        child: child,
//                      ),
//                    ),
//                  ),
                ),
                direction: direction,
                backgroundColor: backgroundColor,
              );

              ///tried to add StatefulBuilder, but the switch in top sheet still not change
            },
            opaque: false));
  }
}

class _TopSheetLightState extends State<TopSheetLight>
    with TickerProviderStateMixin {
  Animation<double> _animation;
  Animation<double> _opacityAnimation;
  AnimationController _animationController;

  final _childKey = GlobalKey();

  double get _childHeight {
    final RenderBox renderBox = _childKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  bool get _dismissUnderway =>
      _animationController.status == AnimationStatus.reverse;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _animation = Tween<double>(begin: _isDirectionTop ? -1 : 1, end: 0)
        .animate(_animationController);

    _opacityAnimation =
        Tween<double>(begin: 0, end: 0.3).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) Navigator.pop(context);
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_dismissUnderway) return;

    var change = details.primaryDelta / (_childHeight ?? details.primaryDelta);
    if (_isDirectionTop)
      _animationController.value += change;
    else
      _animationController.value -= change;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dismissUnderway) return;

    if (details.velocity.pixelsPerSecond.dy > 0 && _isDirectionTop) return;
    if (details.velocity.pixelsPerSecond.dy < 0 && !_isDirectionTop) return;

    if (details.velocity.pixelsPerSecond.dy > 700) {
      final double flingVelocity =
          -details.velocity.pixelsPerSecond.dy / _childHeight;
      if (_animationController.value > 0.0)
        _animationController.fling(velocity: flingVelocity);
    } else if (_animationController.value < 0.5) {
      if (_animationController.value > 0.0)
        _animationController.fling(velocity: -1.0);
    } else
      _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: onBackPressed,
      child: GestureDetector(
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragEnd: _handleDragEnd,
        child: AnimatedBuilder(
          animation: _opacityAnimation,
          builder: (context, child) {
            return Scaffold(
              backgroundColor:
                  widget.backgroundColor.withOpacity(_opacityAnimation.value),
              body: Column(
                key: _childKey,
                children: <Widget>[
                  _isDirectionTop ? Container() : Spacer(),
                  AnimatedBuilder(
                      animation: _animation,
                      builder: (context, _) {
                        return Transform(
                          transform: Matrix4.translationValues(
                              0.0, width * _animation.value, 0.0),
                          child: Container(child: widget.child),
                        );
                      }),
                ],
              ),
            );
          },
        ),
        excludeFromSemantics: true,
      ),
    );
  }

  bool get _isDirectionTop {
    return widget.direction == TopSheetDirection.TOP;
  }

  Future<bool> onBackPressed() {
    _animationController.reverse();
    return Future<bool>.value(false);
  }
}
