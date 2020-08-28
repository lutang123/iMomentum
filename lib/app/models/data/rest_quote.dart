import 'dart:math';

/// These are the default quotes displayed in [CompletionScreen]
//List<Quote> kDefaultQuotes(BuildContext context) {

class RestQuote {
  String body;
  String author;

  RestQuote({this.body, this.author});
}

class RestQuoteList {
  RestQuote getRestQuote() {
    var r = Random(DateTime.now().millisecondsSinceEpoch);
    var randInt = r.nextInt(_quoteList.length);
    return _quoteList[randInt];
  }

  List<RestQuote> _quoteList = [
    RestQuote(
      author: '',
      body: 'There is nothing permanent except change.',
    ),
    RestQuote(
      author: 'Paramahansa Yogananda',
      body: 'Seclusion is the price of greatness.',
    ),
    RestQuote(
      author: 'John Miller',
      body:
          'People who take the time to be alone usually have depth, originality, and quiet reserve.',
    ),
    RestQuote(
      author: 'Giovanni Papini',
      body: 'Breathing is the greatest pleasure in life',
    ),
    RestQuote(
      author: 'Oprah Winfrey',
      body:
          'Breathe. Let go. And remind yourself that this very moment is the only one you know you have for sure.',
    ),
    RestQuote(
      author: 'Thich Nhat Hanh',
      body: 'Breathe in deeply to bring your mind home to your body.',
    ),
    RestQuote(
      author: '',
      body: 'Learning never exhausts the mind.',
    ),
    RestQuote(
      author: 'Gregory Maguire',
      body: 'Remember to breathe. It is after all, the secret of life.',
    ),
    RestQuote(
      author: 'Lana Parrilla',
      body: 'You are where you need to be. Just take a deep breath.',
    ),
    RestQuote(
      author: '',
      body: 'All that we see or seem is but a dream within a dream.',
    ),
    RestQuote(
      author: '',
      body: 'There is no charm equal to tenderness of heart.',
    ),
    RestQuote(
      author: '',
      body: 'The only journey is the one within.',
    ),
    RestQuote(
      author: '',
      body: 'Life without love is like a tree without blossoms or fruit.',
    ),
    RestQuote(
      author: '',
      body: 'No act of kindness, no matter how small, is ever wasted.',
    ),
  ];
}

List quoteList = [
  "It is far better to be alone, than to be in bad company.",
  "Independence is happiness.",
  "The supreme art of war is to subdue the enemy without fighting.",
  "Keep your face always toward the sunshine - and shadows will fall behind you.",
  "Being entirely honest with oneself is a good exercise.",
  "Happiness can exist only in acceptance.",
  "Love has no age, no limit, and no death.",
  "You can't blame gravity for falling in love.",
  "Honesty is the first chapter in the book of wisdom.",
  "The journey of a thousand miles begins with one step.",
  "The best preparation for tomorrow is doing your best today.",
  "Ever tried. Ever failed. No matter. Try Again. Fail again. Fail better",
  "Not all those who wander are lost.",
  "Whoever is happy will make others happy too.",
  "I have not failed. I've just found 10,000 ways that won't work.",
  "Tell me and I forget. Teach me and I remember. Involve me and I learn.",
  "There is nothing on this earth more to be prized than true friendship.",
  "There is only one happiness in this life, to love and be loved.",
  "If opportunity doesn't knock, build a door.",
  "The secret of getting ahead is getting started.",
  "Wise men speak because they have something to say, Fools because they have to say something.",
  "The World is my country, all mankind are my brethren, and to do good is my religion.",
  "Problems are not stop signs, they are guidelines.",
  "All our dreams can come true, if we have the courage to pursue them.",
  "We know what we are, but know not what we may be.",
  "It's not what you look at that matters, it's what you see.",
  "A single rose can be my garden... a single friend, my world.",
  "Friends show their love in times of trouble, not in happiness.",
  "Life is not a problem to be solved, but a reality to be experienced.",
  "The only true wisdom is in knowing you know nothing.",
  "Everything has beauty, but not everyone sees it.",
  "Believe you can and you're halfway there.",
  "The future belongs to those who believe in the beauty of their dreams.",
  "Change your thoughts and you change your world.",
  "Love isn't something you find. Love is something that finds you.",
  "Do all things with love.",
  "Where there is love there is life.",
  "Nothing is impossible, the word itself says 'I'm possible'!",
  "Try to be a rainbow in someone's cloud.",
  "It is during our darkest moments that we must focus to see the light."
];
