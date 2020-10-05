import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/my_stack_screen.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/utils/extension_clockFmt.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/utils/pages_routes.dart';
import 'package:iMomentum/app/utils/top_sheet.dart';
import 'package:iMomentum/screens/iPomodoro/top_sheet_pomodoro_info.dart';
import 'package:provider/provider.dart';
import 'clock_bottom.dart';
import 'clock_start.dart';
import 'clock_timer_screen.dart';
import 'clock_mantra_quote_title.dart';

//https://momentumdash.com/blog/pomodoro-timer

class PomodoroBaseScreen extends StatelessWidget {
  final Widget topRow;
  final Widget titleWidget;
  final Widget bigCircle;
  final Widget timerButton;
  final Widget bottomWidget;

  const PomodoroBaseScreen(
      {Key key,
      this.topRow,
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
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40,
                  child: Center(child: topRow),
                ),
                SizedBox(height: 20),
                titleWidget,
                Container(
                  height: width,
                  width: width,
                  child: bigCircle,
                ),
                timerButton,
                SizedBox(height: 10),
                bottomWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
