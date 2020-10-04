import 'package:flutter/material.dart';
import 'package:iMomentum/screens/home_screen/daily_quote.dart';

class RestScreenBottomQuote extends StatelessWidget {
  const RestScreenBottomQuote({
    Key key,
    @required QuoteLoadingState state,
    @required this.dailyQuote,
    @required this.author,
  })  : _state = state,
        super(key: key);

  final QuoteLoadingState _state;
  final String dailyQuote;
  final String author;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: _state == QuoteLoadingState.FINISHED_DOWNLOADING

          /// Same as Daily, but different Global key on show more
          ? RestQuoteUI(
              title: dailyQuote,
              author: author,
            )
          : _state == QuoteLoadingState.DOWNLOADING
              ? Center(child: CircularProgressIndicator())
              : Container(),
    );
  }
}
