import 'dart:math';

/// These are the default quotes displayed in [CompletionScreen]
//List<Quote> kDefaultQuotes(BuildContext context) {

class CongratsQuotes {
  String body;
  CongratsQuotes({this.body});
}

class CongratsList {
  CongratsQuotes getCongrats() {
    var r = Random(DateTime.now().millisecondsSinceEpoch);
    var randInt = r.nextInt(_quoteList.length);
    return _quoteList[randInt];
  }

  List<CongratsQuotes> _quoteList = [
    CongratsQuotes(
      body: 'Nice',
    ),
    CongratsQuotes(
      body: 'Good job!',
    ),
    CongratsQuotes(
      body: 'Great work!',
    ),
    CongratsQuotes(
      body: 'Well done!',
    ),
    CongratsQuotes(
      body: 'Way to go!',
    ),
  ];
}
