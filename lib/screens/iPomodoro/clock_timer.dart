import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/constants_style.dart';

import 'countdown_circle.dart';

class ClockTimer extends StatelessWidget {
  const ClockTimer(
      {Key key,
      this.text1,
      this.text2,
      this.duration,
      this.animationController})
      : super(key: key);

  final String text1;
  final String text2;
  final Duration duration;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 2,
      width: size.height / 2,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox.expand(
            child: CountdownCircle(
              duration: duration,
              animationController: animationController,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(text1, style: KTimer),
              SizedBox(height: 20),
              Text(text2, style: KTimerSubtitle),
            ],
          ),
        ],
      ),
    );
  }
}
