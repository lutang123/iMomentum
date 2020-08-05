import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';
import 'notes_color.dart';

class NoteAddMore extends StatelessWidget {
  final Note note;
  final Function chooseColor;
  final Function choosePhoto;
  final Function takePhoto;

  const NoteAddMore(
      {Key key, this.note, this.chooseColor, this.choosePhoto, this.takePhoto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return CustomizedBottomSheet(
      color: _darkTheme ? darkAdd : lightAdd,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: FaIcon(FontAwesomeIcons.image),
              title: Text('Choose Photo or Video'),
              onTap: choosePhoto,
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.camera),
              title: Text('Take photo or Video'),
              onTap: takePhoto,
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.microphoneAlt),
              title: Text('Recording'),
            ),
            ColorPicker(
              selectedIndex: note == null ? 0 : note.color,
              onTap: chooseColor,
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}

class NoteAddAction extends StatelessWidget {
  final Note note;
  final Function chooseColor;
  final Function delete;
  final Function send;

  const NoteAddAction(
      {Key key, this.note, this.chooseColor, this.delete, this.send})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return CustomizedBottomSheet(
      color: _darkTheme ? darkAdd : lightAdd,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: FaIcon(FontAwesomeIcons.share),
              title: Text('Send'),
              onTap: send,
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.trashAlt),
              title: Text('Delete'),
              onTap: delete,
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
