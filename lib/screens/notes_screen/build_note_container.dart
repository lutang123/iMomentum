import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/notes_screen/notes_color.dart';
import 'package:provider/provider.dart';
import 'package:tinycolor/tinycolor.dart';

class BuildNoteContainer extends StatelessWidget {
  BuildNoteContainer({this.note, this.database, this.onTap, this.onLongPress});
  final Note note;
  final Database database;
  final Function onTap;
  final Function onLongPress;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
//            color: _darkTheme ? darkSurfaceTodo : lightSurface,
            color: note.color != null
                ? _darkTheme ? colorsDark[note.color] : colorsLight[note.color]
                : _darkTheme ? colorsDark[0] : colorsLight[0],
            border: Border.all(
                width: 2, color: _darkTheme ? Colors.white54 : Colors.black54),
            borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: <Widget>[
            note.title == null || note.title == ''
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(note.title, style: KNoteTitle),
                      ),
                    ],
                  ),
            note.description == null || note.description == ''
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          note.description,
                          style: KNoteDescription,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 7,
                        ),
                      ),
                      //visible: _showAll,
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

//class MyContainer extends StatelessWidget {
//  const MyContainer({Key key, this.child}) : super(key: key);
//  final Widget child;
//
//  @override
//  Widget build(BuildContext context) {
//
//    return Container(
//      child: child,
//      padding: EdgeInsets.all(8.0),
//      decoration: BoxDecoration(
//          color: _darkTheme ? darkSurfaceTodo : lightSurface,
//          border: Border.all(
//              width: 2, color: _darkTheme ? Colors.white54 : Colors.black54),
//          borderRadius: BorderRadius.circular(10.0)),
//    );
//  }
//}

class MySignInContainer extends StatelessWidget {
  const MySignInContainer({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
      child: child,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: _darkTheme ? darkSurfaceTodo : lightSurface,
          border: Border.all(
              width: 2, color: _darkTheme ? Colors.white54 : Colors.black38),
          borderRadius: BorderRadius.circular(20.0)),
    );
  }
}
