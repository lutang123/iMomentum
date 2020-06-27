import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class TypeWriterQuestion extends StatelessWidget {
  const TypeWriterQuestion({Key key, @required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return TypewriterAnimatedTextKit(
      isRepeatingAnimation: false,
      totalRepeatCount: 1,
      text: [text],
      textAlign: TextAlign.center,
      textStyle: TextStyle(
          color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
    );
  }
}
