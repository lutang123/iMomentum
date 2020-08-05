import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/shared_axis.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/common_widgets/extensions.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';
import 'clock_bottom.dart';
import 'clock_start.dart';
import 'clock_timer_screen.dart';
import 'package:iMomentum/app/services/pages_routes.dart';
import 'clock_title.dart';

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

  @override
  void dispose() {
//    _durationFocusNode.dispose();
//    _restFocusNode.dispose();
    super.dispose();
  }

//  bool _selected25 = true;
//  bool _selected50 = false;

//  void _duration25() {
//    if (_selected25 != true) {
//      setState(() {
//        _selected25 = !_selected25;
//        _selected50 = !_selected50;
//        _duration = Duration(minutes: 25);
//      });
//    }
//  }
//
//  void _duration50() {
//    if (_selected50 != true) {
//      setState(() {
//        _selected50 = !_selected50;
//        _selected25 = !_selected25;
//        _duration = Duration(minutes: 1);
//      });
//    }
//  }

  //, rootNavigator: true
  void _play() {
    ///this one is too fast, (changed millisecond)
    final route = SharedAxisPageRoute(
        page: ClockTimerScreen(
          database: widget.database,
          todo: widget.todo,
          duration: Duration(minutes: _durationInMin),
          restDuration: Duration(minutes: _restInMin),
          playSound: _playSound,
        ),
        transitionType: SharedAxisTransitionType.scaled,
        milliseconds: 800);
    Navigator.of(context).push(route);

    ///somehow this is changed to be black and then comes out
    //default milliseconds = 1800
//    Navigator.of(context).pushReplacement(
//      PageRoutes.fade(
//        () => ClockTimerScreen(
//          database: widget.database,
//          todo: widget.todo,
//          duration: Duration(minutes: _durationInMin),
//          restDuration: Duration(minutes: _restInMin),
//        ),
//      ),
//    );
  }

  bool _playSound = true;

  //https://stackoverflow.com/questions/51962272/how-to-refresh-an-alertdialog-in-flutter

  void showEditDialog(BuildContext context) async {
//    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    var typedNumber = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Color(0xf01b262c), // //
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text(
              "Change Focus Setting",
//            style: Theme.of(context).textTheme.headline6,
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
//                              focusNode: _durationFocusNode,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    (value.isNotEmpty) && (int.parse(value) > 0)
                                        ? null
                                        : 'error',
                                onSaved: (value) =>
                                    _durationInMin = int.parse(value),
                                //if submit successfully, we pop this page and go to home page
//                              onEditingComplete: _onEditingComplete,
                                style: TextStyle(
//                        color: _darkTheme ? Colors.white : Color(0xF01b262c),
                                    fontSize: 20.0),
                                autofocus: true,
//                    textAlign: TextAlign.center,
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
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
                                onSaved: (value) =>
                                    _restInMin = int.parse(value),
//                              focusNode: _restFocusNode,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    (value.isNotEmpty) && (int.parse(value) > 0)
                                        ? null
                                        : 'error',
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
                                    borderSide: BorderSide(color: Colors.white),
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
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancel',
                      style: Theme.of(context).textTheme.bodyText1),
                  onPressed: () =>
                      Navigator.of(context).pop([_durationInMin, _restInMin])),
              FlatButton(
                  child: Text('Done',
                      style: Theme.of(context).textTheme.bodyText1),
                  onPressed: () => _done(context)),
            ],
          );
        });
      },
    );
//    print('typedNumber: $typedNumber');

    setState(() {
      _durationInMin = typedNumber[0];
    });
    _restInMin = typedNumber[1];
//    print('_restInMin: $_restInMin');
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    //validate
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
      Navigator.of(context).pop([_durationInMin, _restInMin]);
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
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.clear, size: 30),
                            color: Colors.white,
                          )
                        ],
                      ),
                    ), //clear icon
                    ClockTitle(
                      title: 'Time to focus',
                      subtitle: 'Break your work into intervals',
                    ), //begin title
//                    SizedBox(
//                      height: 20,
////                      child: Row(
////                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
////                        children: <Widget>[
////                          MyFlatButton(
////                            color: _selected25
////                                ? Colors.white
////                                : Colors.grey[300].withOpacity(0.75),
////                            onPressed: _duration25,
////                            text: '25 minutes',
////                          ),
////                          MyFlatButton(
////                            color: _selected50
////                                ? Colors.white
////                                : Colors.grey[300].withOpacity(0.75),
////                            onPressed: _duration50,
////                            text: '50 minutes',
////                          ),
////                        ],
////                      ),
//                    ),
                    ClockStart(
                      text1: Duration(minutes: _durationInMin).clockFmt(),
                      text2: '',
                      height: 0,
                      onPressed: _play,
                      onPressedEdit: () => showEditDialog(context),
                    ),
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
}
