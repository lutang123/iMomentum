import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iMomentum/app/common_widgets/my_sizedbox.dart';
import 'package:iMomentum/app/common_widgets/my_stack_screen.dart';

//https://momentumdash.com/blog/pomodoro-timer

class PomodoroBaseScreen extends StatelessWidget {
  final bool hasLeading;
  final Widget leadingWidget;
  final Widget actionWidget;
  final Widget titleWidget;
  final Widget bigCircle;
  final Widget timerButton;
  final Widget bottomWidget;

  const PomodoroBaseScreen(
      {Key key,
      this.hasLeading = false,
      this.leadingWidget,
      this.actionWidget,
      this.titleWidget,
      this.bigCircle,
      this.timerButton,
      this.bottomWidget})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    return MyStackScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: buildAppBar(),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PomodoroTopSizedBox(), // 10 : 0
                titleWidget,
                PomodoroMiddleSizedBox(), // 30 : 20 : 10
                Container(
                  height: width,
                  width: width,
                  child: bigCircle,
                ),
                timerButton,
                PomodoroBottomSizedBox(), // 30 : 15 : 0
                bottomWidget, //this already has 15 padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      brightness: Brightness.dark,
      automaticallyImplyLeading: hasLeading,
      leading: leadingWidget,
      actions: [
        actionWidget,
      ],
    );
  }
}
