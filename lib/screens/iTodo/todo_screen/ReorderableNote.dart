import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/database.dart';

class ReorderableNotes extends StatelessWidget {
  ReorderableNotes({this.index, this.notes, this.database, this.onTap});
  final int index;
  final List<Note> notes;
  final Database database;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final Note note = notes[index];
    return GestureDetector(
//      onLongPress: () => _delete(context, note),
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
