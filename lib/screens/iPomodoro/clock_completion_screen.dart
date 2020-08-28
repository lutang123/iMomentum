import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/utils/format.dart';
import 'package:iMomentum/app/common_widgets/my_round_button.dart';
import 'package:iMomentum/app/utils/tooltip_shape_border.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/data/congrats_list.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/utils/extensions.dart';
import 'package:iMomentum/app/services/calendar_bloc.dart';
import 'package:iMomentum/app/services/daily_todos_details.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';
import '../../app/utils/pages_routes.dart';
import 'clock_bottom.dart';
import 'clock_rest_screen.dart';
import 'clock_begin_screen.dart';
import 'clock_start.dart';
import 'clock_title.dart';

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

  @override
  void initState() {
    _restDurationInMin = widget.restDuration.inMinutes;
    super.initState();
  }

  //, rootNavigator: true
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
    //https://stackoverflow.com/questions/49672706/flutter-navigation-pop-to-index-1
//    int count = 0;
//    Navigator.popUntil(context, (route) {
//      return count++ == 2;
//    });
    /// not go back to HomeScreen
//    Navigator.pop(context);
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
      ImageUrl.randomImageUrl =
          'https://source.unsplash.com/random?nature/$counter';
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CalendarBloc>(context, listen: false);

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
                                      return progressButton();
                                    } else {
                                      ///actually we don't need to check this
                                      return progressButton();
                                    }
                                  } else if (snapshot.hasError) {
                                    ///still show it but onPress is null
                                    return Tooltip(
                                      textStyle: TextStyle(color: Colors.white),
                                      preferBelow: false,
                                      verticalOffset: 0,
                                      decoration: ShapeDecoration(
                                        color:
                                            Color(0xf0086972).withOpacity(0.9),
                                        shape:
                                            TooltipShapeBorder(arrowArc: 0.5),
                                        shadows: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 4.0,
                                              offset: Offset(2, 2))
                                        ],
                                      ),
                                      margin: const EdgeInsets.all(30.0),
                                      padding: const EdgeInsets.all(8.0),
                                      message: 'See my progress for today',
                                      child: RoundSmallIconButton(
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
                              'Your have stayed focused for ${widget.duration.inMinutes} minutes'),
                    ), //clear button
                    ClockStart(
                      text1: Duration(minutes: _restDurationInMin).clockFmt(),
                      text2: 'Take a break',
                      height: 10,
                      onPressed: _play,
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

  Widget progressButton() {
    return Tooltip(
      message: 'See my progress for today',
      textStyle: TextStyle(color: Colors.white),
      preferBelow: false,
      verticalOffset: 0,
      decoration: ShapeDecoration(
        color: Color(0xf0086972).withOpacity(0.9),
        shape: TooltipShapeBorder(arrowArc: 0.5),
        shadows: [
          BoxShadow(
              color: Colors.black26, blurRadius: 4.0, offset: Offset(2, 2))
        ],
      ),
      margin: const EdgeInsets.all(30.0),
      padding: const EdgeInsets.all(8.0),
      child: RoundSmallIconButton(
        icon: EvaIcons.trendingUpOutline,
        onPressed: () => _showFlushBar(context, _todayDuration),
        color: Colors.white,
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  void showEditDialog(BuildContext context) async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xf01b262c), // //
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Change Focus Setting",
            textAlign: TextAlign.center,
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
                    Text('Rest length'),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 70,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              initialValue: _restDurationInMin.toString(),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  (value.isNotEmpty) && (int.parse(value) > 0)
                                      ? null
                                      : 'error',
                              onSaved: (value) =>
                                  _restDurationInMin = int.parse(value),
                              style: TextStyle(fontSize: 20.0),
                              autofocus: true,
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
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancel',
                    style: TextStyle(
                        fontSize: 20,
                        color: _darkTheme ? Colors.white70 : Colors.black54)),
                onPressed: () => Navigator.of(context).pop()),
            FlatButton(
                child:
                    Text('Done', style: Theme.of(context).textTheme.headline6),
                onPressed: () => _done(context)),
          ],
        );
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

  void _done(BuildContext context) {
    if (_validateAndSaveForm()) {
      setState(() {
        _restDurationInMin = _restDurationInMin;
      });

      Navigator.of(context).pop();
    }
  }

  double _topOpacity = 1.0;
  double _todayDuration = 0; //this is just inital value
  void _showFlushBar(BuildContext context, double todayDuration) {
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
        child: FlushBarButtonChild(title: 'OK.'),
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(10),
      borderRadius: 10,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
////      reverseAnimationCurve: Curves.decelerate,
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
            TextSpan(text: 'Your total focused time for today is: '),
            TextSpan(
                text: '${Format.minutes(_todayDuration)}. ',
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
        child: Text('You can find detailed summary from Todo screen.',
            style: KFlushBarMessage),
      ),
    )..show(context).then((value) => setState(() {
          _topOpacity = 1.0;
        }));
  }

//  Widget progress() {
//    return Padding(
//      padding: const EdgeInsets.all(8.0),
//      child: Text(
//          'Your total focused time for today is $_todayDuration minutes so far. Keep going!',
//          textAlign: TextAlign.center,
//          style: TextStyle(fontWeight: FontWeight.w600)),
//    );
//  }
}
