import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_transparent_flat_button.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/screens/iMeditate/utils/extensions.dart';
import 'package:iMomentum/screens/iPomodoro/countdown_animation.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/pages_routes.dart';
import 'package:iMomentum/app/models/data/meditation/meditation_quote.dart';
import 'clock_begin_screen.dart';

class BreakScreen extends StatefulWidget {
  const BreakScreen(
      {@required this.database, @required this.job, this.duration});
  final Duration duration;
  final Todo job;
  final Database database;

  @override
  _BreakScreenState createState() => _BreakScreenState();
}

class _BreakScreenState extends State<BreakScreen> {
  final String quoteBody = MeditationQuoteList().getMeditationQuote().body;

  final String quoteAuthor = MeditationQuoteList().getMeditationQuote().author;

  void _clearButton() {
    Navigator.of(context).pushReplacement(PageRoutes.fade(
        () => ClockBeginScreen(
              database: widget.database,
              todo: widget.job,
            ),
        milliseconds: 450));
  }

  Stopwatch _stopwatch;
  Timer _timer;

  // This string that is displayed as the countdown timer
  String _display = 'Stay Focused';

  @override
  void initState() {
    super.initState();
    _playSound();
    _stopwatch = Stopwatch();
    _start();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _stopwatch.stop();
  }

  // Play a sound
  void _playSound() {
    final assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer.open(
      Audio("assets/audio/gong.mp3"),
      autoStart: true,
    );
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
        var diff = (widget.duration - _stopwatch.elapsed);
        _display = diff.clockFmt();
        if (diff.inMilliseconds <= 0) {
          _playSound();
          _end(cancelled: false);
        }
      });
    });
  }

  // This will stop the timer
  void _end({bool cancelled = true}) {
    if (!_stopwatch.isRunning) {
      return;
    }
    setState(() {
      _timer.cancel();
      _stopwatch.stop();
    });

    if (cancelled) {
      Navigator.of(context).pushReplacement(PageRoutes.fade(
          () => ClockBeginScreen(
                database: widget.database,
                todo: widget.job,
              ),
          milliseconds: 450));
    } else {
      Navigator.of(context).pushReplacement(PageRoutes.fade(
          () => ClockBeginScreen(
                database: widget.database,
                todo: widget.job,
              ),
          milliseconds: 450));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.network(Constants.homePageImage, fit: BoxFit.cover),
        ContainerLinearGradient(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          onPressed: _clearButton,
                          icon: Icon(Icons.clear, size: 30),
                          color: Colors.white,
                        )
                      ],
                    ),
                  ), //clear button
                  Column(
                    children: <Widget>[
                      Text('Time to Rest',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text(
                        'Come back in 5 minutes',
                        style: GoogleFonts.varelaRound(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 20),
                    ],
                  ), //begin title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TransparentFlatButton(
                        color: Colors.transparent,
                        onPressed: null,
                        text: '',
                      ),
                      TransparentFlatButton(
                        color: Colors.transparent,
                        onPressed: null,
                        text: '',
                      ),
                    ],
                  ), //button or empty row
                  Container(
                    height: size.height / 2,
                    width: size.height / 2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        //icon clear
                        SizedBox.expand(
                          child: CountdownCircle(
                            duration: widget.duration,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _display,
                              style: GoogleFonts.varelaRound(
                                fontWeight: FontWeight.w600,
                                fontSize: 50.0,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Rest',
                              style: GoogleFonts.varelaRound(
                                  fontWeight: FontWeight.w600, fontSize: 30.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TransparentFlatButton(
                        color: Colors.transparent,
                        onPressed: null,
                        text: '',
                      ),
                      TransparentFlatButton(
                        color: Colors.transparent,
                        onPressed: null,
                        text: '',
                      ),
                    ],
                  ), //button or empty row
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        AutoSizeText(
                          '“$quoteBody”',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          quoteAuthor,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  //button or empty row
                  //clock
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
