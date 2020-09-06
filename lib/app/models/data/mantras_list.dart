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

class DefaultMantra {
  DefaultMantra({this.body});
  String body;
}

class DefaultMantraList {
  //a function to return a random mantra
  DefaultMantra showMantra() {
    var r = Random(DateTime.now().millisecondsSinceEpoch);
    var randInt = r.nextInt(mantraList.length);
    return mantraList[randInt];
  }

  List<DefaultMantra> mantraList = [
    DefaultMantra(body: 'Live in the moment.'),
    DefaultMantra(body: 'You are capable of wonderful things.'),
    DefaultMantra(body: 'Breathe'),
    DefaultMantra(body: 'Be kind to yourself.'),
    DefaultMantra(body: 'Be present.'),
    DefaultMantra(body: 'You matter.'),
    DefaultMantra(body: 'Fear less, love more.'),
    DefaultMantra(body: 'Trust yourself.'),
    DefaultMantra(body: 'Do more of what makes you happy.'),
    DefaultMantra(body: 'Stay positive.'),
    DefaultMantra(body: 'Strive for greatness.'),
    DefaultMantra(body: 'Accept and embrace all experiences.'),
    DefaultMantra(body: 'Care for yourself.'),
    DefaultMantra(body: 'Yes, you can.'),
    DefaultMantra(body: 'Make your dreams happen.'),
    DefaultMantra(body: 'Work smarter, not harder.'),
    DefaultMantra(body: 'Change your thoughts, change your world.'),
    DefaultMantra(body: 'Illuminate the beauty in others.'),
    DefaultMantra(body: 'Live what you love.'),
    DefaultMantra(body: 'Worry less, smile more.'),
    DefaultMantra(body: 'Nature heals.'),
    DefaultMantra(body: 'Collect moments, not things.'),
    DefaultMantra(body: 'Give back.'),
    DefaultMantra(body: 'Start with optimism.'),
    DefaultMantra(body: 'Let your light shine.'),
    DefaultMantra(body: 'You are creative.'),
    DefaultMantra(body: 'Progress, not perfection.'),
    DefaultMantra(body: 'Express yourself.'),
    DefaultMantra(body: 'Be peaceful, happy and whole.'),
    DefaultMantra(body: 'Empty your cup.'),
    DefaultMantra(body: 'Because you can.'),
    DefaultMantra(body: 'Find a way!'),
    DefaultMantra(body: 'Enjoy the process.'),
    DefaultMantra(body: 'Invest in yourself.'),
    DefaultMantra(body: 'Do more with less.'),
    DefaultMantra(body: 'Plan for victory, learn from defeat.'),
    DefaultMantra(body: 'Do the things you love.'),
    DefaultMantra(body: 'Be honest.'),
    DefaultMantra(body: 'Be still.'),
    DefaultMantra(body: 'Talk less, listen more.'),
    DefaultMantra(body: 'Be present.'),
    DefaultMantra(body: 'You matter.'),
    // new from new account
    DefaultMantra(body: 'Illuminate the beauty in others.'),
    DefaultMantra(body: 'Mindset matters.'),
    DefaultMantra(body: 'Do more with less.'),
    DefaultMantra(body: "It's okay to ask for help"),
    DefaultMantra(body: 'Baby steps.'),
    DefaultMantra(body: 'Empower yourself.'),
    DefaultMantra(body: 'Worry less, smile more.'),
    DefaultMantra(body: 'Ride the waves.'),
    DefaultMantra(body: 'Maintain your balance.'),
    DefaultMantra(body: 'Live simply.'),
    DefaultMantra(body: 'Give back.'),
    DefaultMantra(body: 'Dream big.'),
    DefaultMantra(body: 'Nature heals.'),
    DefaultMantra(body: 'You can and you will.'),
    DefaultMantra(body: 'Live in the moment.'),

    DefaultMantra(body: 'Eat the frog.'),
    DefaultMantra(body: 'Have patience.'),
    DefaultMantra(body: 'All is well.'),
    DefaultMantra(body: 'You are not alone.'),
    DefaultMantra(body: 'Start with optimism.'),
    DefaultMantra(body: 'Be present.'),
    DefaultMantra(body: 'Good things take time.'),
    DefaultMantra(body: 'Persistence powers passion.'),
    DefaultMantra(body: 'You are creative.'),
    DefaultMantra(body: 'Never stop dreaming.'),
    DefaultMantra(body: 'Wonder begets wisdom.'),
    DefaultMantra(body: 'It’s never too late.'),
    DefaultMantra(body: 'Believe in yourself.'),
    // until August 16, 2020
//    DefaultMantra(body: 'You are creative.'),
//    DefaultMantra(body: 'You are creative.'),
//    DefaultMantra(body: 'You are creative.'),
//    DefaultMantra(body: 'You are creative.'),
//    DefaultMantra(body: 'You are creative.'),
//    DefaultMantra(body: 'You are creative.'),
  ];
}
