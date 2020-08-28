import 'dart:math';

/// These are the default quotes displayed in [CompletionScreen]
//List<Quote> kDefaultQuotes(BuildContext context) {

class DefaultQuote {
  String body;
  String author;

  DefaultQuote({this.body, this.author});
}

class DefaultQuoteList {
  DefaultQuote getQuote() {
    var r = Random(DateTime.now().millisecondsSinceEpoch);
    var randInt = r.nextInt(_quoteList.length);
    return _quoteList[randInt];
  }

  List<DefaultQuote> _quoteList = [
    DefaultQuote(
      author: 'Robin Sharma',
      body: 'Bravery is the solution to regret',
    ),
    DefaultQuote(
      author: 'Joseph Campbell',
      body:
          'Follow your bliss and the universe will open doors where there were only walls.',
    ),
    DefaultQuote(
      author: 'Mandy Hale',
      body:
          "You don't always need a plan. Sometimes you just need to breathe, trust, let go, and see what happens.",
    ),
    DefaultQuote(
      author: 'Unknown',
      body: 'The surest way to find your dream job is to create it.',
    ),
    DefaultQuote(
      author: 'Tyra Banks',
      body: 'Never dull your shine for somebody else.',
    ),
    DefaultQuote(
      author: 'Alan Watts',
      body:
          'This is the real secret to life—to be completely engaged with what you are doing in the here and now. And instead of calling it work, realize it is play.',
    ),
    DefaultQuote(
      author: 'Unknown',
      body:
          'First they ignore you. Then they laugh at you. Then they fight you. Then you win.',
    ),
    DefaultQuote(
      author: 'Jane Goodall',
      body:
          'What you do makes a difference, and you have to decide what kind of difference you want to make.',
    ),
    DefaultQuote(
      author: 'Carmel McConnell',
      body: 'Do more of what makes you happy.',
    ),
    DefaultQuote(
      author: 'Unknown',
      body:
          "If you keep on doing what you've always done, you will keep getting what you've always gotten.",
    ),
    DefaultQuote(
      author: 'Neil Armstrong',
      body:
          'Mystery creates wonder and wonder is the basis of our desire to understand.',
    ),
    DefaultQuote(
      author: 'Unknown',
      body:
          'stop being afraid of what could go wrong and start being positive about what could go right.',
    ),
    DefaultQuote(
      author: 'Dr Roopleen',
      body:
          'Believe in yourself. Under-confidence leads to a self-fulfilling prophecy that you are not good enough for your work.',
    ),
    DefaultQuote(
      author: 'Steve Maraboli',
      body:
          "Incredible change happens in your life when you decide to take control of what you do have power over instead of craving control over what you don't.",
    ),
    DefaultQuote(
        author: 'Will Rogers',
        body: "Don't let yesterday take up too much of today."),
    DefaultQuote(
        author: 'Lama Yeshe',
        body:
            "Be gentle first with yourself if you wish to be gentle with others."),
//    DefaultQuote(
//        author: 'Dwight D. Eisenhower',
//        body: "Never waste a minute thinking about people you don't like."),
    DefaultQuote(
        author: 'Michelle Obama',
        body:
            "Success isn’t about how your life looks to others. It’s about how it feels to you."),
    DefaultQuote(
        author: 'Mark Houlahan',
        body:
            "If you want your life to be a magnificent story, then begin by realising that you are the author."),
    DefaultQuote(
        author: 'Unknown',
        body:
            "An amateur practices until they can play it correctly, a professional practices until they can't play it incorrectly."),
    DefaultQuote(
        author: 'Dan Millman',
        body:
            "The secret of change is to focus all of your energy, not on fighting the old but on building the new."),
    DefaultQuote(
        author: 'Sarah Ban Breathnach',
        body:
            "The world needs dreamers and the world needs doers. But above all, the world needs dreamers who do."),
    DefaultQuote(
        author: 'Unknown',
        body:
            "Overthinking ruins you. Ruins the situation, twists it around, makes you worry and just makes everything much worse than it actually is."),
    DefaultQuote(
        author: 'Dalai Lama',
        body:
            "emember that not getting what you want is sometimes a wonderful stroke of luck."),
    DefaultQuote(
        author: 'Unknown',
        body:
            "If you want to go fast, go alone. If you want to go far, bring others along."),
    DefaultQuote(
        author: 'Jim Rohn',
        body: "Discipline is the bridge between goals and accomplishment"),

    /// Saturday Aug 16,2020;
//    DefaultQuote(
//      author: 'Steve Maraboli',
//      body:
//          "Incredible change happens in your life when you decide to take control of what you do have power over instead of craving control over what you don't.",
//    ),
//    DefaultQuote(
//      author: 'Steve Maraboli',
//      body:
//          "Incredible change happens in your life when you decide to take control of what you do have power over instead of craving control over what you don't.",
//    ),
//    DefaultQuote(
//      author: 'Steve Maraboli',
//      body:
//          "Incredible change happens in your life when you decide to take control of what you do have power over instead of craving control over what you don't.",
//    ),
  ];
}
