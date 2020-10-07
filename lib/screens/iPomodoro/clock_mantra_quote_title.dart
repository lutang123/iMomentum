import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/constants_style.dart';

class PomodoroTitle extends StatelessWidget {
  const PomodoroTitle({
    this.title,
    this.subtitle,
    Key key,
  }) : super(key: key);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(title, style: KPomodoroTitle),
        SizedBox(height: 20),
        Text(subtitle, textAlign: TextAlign.center, style: KPomodoroSubtitle),
      ],
    );
  }
}
