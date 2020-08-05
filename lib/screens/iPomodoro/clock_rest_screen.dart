import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_round_button.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/data/rest_quote.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/common_widgets/extensions.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/services/pages_routes.dart';
import 'package:provider/provider.dart';
import 'clock_begin_screen.dart';
import 'clock_timer.dart';
import 'clock_title.dart';

class RestScreen extends StatefulWidget {
  const RestScreen(
      {@required this.database, @required this.job, this.restDuration});
  final Duration restDuration;
  final Todo job;
  final Database database;

  @override
  _RestScreenState createState() => _RestScreenState();
}

class _RestScreenState extends State<RestScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  final String quoteBody = RestQuoteList().getRestQuote().body;

  final String quoteAuthor = RestQuoteList().getRestQuote().author;

  Stopwatch _stopwatch;
  Timer _timer;

  // This string that is displayed as the countdown timer
  String _display = '';

  Duration _restDuration;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.restDuration,
      vsync: this,
    );
    _animationController.forward().orCancel;
    _restDuration = widget.restDuration;
    _playSound();
    _stopwatch = Stopwatch();
    _start();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _stopwatch.stop();
    _animationController.dispose();
  }

  // Play a sound
  void _playSound() {
    final assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer.open(
      Audio("assets/audio/juntos.mp3"),
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
        var diff = (widget.restDuration - _stopwatch.elapsed);
        _display = diff.clockFmt();
        if (diff.inMilliseconds <= 0) {
          _playSound();
          _end(cancelled: false);
        }
      });
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

  int counter = 0;

  void _onDoubleTap() {
    setState(() {
      ImageUrl.randomImageUrl =
          'https://source.unsplash.com/random?nature/$counter';
      counter++;
    });
  }

  void onPressedPause() {}

  @override
  Widget build(BuildContext context) {
    final randomNotifier = Provider.of<RandomNotifier>(context);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        BuildPhotoView(
          imageUrl:
              _randomOn ? ImageUrl.randomImageUrl : imageNotifier.getImage(),
        ),
        ContainerLinearGradient(),
        GestureDetector(
          onDoubleTap: _onDoubleTap,
          child: Scaffold(
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Opacity(
                            opacity: 0.0,
                            child: IconButton(
                              onPressed: _end,
                              icon: Icon(Icons.clear, size: 30),
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    ClockTitle(
                      title: 'Time to Rest',
                      subtitle:
                          'Come back in ${widget.restDuration.inMinutes} minutes',
                    ), //clear button//begin title
                    ClockTimer(
                      duration: _restDuration,
                      animationController: _animationController,
                      text1: _display,
                      text2: 'Rest',
                    ),
                    Padding(
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
                                  fillColor:
                                      Colors.orangeAccent.withOpacity(0.2),
                                )
                              : RoundTextButton(
                                  text: 'Resume',
                                  textColor: Colors.white,
                                  onPressed: _resume,
                                  circleColor: Colors.white,
                                  fillColor:
                                      Colors.lightGreenAccent.withOpacity(0.2),
                                ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: AutoSizeText(
                              '“$quoteBody” --$quoteAuthor',
                              maxLines: 3,
                              minFontSize: 15,
                              maxFontSize: 20,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
