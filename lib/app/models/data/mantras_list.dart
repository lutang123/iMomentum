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

class MantraOriginal {
  MantraOriginal({this.body});
  String body;
}

class MantraOriginalList {
  //a function to return a random mantra
  MantraOriginal showMantra() {
    var r = Random(DateTime.now().millisecondsSinceEpoch);
    var randInt = r.nextInt(_mantraList.length);
    return _mantraList[randInt];
  }

  List<MantraOriginal> _mantraList = [
    MantraOriginal(body: 'Live in the moment.'),
    MantraOriginal(
      body: 'You are capable of wonderful things.',
    ),
    MantraOriginal(body: 'Breathe'),
    MantraOriginal(
      body: 'Be kind to yourself.',
    ),
    MantraOriginal(body: 'Be present.'),
    MantraOriginal(
      body: 'You matter.',
    ),
    MantraOriginal(body: 'Fear less, love more.'),
    MantraOriginal(
      body: 'Trust yourself.',
    ),
    MantraOriginal(
      body: 'Do more of what makes you happy.',
    ),
    MantraOriginal(
      body: 'Stay positive.',
    ),
    MantraOriginal(
      body: 'Strive for greatness.',
    ),
    MantraOriginal(
      body: 'Accept and embrace all experiences.',
    ),
    MantraOriginal(
      body: 'Care for yourself.',
    ),
    MantraOriginal(
      body: 'Yes, you can.',
    ),
    MantraOriginal(
      body: 'Make your dreams happen.',
    ),
    MantraOriginal(
      body: 'Work smarter, not harder.',
    ),
    MantraOriginal(
      body: 'Change your thoughts, change your world.',
    ),
    MantraOriginal(
      body: 'Illuminate the beauty in others.',
    ),
    MantraOriginal(
      body: 'Live what you love.',
    ),
    MantraOriginal(
      body: 'Worry less, smile more.',
    ),
    MantraOriginal(
      body: 'Nature heals.',
    ),
    MantraOriginal(
      body: 'Collect moments, not things.',
    ),
    MantraOriginal(
      body: 'Give back.',
    ),
    MantraOriginal(
      body: 'Start with optimism.',
    ),
    MantraOriginal(
      body: 'Let your light shine.',
    ),
    MantraOriginal(
      body: 'You are creative.',
    ),
    MantraOriginal(
      body: 'Progress, not perfection.',
    ),
    MantraOriginal(
      body: 'Express yourself.',
    ),
    MantraOriginal(
      body: 'Be peaceful, happy and whole.',
    ),
    MantraOriginal(
      body: 'Empty your cup.',
    ),
    MantraOriginal(
      body: 'Because you can.',
    ),
    MantraOriginal(
      body: 'Find a way!',
    ),
    MantraOriginal(
      body: 'Enjoy the process.',
    ),
    MantraOriginal(
      body: 'Invest in yourself.',
    ),
    MantraOriginal(
      body: 'Do more with less.',
    ),
    MantraOriginal(
      body: 'Plan for victory, learn from defeat.',
    ),
    MantraOriginal(
      body: 'Do the things you love.',
    ),
    MantraOriginal(
      body: 'Be honest.',
    ),
    MantraOriginal(
      body: 'Be still.',
    ),
    MantraOriginal(
      body: 'Talk less, listen more.',
    ),
    MantraOriginal(
      body: 'Be present.',
    ),
    MantraOriginal(
      body: 'You matter.',
    ),
  ];
}
