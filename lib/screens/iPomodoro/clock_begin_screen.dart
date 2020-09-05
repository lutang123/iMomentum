import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/utils/extensions.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/utils/pages_routes.dart';
import 'package:iMomentum/app/utils/tooltip_shape_border.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'clock_bottom.dart';
import 'clock_start.dart';
import 'clock_timer_screen.dart';
import 'clock_title.dart';

//https://momentumdash.com/blog/pomodoro-timer

class ClockBeginScreen extends StatefulWidget {
  const ClockBeginScreen({this.database, this.todo});
  final Todo todo;
  final Database database;

  @override
  _ClockBeginScreenState createState() => _ClockBeginScreenState();
}

class _ClockBeginScreenState extends State<ClockBeginScreen> {
  // Keeps track of how much time has elapsed
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

  int counter = 0;
  void _onDoubleTap() {
    setState(() {
      ImageUrl.randomImageUrl =
          'https://source.unsplash.com/random?nature/$counter';
      counter++;
    });
  }

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
                    Opacity(
                      opacity: _topOpacity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              /// go back to HomeScreen
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(Icons.clear, size: 32),
                              color: Colors.white,
                            ),
                            IconButton(
                              onPressed: () => _showFlushBar(context),
                              icon: Icon(Icons.info_outline,
                                  color: Colors.white, size: 32),
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: _topOpacity,
                      child: ClockTitle(
                        title: 'Time to focus',
                        subtitle: 'Break your work into intervals',
                      ),
                    ),
                    ClockStart(
                      text1: Duration(minutes: _durationInMin).clockFmt(),
                      text2: '',
                      height: 0,
                      onPressed: () => _play(),
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

  bool _isDifferentLength = false;

  void showEditDialog() async {
    setState(() {
      _topOpacity = 0.0;
    });
    await showDialog(
      context: context,
      builder: (BuildContext _) {
        ///cancel and done button all have context from here
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(top: 10.0),
            backgroundColor: Color(0xf01b262c),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Change Focus Setting",
                textAlign: TextAlign.center, style: KDialogTitle),
            content: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Focus length',
                          style: KDialogContent,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 70,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  initialValue: _durationInMin.toString(),

                                  ///int.tryParse returns a null on an invalid number;
                                  ///int.parse returns an exception on an invalid number;
                                  //it does not matter in this case, because it's always number
                                  validator: (value) => (value.isNotEmpty) &&
                                          (int.parse(value) > 0)
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
                                  onSaved: (value) =>
                                      _durationInMin = int.tryParse(value),
                                  keyboardType: TextInputType.number,
                                  style: KDialogContent,
                                  autofocus: true,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                                  ),
                                ),
                              ),
                            ),
                            Text('min', style: KDialogContent),
                          ],
                        ),
                      ],
                    ),
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
                                  initialValue: _restInMin.toString(),
                                  validator: (value) => (value.isNotEmpty) &&
                                          (int.parse(value) > 0)
                                      ? null
                                      : 'error',
                                  onChanged: (value) {
                                    setState(() {
                                      _restInMin != int.parse(value)
                                          ? _isDifferentLength = true
                                          : _isDifferentLength = false;
                                    });
                                  },
                                  onSaved: (value) =>
                                      _restInMin = int.parse(value),
                                  keyboardType: TextInputType.number,
                                  style: KDialogContent,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                                  ),
                                ),
                              ),
                            ),
                            Text('min', style: KDialogContent),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Play sounds', style: KDialogContent),
                        SizedBox(
                          width: 50,
                          child: Transform.scale(
                            scale: 0.9,
                            child: CupertinoSwitch(
                              activeColor: switchActiveColor,
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
                              shape: _isDifferentLength || _playSound == false
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
                              shape: _isDifferentLength || _playSound == false
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

                    ///tried to use ListTile for switch button as in drawer but design not looking good
                  ],
                ),
              ),
            ),
          );
        });
      },
    ).then((val) {
      //https://stackoverflow.com/questions/49706046/how-run-code-after-showdialog-is-dismissed-in-flutter
      setState(() {
        _topOpacity = 1.0;
      });
    });
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState; //validate
    if (form.validate()) {
      //save
      form.save();
      return true;
    }
    return false;
  }

  ///when we don't have BuildContext context, we used a wrong context and it popped to home screen
  void _done(BuildContext context) {
    if (_validateAndSaveForm()) {
      setState(() {
        _topOpacity = 1.0;
        _durationInMin = _durationInMin;
      });
      _restInMin = _restInMin;
      Navigator.of(context).pop();
    }
  }

  double _topOpacity = 1.0;
  void _showFlushBar(BuildContext context) {
    setState(() {
      _topOpacity = 0.0;
    });

    Flushbar(
      mainButton: FlatButton(
        onPressed: () {
          setState(() {
            _topOpacity = 1.0;
          });
          Navigator.pop(context);
        },
        child: FlushBarButtonChild(
          title: 'Got it.',
        ),
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(10),
      borderRadius: 15,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
//      reverseAnimationCurve: Curves.easeOutCirc,
//      forwardAnimationCurve: Curves.easeOutCirc,
//      backgroundColor: darkBkgdColor, //no effect?
      ///todo: change color
      backgroundGradient:
          LinearGradient(colors: [Color(0xF00f4c75), Color(0xF03282b8)]),
      duration: Duration(seconds: 4),
      titleText: RichText(
        text: TextSpan(
          style: KFlushBarTitle,
          children: <TextSpan>[
            TextSpan(text: 'Our Focus Mode uses '),
            TextSpan(
              text: 'Pomodoro Technique ',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  fontFamily: "ShadowsIntoLightTwo"),
            ),
            TextSpan(text: 'to help you focus.')
          ],
        ),
      ),
      messageText: GestureDetector(
        onTap: () async {
          const url = 'https://en.wikipedia.org/wiki/Pomodoro_Technique';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            'Learn more.',
            style: GoogleFonts.varelaRound(
                fontSize: 16.0,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                decoration: TextDecoration.underline),
          ),
        ),
      ),
    )..show(context).then((value) => setState(() {
          _topOpacity = 1.0;
        }));
  }
}
