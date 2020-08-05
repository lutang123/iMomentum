import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ClockBottomToday extends StatelessWidget {
  const ClockBottomToday({Key key, @required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Text(
            'Focused Task',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AutoSizeText(
              text,
              maxLines: 4,
              minFontSize: 15,
              maxFontSize: 18,
              textAlign: TextAlign.center,
              style: TextStyle(
//                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
