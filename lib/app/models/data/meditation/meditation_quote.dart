import 'dart:math';

/// These are the default quotes displayed in [CompletionScreen]
//List<Quote> kDefaultQuotes(BuildContext context) {

class MeditationQuote {
  String body;
  String author;

  MeditationQuote({this.body, this.author});
}

class MeditationQuoteList {
  MeditationQuote getMeditationQuote() {
    var r = Random(DateTime.now().millisecondsSinceEpoch);
    var randInt = r.nextInt(_quoteList.length);
    return _quoteList[randInt];
  }

  List<MeditationQuote> _quoteList = [
    MeditationQuote(
      author: 'Aristotle',
      body:
          'Whosoever is delighted in solitude is either a wild beast or a god.',
    ),
    MeditationQuote(
      author: 'Paramahansa Yogananda',
      body: 'Seclusion is the price of greatness.',
    ),
    MeditationQuote(
      author: 'John Miller',
      body:
          'People who take the time to be alone usually have depth, originality, and quiet reserve.',
    ),
    MeditationQuote(
      author: 'Giovanni Papini',
      body: 'Breathing is the greatest pleasure in life',
    ),
    MeditationQuote(
      author: 'Oprah Winfrey',
      body:
          'Breathe. Let go. And remind yourself that this very moment is the only one you know you have for sure.',
    ),
    MeditationQuote(
      author: 'Thich Nhat Hanh',
      body: 'Breathe in deeply to bring your mind home to your body.',
    ),
    MeditationQuote(
      author: 'Dr. Arthur C. Guyton',
      body:
          'All chronic pain, suffering, and diseases are caused by a lack of oxygen at the cell level.',
    ),
    MeditationQuote(
      author: 'Gregory Maguire',
      body: 'Remember to breathe. It is after all, the secret of life.',
    ),
    MeditationQuote(
      author: 'Lana Parrilla',
      body: 'You are where you need to be. Just take a deep breath.',
    ),
    MeditationQuote(
      author: 'Unknown',
      body: 'A healthy mind has an easy breath.',
    ),
    MeditationQuote(
      author: 'Proverb',
      body: 'The nose is for breathing, the mouth is for eating.',
    ),
    MeditationQuote(
      author: 'Elizabeth Barrett Browning',
      body: 'He lives most life whoever breathes most air.',
    ),
    MeditationQuote(
      author: 'Peter Matthiessen',
      body:
          'In this very breath that we now take lies the secret that all great teachers try to tell us.',
    ),
    MeditationQuote(
      author: 'Sylvia Plath',
      body:
          'I took a deep breath and listened to the old bray of my heart: I am, I am, I am.',
    ),
  ];
}
