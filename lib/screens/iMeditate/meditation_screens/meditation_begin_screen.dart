import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/models/data/preset_timers.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/screens/iMeditate/widgets/settings_card.dart';
import 'package:iMomentum/app/common_widgets/customized_bottom_sheet.dart';
import 'package:styled_widget/styled_widget.dart';

import 'meditation_screen.dart';

class MeditationBeginScreen extends StatefulWidget {
//  MainScreen({this.startingAnimation = false, Key key}) : super(key: key);
//
//  final bool startingAnimation;
  @override
  _MeditationBeginScreenState createState() => _MeditationBeginScreenState();
}

class _MeditationBeginScreenState extends State<MeditationBeginScreen>
//    with TickerProviderStateMixin
{
  bool _playSounds = true;
  bool _zenMode = false;
  Duration _duration = presetTimers[0];

  @override
  Widget build(BuildContext context) {
    return CustomizedBottomSheet(
      child: Container(
        child: Column(
          mainAxisAlignment: cupertino.MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Just Breathe',
              style: Theme.of(context).textTheme.headline4,
            ),
            cupertino.SizedBox(height: 10),
            SettingsCard(
              start: true,
              title: Text(
                'Duration',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              leading: Icon(Ionicons.ios_hourglass),
              trailing: DropdownButton<Duration>(
                underline: Container(),
                items: presetTimers.map((preset) {
                  return DropdownMenuItem<Duration>(
                    value: preset,
                    child: Text(
                      '${preset.inMinutes} minutes',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                  );
                }).toList(),
                value: _duration,
                onChanged: (value) {
                  setState(() {
//                    Provider.of<MeditationModel>(context, listen: false)
//                        .duration = value;
                    _duration = value;
                  });
                },
              ),
            ),
            SettingsCard(
              title: Text(
                'Play sound',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              leading: Icon(Ionicons.ios_musical_note),
              trailing: cupertino.CupertinoSwitch(
                activeColor: accent,
                onChanged: (value) {
                  setState(() {
                    _playSounds = value;
//                    Provider.of<MeditationModel>(context, listen: false)
//                        .playSounds = value;
                  });
                },
//                value: Provider.of<MeditationModel>(context).playSounds,
                value: _playSounds,
              ),
            ),
            SettingsCard(
              end: true,
              title: Text(
                'Zen mode',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              leading: Icon(Ionicons.ios_heart),
              trailing: cupertino.CupertinoSwitch(
                activeColor: accent,
                onChanged: (bool value) {
                  setState(() {
                    _zenMode = value;
//                    Provider.of<MeditationModel>(context, listen: false)
//                        .isZenMode = value;
                  });
                },
//                value: Provider.of<MeditationModel>(context).isZenMode,
                value: _zenMode,
              ),
            ),
            cupertino.SizedBox(height: 20),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(68.0),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => MeditationScreen(
                    duration: _duration,
                    playSounds: _playSounds,
                    zenMode: _zenMode,
                  ),
                );
              },
              child: Text(
                'BEGIN',
                style: GoogleFonts.varelaRound(
                  color: fgDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                ),
              ).padding(all: 15.0),
            ),
          ],
        ),
      ),
    );
  }
}
