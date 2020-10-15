import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/utils/extension_clockFmt.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/utils/pages_routes.dart';
import 'package:iMomentum/screens/iPomodoro/pomodoro_base_screen.dart';
import 'package:provider/provider.dart';
import 'clock_bottom.dart';
import 'clock_start.dart';
import 'clock_timer_screen.dart';
import 'clock_mantra_quote_title.dart';

//https://momentumdash.com/blog/pomodoro-timer

class ClockBeginScreen extends StatefulWidget {
  const ClockBeginScreen({this.database, this.todo});
  final Todo todo;
  final Database database;

  @override
  _ClockBeginScreenState createState() => _ClockBeginScreenState();
}

class _ClockBeginScreenState extends State<ClockBeginScreen> {
//  Duration _duration; //old
  int _durationInMin;
  int _restInMin;

//  FocusNode _durationFocusNode = FocusNode(); //not useful on numbers
//  FocusNode _restFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
//    _duration = Duration(minutes: 25); //old
    _durationInMin = 25;
    _restInMin = 5;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PomodoroBaseScreen(
      leadingWidget: IconButton(
        /// go back to HomeScreen
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.clear, size: 30),
        color: Colors.white,
      ),
      actionWidget: Container(),
      titleWidget: PomodoroTitle(
        title: 'Time to focus',
        subtitle: 'Break your work into intervals',
      ),
      bigCircle: ClockStart(
        text1: Duration(minutes: _durationInMin).clockFmt(),
        text2: '',
        height: 0,
        onPressed: () => _play(),
        onPressedEdit: () => showEditDialog(),
      ),
      timerButton: Container(),
      bottomWidget: ClockBottomToday(text: '${widget.todo.title}'),
    );
  }

  //if add BuildContext context in play method, context changes to white color,
  // but nothing else seems changed.
  void _play() {
    /// on timer screen, if cancelled, we do this: Navigator.pop(context);
    /// if using SharedAxisPageRoute, it pop up to Timer begin Screen
//     final route = SharedAxisPageRoute(
//       page: ClockTimerScreen(
//         database: widget.database,
//         todo: widget.todo,
//         duration: Duration(minutes: _durationInMin),
//         restDuration: Duration(minutes: _restInMin),
//         playSound: _playSound,
//       ),
//       transitionType: SharedAxisTransitionType.scaled,
// //        milliseconds: 400, //default
//     );
//     Navigator.of(context).push(route);

    /// this one, if canceled, it goes to HomeScreen which is what we want.
    //default milliseconds = 1800
    Navigator.of(context).pushReplacement(
      PageRoutes.fade(
        () => ClockTimerScreen(
          database: widget.database,
          todo: widget.todo,
          duration: Duration(minutes: _durationInMin),
          restDuration: Duration(minutes: _restInMin),
          playSound: _playSound,
        ),
      ),
    );
  }

  bool _playSound = true;
  bool _isDifferentLength = false; //this is for changing duration.
  void showEditDialog() async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    await showDialog(
      context: context,
      builder: (BuildContext _) {
        ///cancel and done button all have context from here
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(top: 10.0),
            backgroundColor:
                _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Change Focus Setting",
                textAlign: TextAlign.center,
                style: _darkTheme ? KDialogTitle : KDialogTitleLight),
            content: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    rowFocusLength(_darkTheme, setState),
                    rowRestLength(_darkTheme, setState),
                    SizedBox(height: 5),
                    rowPlaySounds(_darkTheme, setState),
                    rowButton(_darkTheme, context),

                    ///tried to use ListTile for switch button as in drawer but design not looking good
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Padding rowButton(bool _darkTheme, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlatButton(
              child: Text(
                'Cancel',
                style: _darkTheme ? KDialogButton : KDialogButtonLight,
              ),
              shape: _isDifferentLength || _playSound == false
                  ? null
                  : RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(68.0),
                      side: BorderSide(
                          color: _darkTheme ? darkThemeHint : lightThemeHint,
                          width: 1.0)),
              onPressed: () {
                // setState(() {
                //   _topOpacity = 1.0;
                // });
                Navigator.of(context).pop();
              }),
          FlatButton(
              child: Text(
                'Done',
                style: _darkTheme ? KDialogButton : KDialogButtonLight,
              ),
              shape: _isDifferentLength || _playSound == false
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(68.0),
                      side: BorderSide(
                          color: _darkTheme ? darkThemeHint : lightThemeHint,
                          width: 1.0))
                  : null,

              ///_done must have a BuildContext, so that it will
              ///use the same context as cancel button, which is all from StatefulBuilder
              onPressed: () => _done(context)),
        ],
      ),
    );
  }

  Row rowPlaySounds(bool _darkTheme, StateSetter setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Play sounds',
            style: _darkTheme ? KDialogContent : KDialogContentLight),
        SizedBox(
          width: 50,
          child: Transform.scale(
            scale: 0.9,
            child: CupertinoSwitch(
              activeColor:
                  _darkTheme ? switchActiveColorDark : switchActiveColorLight,
              trackColor: Colors.grey,
              value: _playSound,
              onChanged: (val) {
                print(val);
                setState(() {
                  _playSound = val;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Row rowRestLength(bool _darkTheme, StateSetter setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Rest length',
            style: _darkTheme ? KDialogContent : KDialogContentLight),
        Row(
          children: <Widget>[
            SizedBox(
              width: 70,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    initialValue: _restInMin.toString(),
                    validator: (value) =>
                        (value.isNotEmpty) && (int.parse(value) > 0)
                            ? null
                            : 'error',
                    onChanged: (value) {
                      setState(() {
                        _restInMin != int.parse(value)
                            ? _isDifferentLength = true
                            : _isDifferentLength = false;
                      });
                    },
                    onSaved: (value) => _restInMin = int.parse(value),
                    keyboardType: TextInputType.number,
                    style: _darkTheme ? KDialogContent : KDialogContentLight,
                    cursorColor: _darkTheme ? darkThemeWords : lightThemeWords,
                    decoration: _darkTheme
                        ? KTextFieldInputDecorationDark
                        : KTextFieldInputDecorationLight),
              ),
            ),
            Text('min',
                style: _darkTheme ? KDialogContent : KDialogContentLight),
          ],
        ),
      ],
    );
  }

  Row rowFocusLength(bool _darkTheme, StateSetter setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Focus length',
          style: _darkTheme ? KDialogContent : KDialogContentLight,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 70,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    initialValue: _durationInMin.toString(),

                    ///int.tryParse returns a null on an invalid number;
                    ///int.parse returns an exception on an invalid number;
                    //it does not matter in this case, because it's always number
                    validator: (value) =>
                        (value.isNotEmpty) && (int.parse(value) > 0)
                            ? null
                            : 'error',

                    ///below not good
                    // (value) => (value.length == 0) ||
                    //     (int.tryParse(value) < 0) ||
                    //     (int.tryParse(value) == 0)
                    // ? 'Error'
                    // : null,
                    onChanged: (value) {
                      setState(() {
                        _durationInMin != int.tryParse(value)
                            ? _isDifferentLength = true
                            : _isDifferentLength = false;
                      });
                    },
                    onSaved: (value) => _durationInMin = int.tryParse(value),
                    keyboardType: TextInputType.number,
                    style: _darkTheme ? KDialogContent : KDialogContentLight,
                    autofocus: true,
                    cursorColor: _darkTheme ? darkThemeWords : lightThemeWords,
                    decoration: _darkTheme
                        ? KTextFieldInputDecorationDark
                        : KTextFieldInputDecorationLight),
              ),
            ),
            Text('min',
                style: _darkTheme ? KDialogContent : KDialogContentLight),
          ],
        ),
      ],
    );
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState; //validate
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
        _durationInMin = _durationInMin;
      });
      _restInMin = _restInMin;
      Navigator.of(context).pop();
    }
  }

  // double _topOpacity = 1.0;

  // void _showFlushBar() async {
  //   setState(() {
  //     _topOpacity = 0.0;
  //   });
  //
  //   await flushbar();
  // }
  //
  // Future<Flushbar> flushbar() async {
  //   return Flushbar(
  //     margin: const EdgeInsets.all(20),
  //     padding: const EdgeInsets.all(8),
  //     borderRadius: 15,
  //     flushbarPosition: FlushbarPosition.TOP,
  //     flushbarStyle: FlushbarStyle.FLOATING,
  //     backgroundGradient: KFlushBarGradient,
  //     duration: Duration(seconds: 4),
  //     titleText: RichText(
  //       text: TextSpan(
  //         style: KFlushBarTitle,
  //         children: <TextSpan>[
  //           TextSpan(text: 'Our Focus Mode uses '),
  //           TextSpan(
  //             text: 'Pomodoro Technique ',
  //             style: KFlushBarEmphasis,
  //           ),
  //           TextSpan(text: 'to help you focus.')
  //         ],
  //       ),
  //     ),
  //     messageText: GestureDetector(
  //       onTap: () async {
  //         const url = 'https://en.wikipedia.org/wiki/Pomodoro_Technique';
  //         if (await canLaunch(url)) {
  //           await launch(url);
  //         } else {
  //           throw 'Could not launch $url';
  //         }
  //       },
  //       child: Padding(
  //         padding: const EdgeInsets.only(top: 5),
  //         child: Text('Learn more.', style: KTextButton),
  //       ),
  //     ),
  //   )..show(context).then((value) => setState(() {
  //         _topOpacity = 1.0;
  //       }));
  // }
}
