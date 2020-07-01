//import 'dart:math';
//import 'package:auto_size_text/auto_size_text.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:iMomentum/app/common_widgets/customized_bottom_sheet.dart';
//import 'dart:async';
//import 'package:assets_audio_player/assets_audio_player.dart';
//import 'package:iMomentum/app/common_widgets/format.dart';
//import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
//import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
//import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
//import 'package:iMomentum/app/common_widgets/my_transparent_flat_button.dart';
//import 'package:iMomentum/app/constants/constants.dart';
//import 'package:iMomentum/app/models/data/meditation/meditation_quote.dart';
//import 'package:iMomentum/app/constants/theme.dart';
//import 'package:iMomentum/app/models/duration_model.dart';
//import 'package:iMomentum/app/models/todo.dart';
//import 'package:iMomentum/screens/iMeditate/utils/extensions.dart';
//import 'package:iMomentum/screens/iMeditate/utils/utils.dart';
//import 'package:iMomentum/screens/iPomodoro/countdown_animation.dart';
//import 'package:iMomentum/app/services/database.dart';
//
//import 'thin_and_thick_ring.dart';
//import 'only_thin_ring.dart';
//
//class PlayAndPause extends StatefulWidget {
//  const PlayAndPause({@required this.database, @required this.job});
//  final TodoModel job;
//  final Database database;
//
//  @override
//  _PlayAndPauseState createState() => _PlayAndPauseState();
//}
//
//class _PlayAndPauseState extends State<PlayAndPause>
//    with SingleTickerProviderStateMixin {
//  AnimationController _controller;
//  bool _isPlaying = false;
//
//  Duration _duration = Duration(seconds: 20);
//
//  String get timerString {
//    Duration duration = _controller.duration * _controller.value;
//    return duration.clockFmt();
//  }
//
//  bool offstageComplete = true;
//
//  Animation _animation;
//
//  @override
//  void initState() {
//    super.initState();
//    _controller = AnimationController(
//      vsync: this,
//      duration: _duration,
//    );
////    _controller = AnimationController(
////      vsync: this,
////      duration: _duration,
////    )..repeat();
//
//    _controller.addListener(() {
//      setState(() {});
//      print(_animation.value);
//    }); //no effect?
////    TickerFuture tickerFuture = _controller.repeat();
////    tickerFuture.timeout(_duration, onTimeout: () {
////      _controller.forward(from: 0);
////      _controller.stop(canceled: true);
////    });
//
//    _controller.addStatusListener((status) {
//      if (status == AnimationStatus.completed) {
////        _setDuration(context);
//        print('controller status completed');
//      }
//    });
//
//    _animation = Tween<double>(begin: pi * 2, end: 0.0).animate(
//        CurvedAnimation(parent: _controller, curve: Curves.linear))
//      ..addStatusListener((AnimationStatus status) {
//        if (status == AnimationStatus.dismissed) //the end of reverse animation
//          print('completed');
//      });
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    _controller.dispose();
//  }
//
//  void _playSound() {
//    final assetsAudioPlayer = AssetsAudioPlayer();
//    assetsAudioPlayer.open(
//      Audio("assets/audio/gong.mp3"),
//      autoStart: true,
//    );
//  }
//
////  void _start() {
////    _playSound();
////    _startAnimation();
////  }
////
////  void _startAnimation() {
////    if (!_stopwatch.isRunning) {
////      _stopwatch.start();
////    }
////    if (_timer != null) {
////      if (_timer.isActive) return;
////    }
////    _timer = Timer.periodic(Duration(milliseconds: 10), (Timer t) {
////      // update display
////      setState(() {
////        var diff = (_duration - _stopwatch.elapsed);
////        _display = diff.clockFmt();
////        if (diff.inMilliseconds <= 0) {
////          _playSound();
////          _end(cancelled: false);
////        }
////      });
////    });
////  }
//
////  // This will pause the timer
////  void pause() {
////    if (!_stopwatch.isRunning) {
////      return;
////    }
////    setState(() {
////      _stopwatch.stop();
////      _timer.cancel();
////    });
////  }
//
//  // This will stop the timer
////  void _end({bool cancelled = true}) {
////    if (!_stopwatch.isRunning) {
////      return;
////    }
////    setState(() {
////      _timer.cancel();
////      _stopwatch.stop();
////    });
////
////    if (cancelled) {
////      Navigator.pop(context);
////    } else {
////      _setDuration(context);
////      setState(() {
////        getCongrats;
////        offstageEndButton = true;
////        offstageComplete = false;
////        offstageStartAgain = false;
////      });
////    }
////  }
//
//  DurationModel _getDurationModel() => DurationModel(
//        id: documentIdFromCurrentDate(),
//        jobId: widget.job.id,
//        duration: _duration,
//      );
//
//  Future<void> _setDuration(BuildContext context) async {
//    try {
//      final duration = _getDurationModel();
//      await widget.database.setDuration(duration);
//    } on PlatformException catch (e) {
//      PlatformExceptionAlertDialog(
//        title: 'Operation failed',
//        exception: e,
//      ).show(context);
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    Size size = MediaQuery.of(context).size;
//
//    return Stack(
//      fit: StackFit.expand,
//      children: <Widget>[
//        Image.network(Constants.homePageImage, fit: BoxFit.cover),
//        //TODO update LinearGradient
//        ContainerLinearGradient(),
//        Scaffold(
//          backgroundColor: Colors.transparent,
//          body: Column(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: <Widget>[
//                  IconButton(
//                    onPressed: () => Navigator.pop(context),
//                    icon: Icon(Icons.clear, size: 30),
//                    color: Colors.white,
//                  )
//                ],
//              ),
//              Column(
//                children: <Widget>[
//                  Text(
//                    'Today',
//                    style: TextStyle(fontSize: 25, color: Colors.white),
//                  ),
//                  Text(
//                    widget.job.title,
//                    style: Theme.of(context).textTheme.headline4,
//                  ),
//
////                  Padding(
////                    padding: const EdgeInsets.all(10.0),
////                    child: AutoSizeText(
////                      '“$quoteBody”',
////                      style: Theme.of(context)
////                          .textTheme
////                          .headline6
////                          .copyWith(fontStyle: FontStyle.italic),
////                      textAlign: TextAlign.center,
////                    ),
////                  ),
////                  SizedBox(height: 5),
////                  Padding(
////                    padding: const EdgeInsets.all(15.0),
////                    child: Text(
////                      quoteAuthor,
////                      textAlign: TextAlign.right,
////                      style: Theme.of(context).textTheme.subtitle2,
////                    ),
////                  ),
//                ],
//              ),
//              AnimatedBuilder(
//                  animation: _animation,
//                  builder: (context, child) {
//                    return Stack(
//                      alignment: Alignment.center,
//                      children: <Widget>[
//                        AspectRatio(
//                          aspectRatio: 1.0,
//                          child: CustomPaint(
//                            painter: ThinAndThickRing(
//                                thinRing: Colors.grey[200].withOpacity(0.5),
//                                thickRing: Colors.white,
//                                animation: _animation),
//                          ),
//                        ),
//                        Center(
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              Text(
//                                timerString,
//                                style: TextStyle(
//                                    fontSize: 80, color: Colors.white),
//                              ),
//                              SizedBox(height: 10),
//                              Text(
//                                'Time to focus',
//                                style: TextStyle(
//                                    fontSize: 30, color: Colors.white),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ],
//                    );
//                  }),
//              AnimatedBuilder(
//                  animation: _controller,
//                  builder: (context, child) {
//                    return TransparentFlatButton(
//                        color: _controller.isAnimating
//                            ? Colors.grey[300]
//                            : Colors.white,
//                        onPressed: () {
//                          setState(() {
//                            if (_controller.isAnimating)
//                              _controller.stop();
//                            else {
////                              _controller.reverse(
////                                  from: _controller.value == 0.0
////                                      ? 1.0
////                                      : _controller.value);
//                              _controller.reverse(from: 1);
//                            }
//                          });
////                          if (_isPlaying)
////                            _controller.reset();
////                          else
////                            _controller.repeat();
////                          setState(() => _isPlaying = !_isPlaying);
//                        },
//                        text: _controller.isAnimating ? 'Pause' : 'START');
//                  })
//            ],
//          ),
//        ),
//      ],
//    );
//  }
//
//  Text get getCongrats {
//    return Text('Congratulations! You have focused '
//        '${_duration.abs().inMinutes.toString()} minutes');
//  }
//}
