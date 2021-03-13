import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/data/quote_list.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/services/my_global_keys.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:iMomentum/app/utils/package/show_more_text_pop_up.dart';
import 'package:provider/provider.dart';

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

  int lengthLimit = 65;
  void getLengthLimit(double height) {
    if (height >= 850) {
      lengthLimit = 75;
    } else if ((height < 850) && (height > 700)) {
      lengthLimit = 70;
    } else if (height < 700) {
      lengthLimit = 65;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    getLengthLimit(height);

    return _state == QuoteLoadingState.FINISHED_DOWNLOADING
        ? DailyQuoteUI(
            lengthLimit: lengthLimit,
            title: dailyQuote,
            author: author,
            key: GlobalKey(),
          )
        : _state == QuoteLoadingState.DOWNLOADING
            ? Center(child: CircularProgressIndicator())

            ///if error we return default;
            : DailyQuoteUI(
                lengthLimit: lengthLimit,
                title: DefaultQuoteList().getQuote().body,
                author: DefaultQuoteList().getQuote().author,
                key: GlobalKey(),
              );
  }

  ///Unhandled Exception: setState() called after dispose(): _APIQuoteState#dd27c(lifecycle state: defunct, not mounted)
//http://quotes.rest/qod/categories.json
  Future<void> _fetchQuote() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
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
        if (!mounted) return;
        setState(() {
          dailyQuote = quoteData['quote'];
          author = quoteData['author'];
        });
      } else {
        if (!mounted) return;
        setState(() {
          dailyQuote = DefaultQuoteList().getQuote().body;
          author = DefaultQuoteList().getQuote().author;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        dailyQuote = DefaultQuoteList().getQuote().body;
        author = DefaultQuoteList().getQuote().author;
      });
      print('error in fetching quote: $e');
    }

    if (!mounted) return;
    setState(() {
      _state = QuoteLoadingState.FINISHED_DOWNLOADING;
    });
  }
}

class DailyQuoteUI extends StatelessWidget {
  DailyQuoteUI({@required this.title, this.author, this.key, this.lengthLimit});

  final String title;
  final String author;
  final GlobalKey key;
  final int lengthLimit;

  @override
  Widget build(BuildContext context) {
    // print('title.length: ${title.length}');
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: (title.length) < lengthLimit
              ? Text(
                  author == null || author == ''
                      ? '"$title"'
                      : '"$title -- $author"',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: KQuote,
                )
              : _richText(context)),
    );
  }

  Widget _richText(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return RichText(
      maxLines: 2,
      textAlign: TextAlign.center,
      text: TextSpan(
        style: KQuote, //fontSize: 16,
        children: <TextSpan>[
          TextSpan(text: '"${title.substring(0, lengthLimit - 5)}'),
          TextSpan(
              text: '...',
              style: TextStyle(
                  color: _darkTheme ? darkThemeButton : Colors.lightBlueAccent,
                  fontSize: 18,
                  fontStyle: FontStyle.italic),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _showMoreText(
                    context: context,
                    text: author == null || author == ''
                        ? '"$title"'
                        : '"$title -- $author"',
                  );
                }),
          TextSpan(text: '"'),
        ],
      ),
    );
  }

  ///we can not put this inside the function.
  // final GlobalKey key = MyGlobalKeys.dailyQuoteKey;
  void _showMoreText({@required BuildContext context, @required String text}) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: text,
        textStyle:
            TextStyle(color: _darkTheme ? darkThemeWords : lightThemeWords),
        height: 95,
        width: 280,
        backgroundColor:
            _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
        padding: EdgeInsets.all(6.0),
        borderRadius: BorderRadius.circular(10.0));

    /// show the popup for specific widget
    popup.show(
      widgetKey: key,
    );
  }
}

///Duplicate GlobalKey detected in widget tree.
//
// The following GlobalKey was specified multiple times in the widget tree. This will lead to parts of the widget tree being truncated unexpectedly, because the second time a key is seen, the previous instance is moved to the new location. The key was:
// - [GlobalKey#7261d]
// This was determined by noticing that after the widget with the above global key was moved out of its previous parent, that previous parent never updated during this frame, meaning that it either did not update at all or updated before the widget was moved, in either case implying that it still thinks that it should have a child with that global key.
// The specific parent that did not update after having one or more children forcibly removed due to GlobalKey reparenting is:
// - Center(alignment: center, dependencies: [Directionality], renderObject: RenderPositionedBox#4a8ab relayoutBoundary=up7)
// A GlobalKey can only be specified on one widget at a time in the widget tree.

//_showMoreText not working when refactor the two class as one, so i wrote separately

///changed to adding key as a property, use key: GlobalKey(), then it works
class RestQuoteUI extends StatelessWidget {
  RestQuoteUI(
      {Key key, @required this.title, this.author, @required this.lengthLimit})
      : super(key: key);

  final String title;
  final String author;

  final int lengthLimit;

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // getLengthLimit(height);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15.0),
        child: (title.length) < lengthLimit
            ? Text(
                author == null || author == ''
                    ? '"$title"'
                    : '"$title -- $author"',
                textAlign: TextAlign.center,
                // maxLines: 2,
                style: KQuote,
              )
            : _richText(context),
      ),
    );
  }

  Widget _richText(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    // double height = MediaQuery.of(context).size.height;
    // getLengthLimit(height);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: KQuote,
        children: <TextSpan>[
          TextSpan(text: '"${title.substring(0, lengthLimit - 5)}'),
          TextSpan(
              text: '...',
              style: TextStyle(
                  color: _darkTheme ? darkThemeButton : Colors.lightBlueAccent,
                  fontSize: 18,
                  fontStyle: FontStyle.italic),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _showMoreText(
                    context: context,
                    text: author == null || author == ''
                        ? '"$title"'
                        : '"$title -- $author"',
                  );
                }),
          TextSpan(text: '"'),
        ],
      ),
    );
  }

  ///notes on show more text
  final GlobalKey key = MyGlobalKeys.restQuoteKey;

  void _showMoreText({@required BuildContext context, @required String text}) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: text,
        textStyle:
            TextStyle(color: _darkTheme ? darkThemeWords : lightThemeWords),
        height: 95,
        width: 280,
        backgroundColor:
            _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
        padding: EdgeInsets.all(6.0),
        borderRadius: BorderRadius.circular(10.0));

    /// show the popup for specific widget
    popup.show(
      widgetKey: key,
    );
  }
}
