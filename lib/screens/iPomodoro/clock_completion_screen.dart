import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_tooltip.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/utils/format.dart';
import 'package:iMomentum/app/common_widgets/my_round_button.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/models/data/congrats_list.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/utils/extension_clockFmt.dart';
import 'package:iMomentum/app/services/calendar_bloc.dart';
import 'package:iMomentum/app/services/daily_todos_details.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';
import '../../app/utils/pages_routes.dart';
import 'clock_bottom.dart';
import 'clock_rest_screen.dart';
import 'clock_begin_screen.dart';
import 'clock_start.dart';
import 'clock_mantra_quote_title.dart';

class CompletionScreen extends StatefulWidget {
  CompletionScreen(
      {this.database,
      this.todo,
      this.duration,
      this.restDuration,
      this.playSound});
  final Todo todo;
  final Database database;
  final Duration duration;
  final Duration restDuration;
  final bool playSound;

  @override
  _CompletionScreenState createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen> {
  final String _congrats = CongratsList().getCongrats().body;

  int _restDurationInMin;

  double _topOpacity = 1.0;
  double _todayDuration = 0; //this is just inital value

  @override
  void initState() {
    _restDurationInMin = widget.restDuration.inMinutes;
    super.initState();
  }

  void _play() {
    Navigator.of(context).pushReplacement(
      PageRoutes.fade(
        () => RestScreen(
          database: widget.database,
          job: widget.todo,
          restDuration: Duration(minutes: _restDurationInMin),
          playSound: widget.playSound,
        ),
      ),
    );
  }

  void _clearButton() {
    /// not go back to HomeScreen
//  Navigator.pop(context);
    Navigator.of(context).pushReplacement(PageRoutes.fade(
        () => ClockBeginScreen(
              database: widget.database,
              todo: widget.todo,
            ),
        milliseconds: 450));
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
    final bloc = Provider.of<CalendarBloc>(context, listen: false);
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
                    Opacity(
                      opacity: _topOpacity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              onPressed: _clearButton,
                              icon: Icon(Icons.arrow_back_ios, size: 30),
                              color: Colors.white,
                            ),
                            StreamBuilder<List<TodoDuration>>(
                                stream: bloc
                                    .allTodoDurationStream, //print: flutter: Instance of '_MapStream<List<TodoDuration>, dynamic>'
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final List<TodoDuration> entries = snapshot
                                        .data; //print('x: $entries'); //x: [Instance of 'TodoDuration', Instance of 'TodoDuration']
                                    if (entries.isNotEmpty) {
                                      _todayDuration = DailyTodosDetails
                                          .getDailyTotalDuration(
                                              DateTime.now(), entries);
//                                            print(_todayDuration); // if no data, it will show null, not 0
                                      ///moved StreamBuilder up above TabBarView, otherwise we got error: Bad state: Stream has already been listened to
                                      return progressButton(_todayDuration);
                                    } else {
                                      ///actually we don't need to check this
                                      return progressButton(_todayDuration);
                                    }
                                  } else if (snapshot.hasError) {
                                    ///still show it but onPress is null
                                    return MyToolTip(
                                      message: 'See my progress for today',
                                      child: RoundSmallIconButton(
                                        //this is only for if it has error
                                        icon: EvaIcons.trendingUpOutline,
                                        onPressed: null,
                                        color: Colors.white,
                                      ),
                                    );
                                  }
                                  return Center(
                                      child: CircularProgressIndicator());
                                }),
                          ],
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: _topOpacity,
                      child: ClockTitle(
                          title: _congrats,
                          subtitle:
                              'Your have stayed focused for ${widget.duration.inMinutes} minutes.'),
                    ), //clear button
                    ClockStart(
                      text1: Duration(minutes: _restDurationInMin).clockFmt(),
                      text2: 'Take a break',
                      height: 15,
                      onPressed: _play,
                      onPressedEdit: () => showEditDialog(),
                    ),
                    SizedBox(height: 60),
                    ClockBottomToday(text: '${widget.todo.title}'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget progressButton(double todayDuration) {
    return MyToolTip(
      message: 'See my progress for today',
      child: RoundSmallIconButton(
        icon: EvaIcons.trendingUpOutline,
        onPressed: () => _showFlushBar(todayDuration),
        color: Colors.white,
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  bool _isDifferentLength = false;
  void showEditDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext _) {
        ///cancel and done button all have context from here
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: darkThemeNoPhotoColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text(
              "Change Focus Setting",
              textAlign: TextAlign.center,
              style: KDialogTitle,
            ),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Rest length', style: KDialogContent),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 70,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                initialValue: _restDurationInMin.toString(),
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    (value.isNotEmpty) && (int.parse(value) > 0)
                                        ? null
                                        : 'error',
                                onChanged: (value) {
                                  setState(() {
                                    _restDurationInMin != int.parse(value)
                                        ? _isDifferentLength = true
                                        : _isDifferentLength = false;
                                  });
                                },
                                onSaved: (value) =>
                                    _restDurationInMin = int.parse(value),
                                style: KDialogContent,
                                autofocus: true,
                                cursorColor: Colors.white,
                                decoration: KTextFieldInputDecoration,
                              ),
                            ),
                          ),
                          Text('min', style: KDialogContent),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                            child: Text(
                              'Cancel',
                              style: KDialogButton,
                            ),
                            shape: _isDifferentLength
                                ? null
                                : RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(68.0),
                                    side: BorderSide(
                                        color: Colors.white70, width: 2.0)),
                            onPressed: () {
                              setState(() {
                                _topOpacity = 1.0;
                              });
                              Navigator.of(context).pop();
                            }),
                        FlatButton(
                            child: Text(
                              'Done',
                              style: KDialogButton,
                            ),
                            shape: _isDifferentLength
                                ? RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(68.0),
                                    side: BorderSide(
                                        color: Colors.white70, width: 2.0))
                                : null,

                            ///_done must have a BuildContext, so that it will
                            ///use the same context as cancel button, which is all from StatefulBuilder
                            onPressed: () => _done(context)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  ///when we don't have BuildContext context, we used a wrong context and it popped to home screen
  void _done(BuildContext context) {
    if (_validateAndSaveForm()) {
      setState(() {
        _restDurationInMin = _restDurationInMin;
      });

      Navigator.of(context).pop();
    }
  }

  void _showFlushBar(double todayDuration) {
    setState(() {
      _topOpacity = 0.0;
    });
    Flushbar(
      ///must remove
      // mainButton: FlatButton(
      //   onPressed: () {
      //     setState(() {
      //       _topOpacity = 1.0;
      //     });
      //     Navigator.pop(context);
      //   },
      //   child: FlushBarButtonChild(title: 'OK.'),
      // ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(10),
      borderRadius: 10,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundGradient: KFlushBarGradient,
      duration: Duration(seconds: 4),
      titleText: RichText(
        text: TextSpan(
          style: KFlushBarTitle,
          children: <TextSpan>[
            TextSpan(text: 'Your total focused time for today is: '),
            TextSpan(
                text: '${Format.minutes(todayDuration)} so far.',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontFamily: "ShadowsIntoLightTwo")),
            TextSpan(text: 'Keep Going!')
          ],
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
            'You can find detailed daily focus summary from Todo screen.',
            style: KFlushBarMessage),
      ),
    )..show(context).then((value) => setState(() {
          _topOpacity = 1.0;
        }));
  }
}
