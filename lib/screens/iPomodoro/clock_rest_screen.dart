import 'package:flutter/material.dart';
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:iMomentum/app/common_widgets/my_round_button.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/utils/extension_clockFmt.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/utils/pages_routes.dart';
import 'package:iMomentum/screens/iPomodoro/pomodoro_base_screen.dart';
import 'clock_begin_screen.dart';
import 'clock_timer.dart';
import 'clock_mantra_quote_title.dart';

class RestScreen extends StatefulWidget {
  const RestScreen(
      {@required this.database,
      @required this.job,
      this.restDuration,
      this.playSound});
  final Duration restDuration;
  final Todo job;
  final Database database;
  final bool playSound;

  @override
  _RestScreenState createState() => _RestScreenState();
}

class _RestScreenState extends State<RestScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Stopwatch _stopwatch;
  Timer _timer;
  // This string that is displayed as the countdown timer
  String _display = '';
  Duration _restDuration;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: widget.restDuration,
      vsync: this,
    );
    _animationController.forward();
    _restDuration = widget.restDuration;
    _playSound();
    _stopwatch = Stopwatch();
    _start();
    // _fetchQuote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PomodoroBaseScreen(
      leadingWidget: Container(),
      actionWidget: Container(),
      titleWidget: PomodoroTitle(
        title: 'Time to Rest',
        subtitle: 'Come back in ${widget.restDuration.inMinutes} minutes',
      ), //clear button//begin title
      bigCircle: ClockTimer(
        duration: _restDuration,
        animationController: _animationController,
        text1: _display,
        text2: 'Rest',
      ),
      timerButton: timerButtonRow(),
      bottomWidget: Container(),
      // RestScreenBottomQuote(
      //     state: _state, dailyQuote: dailyQuote, author: author),
    );
  }

  Padding timerButtonRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RoundTextButton(
            text: 'Cancel',
            textColor: Colors.white70,
            onPressed: _end,
            circleColor: Colors.white70,
            fillColor: Colors.black12,
          ),
          _stopwatch.isRunning
              ? RoundTextButton(
                  text: 'Pause',
                  textColor: Colors.white,
                  onPressed: _pause,
                  circleColor: Colors.white,
                  fillColor: Colors.deepOrange.withOpacity(0.3),
                )
              : RoundTextButton(
                  text: 'Resume',
                  textColor: Colors.white,
                  onPressed: _resume,
                  circleColor: Colors.white,
                  fillColor: Colors.lightGreenAccent.withOpacity(0.3),
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    _animationController.dispose();
    super.dispose();
  }

  // Play a sound
  void _playSound() {
    if (widget.playSound) {
      final assetsAudioPlayer = AssetsAudioPlayer();
      assetsAudioPlayer.open(
        Audio("assets/audio/juntos.mp3"),
        autoStart: true,
      );
    }
  }

  // This will start the Timer
  void _start() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
    }
    if (_timer != null) {
      if (_timer.isActive) return;
    }
    _timer = Timer.periodic(Duration(milliseconds: 10), (Timer t) {
      /// update display
      if (mounted) {
        setState(() {
          var diff = (widget.restDuration - _stopwatch.elapsed);
          _display = diff.clockFmt();
          if (diff.inMilliseconds <= 0) {
            _playSound();
            _end(cancelled: false);
          }
        });
      }
    });
  }

  // This will pause the timer
  void _pause() {
    _playSound();
    if (!_stopwatch.isRunning) {
      return;
    }
    setState(() {
      _stopwatch.stop();
      _animationController.stop();
    });
  }

  // This will resume the timer
  void _resume() {
    _playSound();
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
    }
    setState(() {
      _stopwatch.start();
      _animationController.forward();
    });
  }

  // This will stop the timer
  void _end({bool cancelled = true}) {
//    if (!_stopwatch.isRunning) {
//      return;
//    }
    setState(() {
      _timer.cancel();
      _stopwatch.stop();
    });

    if (cancelled) {
      /// not go back to HomeScreen
//      Navigator.pop(context);
      backToBeginScreen();
    } else {
      backToBeginScreen();
    }
  }

  Future backToBeginScreen() {
    return Navigator.of(context).pushReplacement(PageRoutes.fade(
        () => ClockBeginScreen(
              database: widget.database,
              todo: widget.job,
            ),
        milliseconds: 450));
  }

  // QuoteLoadingState _state = QuoteLoadingState.NOT_DOWNLOADED;
  // String dailyQuote;
  // String author;

//http://quotes.rest/qod/categories.json
//   Future<void> _fetchQuote() async {
//     setState(() {
//       _state = QuoteLoadingState.DOWNLOADING;
//     });
//     try {
//       final response = await http
//
//           ///this link can only use 10 times/hours
// //          .get('http://quotes.rest/qod.json?maxlength=100&category=life&love');
//           .get('https://favqs.com/api/qotd');
//       if (response.statusCode == 200) {
//         var quoteData = json.decode(response.body)['quote'];
//         setState(() {
//           dailyQuote = quoteData['body'];
//           author = quoteData['author'];
//         });
//       } else {
//         setState(() {
//           dailyQuote = RestQuoteList().getRestQuote().body;
//           author = RestQuoteList().getRestQuote().author;
//         });
//         //        throw Exception('Failed to load quote');
//       }
//     } catch (e) {
//       setState(() {
//         dailyQuote = RestQuoteList().getRestQuote().body;
//         author = RestQuoteList().getRestQuote().author;
//       });
//       print('error in fetching rest quote: $e');
//     }
//     setState(() {
//       _state = QuoteLoadingState.FINISHED_DOWNLOADING;
//     });
//   }
}
