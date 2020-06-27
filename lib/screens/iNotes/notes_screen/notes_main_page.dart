import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/screens/iNotes/notes_model/notes_db_helper.dart';
import 'package:iMomentum/screens/iNotes/notes_model/notes_model.dart';
import 'package:iMomentum/screens/iNotes/notes_screen/search_note.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'note_detail.dart';

class Notes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotesState();
  }
}

class NotesState extends State<Notes> {
  NotesDBHelper noteDBHelper = NotesDBHelper();
  List<Note> noteList;
  int count;
  int axisCount = 2;

  @override
  void initState() {
    updateListView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    Widget myAppBar() {
      return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 40,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'My screens.Notes',
          style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          noteList.length == 0
              ? Container()
              : Row(
                  children: <Widget>[
                    IconButton(
                      iconSize: 35,
                      icon: Icon(
                        Icons.search,
                      ),
                      onPressed: () async {
                        final Note result = await showSearch(
                            context: context,
                            delegate: NotesSearch(notes: noteList));
                        if (result != null) {
                          navigateToDetail(result);
                        }
                      },
                    ),
                    IconButton(
                      iconSize: 35,
                      icon: Icon(
                        axisCount == 2 ? Icons.list : Icons.grid_on,
                      ),
                      onPressed: () {
                        setState(() {
                          axisCount = axisCount == 2 ? 4 : 2;
                        });
                      },
                    ),
                  ],
                )
        ],
      );
    }

    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(Constants.homePageImage, fit: BoxFit.cover),
//          Image.asset('images/ocean3.jpg', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black54,
                ],
                stops: [0.5, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.repeated,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: myAppBar(),
            body: noteList.length == 0
                ? Container(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Any thoughts or new ideas? Click on the add button to add a new note!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8, top: 10),
                    child: Container(
                      child: getNotesList(),
                    ),
                  ),

//            floatingActionButton: FloatingActionButton(
//              onPressed: () {
//                navigateToDetail(Note('', '', 0));
//              },
//              tooltip: 'Add Note',
//              shape: CircleBorder(
//                  side: BorderSide(color: Colors.white, width: 2.0)),
//              child: Icon(Icons.add, size: 30, color: Colors.white),
//              backgroundColor: Colors.transparent,
//            ),
          ),
          Stack(
            overflow: Overflow.visible,
            alignment: FractionalOffset(1.0, .9),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: FloatingActionButton(
                  onPressed: () {
                    navigateToDetail(Note('', '', 0));
                  },
                  tooltip: 'Add Note',
                  shape: CircleBorder(
                      side: BorderSide(color: Colors.white, width: 2.0)),
                  child: Icon(Icons.add, size: 30, color: Colors.white),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getNotesList() {
    return StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: count,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onLongPress: () {
          noteDBHelper.deleteNote(noteList[index].id);
          updateListView();
          final deleteSnackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black54,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Removed your notes',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    //Todo, undo action;
                  },
                  child: Text('undo',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                )
              ],
            ),
          );
          Scaffold.of(context).showSnackBar(deleteSnackBar);
        },
        onTap: () {
          navigateToDetail(noteList[index]);
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(width: 2, color: Colors.white),
              borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            children: <Widget>[
              noteList[index].title == null
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            noteList[index].title,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
              noteList[index].description == null
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            noteList[index].description,
                            style: TextStyle(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 10,
                          ),
                        ),
                        //visible: _showAll,
                      ],
                    ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                Text(
                  DateFormat.yMMMd()
                      .format(DateTime.parse(noteList[index].date)),
                  style: TextStyle(color: Colors.white70),
                ),
              ])
            ],
          ),
        ),
      ),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  void navigateToDetail(Note note) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NoteDetail(note)));
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = noteDBHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = noteDBHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          count = noteList.length;
        });
      });
    });
  }
}
