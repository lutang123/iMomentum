import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_round_icon_button.dart';
import 'package:iMomentum/app/common_widgets/my_transparent_flat_button.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/screens/iMeditate/utils/extensions.dart';
import 'package:iMomentum/app/services/database.dart';
import 'clock_timer_screen.dart';
import 'only_thin_ring.dart';
import 'package:iMomentum/pages_routes.dart';

class ClockBeginScreen extends StatefulWidget {
  const ClockBeginScreen({this.database, this.todo});
  final Todo todo;
  final Database database;

  @override
  _ClockBeginScreenState createState() => _ClockBeginScreenState();
}

class _ClockBeginScreenState extends State<ClockBeginScreen> {
  // Keeps track of how much time has elapsed
  Duration _duration = Duration(minutes: 1);
  bool _selected25 = true;
  bool _selected50 = false;

  void _duration25() {
    if (_selected25 != true) {
      setState(() {
        _selected25 = !_selected25;
        _selected50 = !_selected50;
        _duration = Duration(minutes: 1);
      });
    }
  }

  void _duration50() {
    if (_selected50 != true) {
      setState(() {
        _selected50 = !_selected50;
        _selected25 = !_selected25;
        _duration = Duration(minutes: 50);
      });
    }
  }

  void _play() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      PageRoutes.fade(
        () => ClockTimerScreen(
          database: widget.database,
          job: widget.todo,
          duration: _duration,
        ),
      ),
    );
  }

  void _clearButton() {
    Navigator.pop(context);
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
                  ), //clear icon
                  Column(
                    children: <Widget>[
                      Text('Time to focus',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text(
                        'Break your work into intervals',
                        style: GoogleFonts.varelaRound(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 20),
                    ],
                  ), //begin title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TransparentFlatButton(
                        color: _selected25 ? Colors.white : Colors.grey[350],
                        onPressed: _duration25,
                        text: '25 minutes',
                      ),
                      TransparentFlatButton(
                        color: _selected50 ? Colors.white : Colors.grey[350],
                        onPressed: _duration50,
                        text: '50 minutes',
                      ),
                    ],
                  ),
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
                  ), //clock
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
                          '${widget.todo.title}',
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

//  Text get getCongrats {
//    return Text('Congratulations! You have focused '
//        '${_duration.abs().inMinutes.toString()} minutes');
//  }
}
//FaIcon(FontAwesomeIcons.)
