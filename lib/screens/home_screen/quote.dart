import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/data/quote_list.dart';
import 'package:iMomentum/app/services/global_key.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:iMomentum/app/utils/show_more_text_pop_up.dart';

//if want to show more.
///https://stackoverflow.com/questions/49572747/flutter-how-to-hide-or-show-more-text-within-certain-length
///https://pub.dev/packages/expand_widget
///https://pub.dev/packages/expandable
enum QuoteLoadingState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

//Unhandled Exception: setState() called after dispose(): _APIQuoteState#72c4d(lifecycle state: defunct, not mounted)
// This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer or an animation callback.
// The preferred solution is to cancel the timer or stop listening to the animation in the dispose() callback. Another solution is to check the "mounted" property of this object before calling setState() to ensure the object is still in the tree.
// This error might indicate a memory leak if setState() is being called because another object is retaining a reference to this State object after it has been removed from the tree. To avoid memory leaks, consider breaking the reference to this object during dispose().

class APIQuote extends StatefulWidget {
  @override
  _APIQuoteState createState() => _APIQuoteState();
}

class _APIQuoteState extends State<APIQuote> {
  QuoteLoadingState _state = QuoteLoadingState.NOT_DOWNLOADED;
  String dailyQuote;
  String author;

  @override
  void initState() {
    _fetchQuote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _state == QuoteLoadingState.FINISHED_DOWNLOADING
        ? DailyQuote(title: dailyQuote, author: author)
        : _state == QuoteLoadingState.DOWNLOADING
            ? Center(child: CircularProgressIndicator())

            ///if error we return default;
            : DailyQuote(
                title: DefaultQuoteList().getQuote().body,
                author: DefaultQuoteList().getQuote().author);
  }

//http://quotes.rest/qod/categories.json
  Future<void> _fetchQuote() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    // if (mounted) {
    setState(() {
      _state = QuoteLoadingState.DOWNLOADING;
    });
    try {
      final response = await http
          .get('http://quotes.rest/qod.json?maxlength=100&category=inspire');
      print(
          'response.statusCode in quote: ${response.statusCode}'); //429, meaning too many request
      if (response.statusCode == 200) {
        var quoteData = json.decode(response.body)['contents']['quotes'][0];

        ///??
        // if (mounted) {
        setState(() {
          dailyQuote = quoteData['quote'];
          author = quoteData['author'];
        });
        // }
      } else {
        setState(() {
          dailyQuote = DefaultQuoteList().getQuote().body;
          author = DefaultQuoteList().getQuote().author;
        });
        //        throw Exception('Failed to load quote');
      }
    } catch (e) {
      setState(() {
        dailyQuote = DefaultQuoteList().getQuote().body;
        author = DefaultQuoteList().getQuote().author;
      });
      print('error in fetching quote: $e');
    }

    setState(() {
      _state = QuoteLoadingState.FINISHED_DOWNLOADING;
    });
  }
  // }
}

class DailyQuote extends StatelessWidget {
  DailyQuote(
      {Key key, @required this.title, this.author, this.bottomPadding = 15})
      : super(key: key);

  final String title;
  final String author;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: bottomPadding),
        child: (title.length) < 90
            ? Text(
                author == null || author == ''
                    ? '"$title"'
                    : '"$title -- $author"',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: KQuote,
              )
            : _richText(context),
      ),
    );
  }

  Widget _richText(BuildContext context) {
    return RichText(
      maxLines: 2,
      textAlign: TextAlign.center,
      text: TextSpan(
        style: KQuote,
        children: <TextSpan>[
          TextSpan(text: '"${title.substring(0, 90)}'),
          TextSpan(
              text: '...',
              style: KQuoteDot,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _showMoreText(
                      author == null || author == ''
                          ? '"$title"'
                          : '"$title -- $author"',
                      context);
                }),
          TextSpan(text: '"'),
        ],
      ),
    );
  }

  final GlobalKey key = RIKeys.riKey3;
  void _showMoreText(String text, BuildContext context) {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: text,
        textStyle: TextStyle(color: Colors.white),
        height: 200,
        width: 100,
        backgroundColor: darkThemeNoPhotoColor,
        padding: EdgeInsets.all(6.0),
        borderRadius: BorderRadius.circular(10.0));

    /// show the popup for specific widget
    popup.show(
      widgetKey: key,
    );
  }
}

class RestQuoteClass extends StatelessWidget {
  RestQuoteClass({Key key, @required this.title, this.author})
      : super(key: key);

  final String title;
  final String author;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15.0),
        child: (title.length) < 100
            ? Text(
                author == null || author == ''
                    ? '"$title"'
                    : '"$title -- $author"',
                textAlign: TextAlign.center,
                style: KQuote,
              )
            : _richText(context),
      ),
    );
  }

  Widget _richText(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: KQuote,
        children: <TextSpan>[
          TextSpan(text: '"${title.substring(0, 99)}'),
          TextSpan(
              text: '...',
              style: KQuoteDot,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _showMoreText(
                      author == null || author == ''
                          ? '"$title"'
                          : '"$title -- $author"',
                      context);
                }),
          TextSpan(text: '"'),
        ],
      ),
    );
  }

  ///notes on show more text

  final GlobalKey key = RIKeys.riKey2;
  void _showMoreText(String text, BuildContext context) {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: text,
        textStyle: TextStyle(color: Colors.white),
        height: 200,
        width: 100,
        backgroundColor: darkThemeNoPhotoColor,
        padding: EdgeInsets.all(6.0),
        borderRadius: BorderRadius.circular(10.0));

    /// show the popup for specific widget
    popup.show(
      widgetKey: key,
    );
  }
}
