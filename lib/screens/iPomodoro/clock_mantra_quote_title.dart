import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';
import 'package:iMomentum/app/constants/theme.dart';

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
        SizedBox(height: 20),
      ],
    );
  }
}
