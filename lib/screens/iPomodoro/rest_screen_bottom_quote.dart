import 'package:flutter/material.dart';
import 'package:iMomentum/screens/home_screen/daily_quote.dart';

class RestScreenBottomQuote extends StatelessWidget {
  const RestScreenBottomQuote(
      {Key key,
      @required QuoteLoadingState state,
      @required this.dailyQuote,
      this.author,
      @required this.lengthLimit})
      : _state = state,
        super(key: key);

  final QuoteLoadingState _state;
  final String dailyQuote;
  final String author;
  final int lengthLimit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: _state == QuoteLoadingState.FINISHED_DOWNLOADING

              /// Same as Daily, but different Global key on show more
              ? RestQuoteUI(
                  lengthLimit: lengthLimit,
                  title: dailyQuote,
                  author: author,
                )
              : _state == QuoteLoadingState.DOWNLOADING
                  ? Center(child: CircularProgressIndicator())
                  : Container(),
        ),
      ],
    );
  }
}
