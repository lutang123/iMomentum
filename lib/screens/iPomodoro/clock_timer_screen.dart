import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_round_button.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/duration_model.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/utils/extensions.dart';
import 'package:iMomentum/app/services/calendar_bloc.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/utils/pages_routes.dart';
import 'package:provider/provider.dart';
import 'clock_bottom.dart';
import 'clock_completion_screen.dart';
import 'clock_timer.dart';
import 'clock_title.dart';

class ClockTimerScreen extends StatefulWidget {
  const ClockTimerScreen({
    @required this.database,
    @required this.todo,
    this.duration,
    this.restDuration,
    this.playSound,
  });
  final Duration duration;
  final Duration restDuration;
  final Todo todo;
  final Database database;
  final bool playSound;

  @override
  _ClockTimerScreenState createState() => _ClockTimerScreenState();
}

class _ClockTimerScreenState extends State<ClockTimerScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  Stopwatch _stopwatch;
  Timer _timer;

  // This string that is displayed as the countdown timer
  String _display = '';

  @override
  void initState() {
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animationController.forward();
    _playSound();
    _stopwatch = Stopwatch();
    _start();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    //https://github.com/flutter/flutter/issues/22777
    //This ticker was canceled: Ticker(created by _MyHomePageState#a2d8d(lifecycle state: created))
    //removing .orCancel from progressBarAnimationController.forward().orCancel; fixes the issue.
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
      // update display
      ///error here
      ///_ClockTimerScreenState._start.<anonymous closure>
      // https://stackoverflow.com/questions/52288613/how-to-dispose-of-my-stateful-widget-completely
      // https://stackoverflow.com/questions/49340116/setstate-called-after-dispose
      if (mounted) {
        setState(() {
          var diff = (widget.duration - _stopwatch.elapsed);
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

  // This will stop the timer, in cancel button, cancel == true
  void _end({bool cancelled = true}) {
    ///wrong
//    if (!_stopwatch.isRunning) {
//      return;
//    }
    setState(() {
      _timer.cancel();
      _stopwatch.stop();
    });

    if (cancelled) {
      ///this is wrong
//      //https://stackoverflow.com/questions/49672706/flutter-navigation-pop-to-index-1
//      int count = 0;
//      Navigator.popUntil(context, (route) {
//        return count++ == 2;
//      });
      /// go back to HomeScreen
      Navigator.pop(context);
    } else {
      ///save duration in database when it's done
      _setDuration(context);

      ///then go to completion page
      Navigator.of(context).pushReplacement(PageRoutes.fade(
          () => Provider<CalendarBloc>(
                create: (_) => CalendarBloc(database: widget.database),
                child: CompletionScreen(
                  database: widget.database,
                  todo: widget.todo,
                  duration: widget.duration,
                  restDuration: widget.restDuration,
                  playSound: widget.playSound,
                ),
              ),
          milliseconds: 800));
    }
  }

  DurationModel _getDurationModel() => DurationModel(
        id: documentIdFromCurrentDate(),
        todoId: widget.todo.id,

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

  int counter = 0;
  void _onDoubleTap() {
    setState(() {
      ImageUrl.randomImageUrl = '${ImageUrl.randomImageUrlFirstPart}$counter';
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final randomNotifier = Provider.of<RandomNotifier>(context, listen: false);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context, listen: false);
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
                    ///just to make sure the clock is in the same position
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Opacity(
                            opacity: 0.0,
                            child: IconButton(
                              onPressed: null,
                              icon: Icon(Icons.clear, size: 30),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ), //clear button
                    ClockTitle(
                      title: 'Time to focus',
                      subtitle: 'Break your work into intervals',
                    ), //begin title
                    ClockTimer(
                      duration: widget.duration,
                      animationController: _animationController,
                      text1: _display,
                      text2: 'Focus',
                    ),
                    SizedBox(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RoundTextButton(
                              text: 'Cancel',
                              textColor: Colors.white70,

                              /// go back to HomeScreen
                              onPressed: () => _end(cancelled: true),
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
                                        Colors.deepOrange.withOpacity(0.3),
                                  )
                                : RoundTextButton(
                                    text: 'Resume',
                                    textColor: Colors.white,
                                    onPressed: _resume,
                                    circleColor: Colors.white,
                                    fillColor: Colors.green.withOpacity(0.2),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    ClockBottomToday(
                      text: '${widget.todo.title}',
//                      maxLines: 1,
                    ), //clock
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

///we can not update it because it's not StreamBuilder
/// update & at the same time update _selectedList
//  void _onTapTodo(Database database, Todo todo) async {
//    var _typedTitleAndComment = await showModalBottomSheet(
//      context: context,
//      isScrollControlled: true,
//      builder: (context) => AddTodoScreen(
//        database: database,
//        todo: todo,
//        pickedDate: todo.date,
//      ),
//    );
//
//    if (_typedTitleAndComment != null) {
//      try {
//        //we get the id from job in the firebase, if the job.id is null,
//        //we create a new one, otherwise we use the existing job.id
//        final id = todo?.id ?? documentIdFromCurrentDate();
//        final isDone = todo?.isDone ?? false;
//
//        ///first we find this specific Todo item that we want to update
//        final newTodo = Todo(
//            id: id,
//            title: _typedTitleAndComment[0],
//            comment: _typedTitleAndComment[1],
//            date: _typedTitleAndComment[2],
//            isDone: isDone);
//        //add newTodo to database
//        await database.setTodo(newTodo);
//
//        ///try this to update screen, why it's not working??
//        setState(() {
//          todo = newTodo;
//        });
//        print(newTodo.comment);
//      } on PlatformException catch (e) {
//        PlatformExceptionAlertDialog(
//          title: 'Operation failed',
//          exception: e,
//        ).show(context);
//      }
//    }
//  }
