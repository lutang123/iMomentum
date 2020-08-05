import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                style: GoogleFonts.varelaRound(
                  fontWeight: FontWeight.w600,
                  fontSize: 55.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                text2,
                style: GoogleFonts.varelaRound(
                  fontWeight: FontWeight.w600,
                  fontSize: 35.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
