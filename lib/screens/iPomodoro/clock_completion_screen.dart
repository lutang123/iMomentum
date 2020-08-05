import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/data/congrats_list.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/common_widgets/extensions.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';
import '../../app/services/pages_routes.dart';
import 'clock_bottom.dart';
import 'clock_rest_screen.dart';
import 'clock_begin_screen.dart';
import 'clock_start.dart';
import 'clock_title.dart';

class CompletionScreen extends StatefulWidget {
  CompletionScreen(
      {this.database, this.todo, this.duration, this.restDuration});
  final Todo todo;
  final Database database;
  final Duration duration;
  final Duration restDuration;

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
        ),
      ),
    );
  }

  void _clearButton() {
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

  final _formKey = GlobalKey<FormState>();

  void showEditDialog(BuildContext context) async {
//    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    var typedNumber = await showDialog(
      context: context,
      builder: (BuildContext context) {
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
                              //if submit successfully, we pop this page and go to home page
//                    onEditingComplete: _submit,
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
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancel',
                    style: Theme.of(context).textTheme.bodyText1),
                onPressed: () => Navigator.of(context).pop(_restDurationInMin)),
            FlatButton(
                child:
                    Text('Done', style: Theme.of(context).textTheme.bodyText1),
                onPressed: () => _done(context)),
          ],
        );
      },
    );

    setState(() {
      _restDurationInMin = typedNumber;
    });
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

  void _done(BuildContext context) {
    if (_validateAndSaveForm()) {
      Navigator.of(context).pop(_restDurationInMin);
    }
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
//        Image.network(ImageUrl.randomImageUrl, fit: BoxFit.cover),
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
                            onPressed: _clearButton,
                            icon: Icon(Icons.clear, size: 30),
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    ClockTitle(
                        title: _congrats,
                        subtitle:
                            'Your have stayed focused for ${widget.duration.inMinutes} minutes'), //clear button
                    ClockStart(
                      text1: Duration(minutes: _restDurationInMin).clockFmt(),
                      text2: 'Take a break',
                      height: 10,
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
