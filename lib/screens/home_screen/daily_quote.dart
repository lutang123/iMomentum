import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DailyQuote extends StatelessWidget {
  const DailyQuote({Key key, @required this.title, this.author})
      : super(key: key);

  final String title;
  final String author;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15.0),
        child: AutoSizeText(
          author == null || author == '' ? '"$title"' : '"$title -- $author"',
          maxLines: 3,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
