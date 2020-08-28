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
                      onPressed: () => _play(context),
                      onPressedEdit: () => showEditDialog(context),
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

  void _play(BuildContext context) {
    ///this one is too fast, (changed millisecond)
    ///
    /// on timer screen, if cancelled, we do this: Navigator.pop(context);
    /// if using SharedAxisPageRoute, it pop up to Timer begin Screen
//    final route = SharedAxisPageRoute(
//      page: ClockTimerScreen(
//        database: widget.database,
//        todo: widget.todo,
//        duration: Duration(minutes: _durationInMin),
//        restDuration: Duration(minutes: _restInMin),
//        playSound: _playSound,
//      ),
//      transitionType: SharedAxisTransitionType.scaled,
////        milliseconds: 400, //default
//    );
//    //if add BuildContext context in play method, context changes to white color,
//    // but nothing else seems changed, I want to make navigation not having black screen flash
//    Navigator.of(context).push(route);

    ///somehow this is changed to be black and then comes out
    ///
    ///  if using SharedAxisPageRoute, from Timer Screen cancel button,
    ///  it pop up to Home Screen
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
  void showEditDialog(BuildContext context) async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    setState(() {
      _topOpacity = 0.0;
    });
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(top: 10.0),
            backgroundColor: Color(0xf01b262c),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text(
              "Change Focus Setting",
              textAlign: TextAlign.center,
//            style: Theme.of(context).textTheme.headline6,
            ),
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
                        Text('Focus length'),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 70,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  initialValue: _durationInMin.toString(),
//
                                  validator: (value) => (value.length == 0) ||
                                          (int.parse(value) < 0) ||
                                          (int.parse(value) == 0)
                                      ? 'Error'
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      _durationInMin != int.parse(value)
                                          ? _isDifferentLength = true
                                          : _isDifferentLength = false;
                                    });
                                  },
                                  onSaved: (value) =>
                                      _durationInMin = int.parse(value),
                                  //if submit successfully, we pop this page and go to home page
//                              onEditingComplete: _onEditingComplete,
//                                focusNode: _durationFocusNode,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
//                        color: _darkTheme ? Colors.white : Color(0xF01b262c),
                                      fontSize: 20.0),
                                  autofocus: true,
//                    textAlign: TextAlign.center,
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
                            Text('min'),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Rest length'),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 70,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  initialValue: _restInMin.toString(),
                                  validator: (value) => (value.length == 0) ||
                                          (int.parse(value) < 0) ||
                                          (int.parse(value) == 0)
                                      ? 'Error'
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      _restInMin != int.parse(value)
                                          ? _isDifferentLength = true
                                          : _isDifferentLength = false;
                                    });
                                  },
                                  onSaved: (value) =>
                                      _restInMin = int.parse(value),
//                              focusNode: _restFocusNode,
//                                textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.number,
                                  //if submit successfully, we pop this page and go to home page
//                    onEditingComplete: _submit,
                                  style: TextStyle(
//                        color: _darkTheme ? Colors.white : Color(0xF01b262c),
                                      fontSize: 20.0),
//                              autofocus: true,
//                    textAlign: TextAlign.center,
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
                            Text('min'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Play sounds'),
                        SizedBox(
                          width: 50,
                          child: Container(
//                        color: Colors.purpleAccent,
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
                        ),
                      ],
                    ),

                    Container(
//                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ///Todo: change color when typing
                            FlatButton(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: _darkTheme
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                                shape: _isDifferentLength || _playSound == false
                                    ? null
                                    : RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(68.0),
                                        side: BorderSide(
                                            color: Colors.white70, width: 2.0)),
                                onPressed: () {
                                  setState(() {
                                    _topOpacity = 1.0;
                                  });
                                  Navigator.of(context).pop();
                                }),
                            FlatButton(
                                child: Text('Done',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                shape: _isDifferentLength || _playSound == false
                                    ? RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(68.0),
                                        side: BorderSide(
                                            color: Colors.white70, width: 2.0))
                                    : null,
                                onPressed: () => _done(context)),
                          ],
                        ),
                      ),
                    ),

                    ///tried to use ListTile as in drawer but design not looking good
//                ListTile(
//                  title: Text('Play sounds'),
//                  trailing: Transform.scale(
//                    scale: 0.9,
//                    child: CupertinoSwitch(
//                      activeColor: switchActiveColor,
//                      trackColor: Colors.grey,
//                      value: _playSound,
//                      onChanged: (val) {
//                        _playSound = val;
//                      },
//                    ),
//                  ),
//                ),
                  ],
                ),
              ),
            ),
//            actions: <Widget>[
//              FlatButton(
//                  child: Text('Cancel',
//                      style: TextStyle(
//                          fontSize: 20,
//                          color: _darkTheme ? Colors.white70 : Colors.black54)),
//                  onPressed: () => Navigator.of(context).pop()),
//              FlatButton(
//                  child: Text('Done',
//                      style: Theme.of(context).textTheme.headline6),
//                  onPressed: () => _done(context)),
//            ],
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
  //when we don't have BuildContext context, we used a wrong context and it popped to home screen

  void _done(BuildContext context) {
    if (_validateAndSaveForm()) {
      setState(() {
        _topOpacity = 1.0;
        _durationInMin = _durationInMin;
      });
      _restInMin = _restInMin;
      Navigator.of(context).pop();
    }

    ///this is wrong
//    if (mounted) {
//      setState(() {
//        _durationInMin = typedNumber[0];
//      });
//    }
//    _restInMin = typedNumber[1];
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
      duration: Duration(seconds: 10),
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

//      Text(
//          'Our Focus Mode uses Pomodoro Technique to help you focus.',
//          style: KFlushBarTitle),
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
