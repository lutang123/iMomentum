import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DailyQuote extends StatelessWidget {
  const DailyQuote({
    Key key,
    @required this.dailyQuote,
  }) : super(key: key);

  final String dailyQuote;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: AutoSizeText(
              '"$dailyQuote"',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
