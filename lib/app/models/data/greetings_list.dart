import 'dart:math';
import 'package:intl/intl.dart';

/// These are the default quotes displayed in [CompletionScreen]
//List<Quote> kDefaultQuotes(BuildContext context) {

class FirstGreetings {
  final int hour = int.parse(DateFormat('kk').format(DateTime.now()));
  String greeting;
  String showGreetings() {
    if ((hour > 6) & (hour <= 12)) {
      greeting = 'Good Morning';
    } else if ((hour > 12) & (hour <= 6)) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }
    return greeting;
  }
}

class Greetings {
  Greetings({this.body});
  String body;
}

class SecondGreetings {
  Greetings showGreetings() {
    var r = Random(DateTime.now().millisecondsSinceEpoch);
    var randInt = r.nextInt(_quoteList.length);
    return _quoteList[randInt];
  }

  List<Greetings> _quoteList = [
    Greetings(body: 'Live in the moment.'),
    Greetings(
      body: 'You are capable of wonderful things.',
    ),
    Greetings(body: 'Breathe'),
    Greetings(
      body: 'Be kind to yourself.',
    ),
    Greetings(body: 'Be present.'),
    Greetings(
      body: 'You matter.',
    ),
    Greetings(body: 'Fear less, love more.'),
    Greetings(
      body: 'Trust yourself.',
    ),
    Greetings(
      body: 'Do more of what makes you happy.',
    ),
    Greetings(
      body: 'Stay positive.',
    ),
    Greetings(
      body: 'Strive for greatness.',
    ),
    Greetings(
      body: 'Accept and embrace all experiences.',
    ),
    Greetings(
      body: 'Care for yourself.',
    ),
    Greetings(
      body: 'Yes, you can.',
    ),
    Greetings(
      body: 'Make your dreams happen.',
    ),
    Greetings(
      body: 'Work smarter, not harder.',
    ),
    Greetings(
      body: 'Change your thoughts, change your world.',
    ),
    Greetings(
      body: 'Illuminate the beauty in others.',
    ),
    Greetings(
      body: 'Live what you love.',
    ),
    Greetings(
      body: 'Worry less, smile more.',
    ),
    Greetings(
      body: 'Nature heals.',
    ),
    Greetings(
      body: 'Collect moments, not things.',
    ),
    Greetings(
      body: 'Give back.',
    ),
    Greetings(
      body: 'Start with optimism.',
    ),
    Greetings(
      body: 'Let your light shine.',
    ),
    Greetings(
      body: 'You are creative.',
    ),
    Greetings(
      body: 'Progress, not perfection.',
    ),
    Greetings(
      body: 'Express yourself.',
    ),
    Greetings(
      body: 'Be peaceful, happy and whole.',
    ),
    Greetings(
      body: 'Empty your cup.',
    ),
    Greetings(
      body: 'Because you can.',
    ),
    Greetings(
      body: 'Find a way!',
    ),
    Greetings(
      body: 'Enjoy the process.',
    ),
    Greetings(
      body: 'Invest in yourself.',
    ),
    Greetings(
      body: 'Do more with less.',
    ),
    Greetings(
      body: 'Plan for victory, learn from defeat.',
    ),
    Greetings(
      body: 'Do the things you love.',
    ),
    Greetings(
      body: 'Be honest.',
    ),
    Greetings(
      body: 'Be still.',
    ),
    Greetings(
      body: 'Talk less, listen more.',
    ),
    Greetings(
      body: 'Be present.',
    ),
    Greetings(
      body: 'You matter.',
    ),
  ];
}
