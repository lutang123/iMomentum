import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/common_widgets/linear_gradient_container.dart';
import 'package:iMomentum/app/common_widgets/round_icon_button.dart';
import 'package:iMomentum/app/common_widgets/transparent_flat_button.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/data/congrats_list.dart';
import 'package:iMomentum/app/models/todo_model.dart';
import 'package:iMomentum/screens/entries/calendar_bloc.dart';
import 'package:iMomentum/screens/iMeditate/utils/extensions.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/screens/iPomodoro/progress.dart';
import 'package:provider/provider.dart';
import '../../pages_routes.dart';
import 'clock_rest_screen.dart';
import 'clock_begin_screen.dart';
import 'only_thin_ring.dart';

class CompletionScreen extends StatefulWidget {
  CompletionScreen({this.database, this.job});
  final TodoModel job;
  final Database database;

  @override
  _CompletionScreenState createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen> {
  final String _congrats = CongratsList().getCongrats().body;

  final Duration _duration = Duration(minutes: 5);

  final String text = "25 minutes";
  final TextStyle textStyle = GoogleFonts.varelaRound(
      color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20.0);

  void _play() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      PageRoutes.fade(
        () => BreakScreen(
          database: widget.database,
          job: widget.job,
          duration: _duration,
        ),
      ),
    );
  }

  void _clearButton() {
    Navigator.of(context).pushReplacement(PageRoutes.fade(
        () => ClockBeginScreen(
              database: widget.database,
              todo: widget.job,
            ),
        milliseconds: 450));
  }

  Text get getCongrats {
    return Text(_congrats,
        style: TextStyle(
            fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold));
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
                          onPressed: _clearButton,
                          icon: Icon(Icons.clear, size: 30),
                          color: Colors.white,
                        )
                      ],
                    ),
                  ), //clear button
                  Column(
                    children: <Widget>[
                      getCongrats,
                      SizedBox(height: 20),
                      Text(
                        'Your have completed ${_duration.inMinutes / 25} pomodoro task.',
                        style: GoogleFonts.varelaRound(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  SizedBox(
                      height: 36,
                      child: Text(
                        '',
                        style: GoogleFonts.varelaRound(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      )), //title
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      TransparentFlatButton(
//                        color: Colors.transparent,
//                        onPressed: null,
//                        text: '',
//                      ),
//                      TransparentFlatButton(
//                        color: Colors.transparent,
//                        onPressed: null,
//                        text: '',
//                      ),
//                    ],
//                  ), //button or empty row
                  Container(
                    height: size.height / 2,
                    width: size.height / 2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        SizedBox.expand(
                          child: OnlyThinRing(),
                        ),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _duration.clockFmt(),
                                style: GoogleFonts.varelaRound(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 50.0,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Take a break',
                                style: GoogleFonts.varelaRound(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.0),
                              ),
                              SizedBox(height: 10),
                              RoundIconButton(
                                icon: FontAwesomeIcons.play,
                                onPressed: _play,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "See today's progress",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        TransparentFlatButton(
                          text: 'Summary',
                          onPressed: () {
                            Navigator.of(context).push(PageRoutes.slide(
                                () => Provider<CalendarBloc>(
                                    create: (_) =>
                                        CalendarBloc(database: widget.database),
                                    child: ChartsFlutter()),
                                startOffset: Offset(0, 1),
                                milliseconds: 580));
                          },
                        )
                      ],
                    ),
                  ),

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
