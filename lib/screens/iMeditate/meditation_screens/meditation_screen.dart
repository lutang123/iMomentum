import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/common_widgets/customized_bottom_sheet.dart';
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:iMomentum/app/models/data/meditation/meditation_quote.dart';
import 'package:iMomentum/screens/iMeditate/utils/extensions.dart';
import 'package:iMomentum/screens/iPomodoro/countdown_animation.dart';
import 'package:iMomentum/screens/iMeditate/widgets/nash_breathe.dart';

class MeditationScreen extends StatefulWidget {
  MeditationScreen({this.duration, this.playSounds, this.zenMode});
  final Duration duration;
  final bool playSounds;
  final bool zenMode;

  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen>
    with SingleTickerProviderStateMixin {
  bool offstageMeditate = false;
  bool offstageComplete = true;

  String quoteBody;
  String quoteAuthor;

  Stopwatch _stopwatch;
  Timer _timer;

  // Keeps track of how much time has elapsed
  Duration _elapsedTime;

  // This string that is displayed as the countdown timer
  String _display = 'Be at peace';

  // Play a sound
  void _playSound() {
    if (widget.playSounds) {
      final assetsAudioPlayer = AssetsAudioPlayer();
      assetsAudioPlayer.open(
        Audio("images/gong.mp3"),
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
      // update display
      setState(() {
        var diff = (_elapsedTime - _stopwatch.elapsed);
        _display = diff.clockFmt();
        if (diff.inMilliseconds <= 0) {
          _playSound();
          stop(cancelled: false);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _playSound();
    _elapsedTime = widget.duration;
    _stopwatch = Stopwatch();

    _start();

    quoteBody = MeditationQuoteList().getMeditationQuote().body;
    quoteAuthor = MeditationQuoteList().getMeditationQuote().author;
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _stopwatch.stop();
  }

  // This will pause the timer
  void pause() {
    if (!_stopwatch.isRunning) {
      return;
    }
    setState(() {
      _stopwatch.stop();
    });
  }

  //This will stop the timer
  void stop({bool cancelled = true}) {
    if (!_stopwatch.isRunning) {
      return;
    }
    setState(() {
      _timer.cancel();
      _stopwatch.stop();
    });

    if (cancelled) {
      Navigator.pop(context);
    } else {
      setState(() {
        offstageMeditate = true;
        offstageComplete = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return CustomizedBottomSheet(
      child: Column(
        children: <Widget>[
          Offstage(
            offstage: offstageMeditate,
            child: Container(
              height: (size.height / 5) * 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.zenMode
                      ? Expanded(
                          child: Center(
                            child: ZenMode(
                              duration: widget.duration,
                            ),
                          ),
                        )
                      : Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              CountdownCircle(
                                duration: widget.duration,
                              ),
                              //timer inside the circle
                              Container(
                                child: Text(
                                  _display,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ],
                          ),
                        ),
//                  FlatButton(
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(20.0)),
//                    color: Theme.of(context).disabledColor,
//                    onPressed: () => stop(),
//                    child: Text(
//                      'END',
//                      style: GoogleFonts.varelaRound(
//                        color: Color(0xFF707073),
//                        fontWeight: FontWeight.w600,
//                        fontSize: 18.0,
//                      ),
//                    ),
//                  ),
                ],
              ),
            ),
          ),
          Offstage(
            offstage: offstageComplete,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Text(
                    'Completed',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    '“$quoteBody”',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    quoteAuthor,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                SizedBox(height: 10),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(68.0)),
                  color: Theme.of(context).disabledColor,
                  onPressed: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'DONE',
                      style: GoogleFonts.varelaRound(
                        color: Color(0xFF707073),
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
