import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/database.dart';

class BuildNoteContainer extends StatelessWidget {
  BuildNoteContainer({this.note, this.database, this.onTap, this.onLongPress});
  final Note note;
  final Database database;
  final Function onTap;
  final Function onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.black38,
            border: Border.all(width: 1, color: Colors.white54),
            borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: <Widget>[
            note.title == null
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          note.title,
                          style: KNoteTitle,
                        ),
                      ),
                    ],
                  ),
            note.description == null
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
