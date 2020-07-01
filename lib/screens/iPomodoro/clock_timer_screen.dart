import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/my_transparent_flat_button.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/duration_model.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/screens/iMeditate/utils/extensions.dart';
import 'package:iMomentum/screens/iPomodoro/countdown_animation.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/pages_routes.dart';

import 'clock_completion_screen.dart';
import 'clock_begin_screen.dart';

//[VERBOSE-2:ui_dart_state.cc(157)] Unhandled Exception: setState() called after dispose(): _HomeScreenState#893af(lifecycle state: defunct, not mounted)
//This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer or an animation callback.
//The preferred solution is to cancel the timer or stop listening to the animation in the dispose() callback. Another solution is to check the "mounted" property of this object before calling setState() to ensure the object is still in the tree.
//This error might indicate a memory leak if setState() is being called because another object is retaining a reference to this State object after it has been removed from the tree. To avoid memory leaks, consider breaking the reference to this object during dispose().
//#0      State.setState.<anonymous closure> (package:flutter/src/widgets/frame<…>

class ClockTimerScreen extends StatefulWidget {
  const ClockTimerScreen(
      {@required this.database, @required this.job, this.duration});
  final Duration duration;
  final Todo job;
  final Database database;

  @override
  _ClockTimerScreenState createState() => _ClockTimerScreenState();
}

class _ClockTimerScreenState extends State<ClockTimerScreen> {
  Stopwatch _stopwatch;
  Timer _timer;

  // This string that is displayed as the countdown timer
  String _display = 'Focus';

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
//    setState(() {
    _timer.cancel();
    _stopwatch.stop();
//    });

    if (cancelled) {
      Navigator.of(context).pushReplacement(PageRoutes.fade(
          () => ClockBeginScreen(
                database: widget.database,
                todo: widget.job,
              ),
          milliseconds: 450));
    } else {
      ///save duration in database when it's done
      _setDuration(context);

      ///then go to completion page
      Navigator.of(context).pushReplacement(PageRoutes.fade(
          () => CompletionScreen(
                database: widget.database,
                job: widget.job,
              ),
          milliseconds: 800));
    }
  }

  DurationModel _getDurationModel() => DurationModel(
        id: documentIdFromCurrentDate(),
        todoId: widget.job.id,

        ///when we save, we convert to int inMinutes
        duration: widget.duration.inMinutes, //eg. 25, or 50
      );

  Future<void> _setDuration(BuildContext context) async {
    try {
      final duration = _getDurationModel();
      await widget.database.setDuration(
          duration); //so in our database, it always shows in minutes
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          onPressed: _end,
                          icon: Icon(Icons.clear, size: 30),
                          color: Colors.white,
                        )
                      ],
                    ),
                  ), //clear button
                  Column(
                    children: <Widget>[
                      Text('Time to focus',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text(
                        'Break your work into intervals',
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
                  ),
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
                            Text('Focus',
                                style: GoogleFonts.varelaRound(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 30.0,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ), //clock
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'TODAY',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.job.title,
                          style: GoogleFonts.varelaRound(
                            fontWeight: FontWeight.w600,
                            fontSize: 30.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
