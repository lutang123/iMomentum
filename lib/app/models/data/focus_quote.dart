import 'dart:math';

/// These are the default quotes displayed in [CompletionScreen]
//List<Quote> kDefaultQuotes(BuildContext context) {

class FocusQuote {
  String body;
  String author;

  FocusQuote({this.body, this.author});
}

class FocusQuoteList {
  FocusQuote getFocusQuote() {
    var r = Random(DateTime.now().millisecondsSinceEpoch);
    var randInt = r.nextInt(_quoteList.length);
    return _quoteList[randInt];
  }

  List<FocusQuote> _quoteList = [
    FocusQuote(
      author: 'Aristotle',
      body:
          'Whosoever is delighted in solitude is either a wild beast or a god.',
    ),
    FocusQuote(
      author: 'Paramahansa Yogananda',
      body: 'Seclusion is the price of greatness.',
    ),
    FocusQuote(
      author: 'John Miller',
      body:
          'People who take the time to be alone usually have depth, originality, and quiet reserve.',
    ),
    FocusQuote(
      author: 'Giovanni Papini',
      body: 'Breathing is the greatest pleasure in life',
    ),
    FocusQuote(
      author: 'Oprah Winfrey',
      body:
          'Breathe. Let go. And remind yourself that this very moment is the only one you know you have for sure.',
    ),
    FocusQuote(
      author: 'Thich Nhat Hanh',
      body: 'Breathe in deeply to bring your mind home to your body.',
    ),
    FocusQuote(
      author: 'Dr. Arthur C. Guyton',
      body:
          'All chronic pain, suffering, and diseases are caused by a lack of oxygen at the cell level.',
    ),
    FocusQuote(
      author: 'Gregory Maguire',
      body: 'Remember to breathe. It is after all, the secret of life.',
    ),
    FocusQuote(
      author: 'Lana Parrilla',
      body: 'You are where you need to be. Just take a deep breath.',
    ),
    FocusQuote(
      author: 'Unknown',
      body: 'A healthy mind has an easy breath.',
    ),
    FocusQuote(
      author: 'Proverb',
      body: 'The nose is for breathing, the mouth is for eating.',
    ),
    FocusQuote(
      author: 'Elizabeth Barrett Browning',
      body: 'He lives most life whoever breathes most air.',
    ),
    FocusQuote(
      author: 'Peter Matthiessen',
      body:
          'In this very breath that we now take lies the secret that all great teachers try to tell us.',
    ),
    FocusQuote(
      author: 'Sylvia Plath',
      body:
          'I took a deep breath and listened to the old bray of my heart: I am, I am, I am.',
    ),
  ];
}
