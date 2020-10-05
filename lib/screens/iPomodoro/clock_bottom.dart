import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/constants_style.dart';

class ClockBottomToday extends StatelessWidget {
  const ClockBottomToday({Key key, @required this.text, this.maxLines = 4})
      : super(key: key);

  final String text;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Text(
            'Focused Task',
            style: KPomodoroBottomTitle,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: AutoSizeText(text,
                maxLines: maxLines,
                minFontSize: 16,
                maxFontSize: 18,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: KPomodoroBottomSubtitle),
          ),
        ],
      ),
    );
  }
}
