import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/screens/iNotes/notes_model/notes_db_helper.dart';
import 'package:iMomentum/screens/iNotes/notes_model/notes_model.dart';

//0xff02abd4

class NoteDetail extends StatefulWidget {
  NoteDetail(this.note);
  final Note note;

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState();
  }
}

class NoteDetailState extends State<NoteDetail> {
  Note note;
  bool isEdited = false;
  NotesDBHelper helper = NotesDBHelper();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
//
//  @override
//  void initState() {
//    titleController.addListener(() {
//      note.title = titleController.text;
//    });
//    descriptionController.addListener(() {
//      note.description = descriptionController.text;
//    });
//
//    super.initState();
//  }

  void _updateTitle() {
    isEdited = true;
    note.title = titleController.text;
  }

  void _updateDescription() {
    isEdited = true;
    note.description = descriptionController.text;
  }

  void _save() async {
    if (isEdited) {
      if (note.id != null) {
        await helper.updateNote(note);
      } else {
        note.date = DateTime.now().toIso8601String();
        await helper.insertNote(note);
      }
    }
  }

  void _delete() async {
    await helper.deleteNote(note.id);
    Navigator.pop(context, true);
  }

  // Note: Remember to dispose of the TextEditingController when it’s no longer
  // needed. This ensures that you discard any resources used by the object.
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    //TODO??
//    _save();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    note = widget.note;
    titleController.text = note.title;
    descriptionController.text = note.description;

    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset('images/ocean3.jpg', fit: BoxFit.cover),
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
            body: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                _saveAndNav();
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 40,
//                                    color: Color(0xff006994),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                  },
                                  child: Text(
                                    'Done',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0)),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 15.0, right: 15, top: 20),
                                  child: TextField(
//                                    autofocus: true,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    controller: titleController,
                                    maxLength: 100,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                    onChanged: (value) {
                                      if (value != null) {
                                        _updateTitle();
//                                        note.title = value;
                                      }
                                    },
//                                    onEditingComplete: () {
//                                      _save();
//                                    },
                                    cursorColor: Colors.white60,
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Title',
                                      hintStyle: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  child: TextField(
//                                    autofocus: true,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    controller: descriptionController,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                    onChanged: (value) {
                                      if (value != null) {
                                        _updateDescription();
//                                        note.description = value;
                                      }
                                    },
                                    onEditingComplete: () {
                                      _save();
                                    },
                                    cursorColor: Colors.white60,
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Description',
                                      hintStyle: TextStyle(
                                          color: Colors.white60, fontSize: 25),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white10,
//                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, top: 15, bottom: 23),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _delete();
                                },
                                tooltip: 'screens.Notes',
                              ),
                              IconButton(
                                color: Colors.white,
                                icon: FaIcon(FontAwesomeIcons.paintBrush),
                                onPressed: () {},
                                tooltip: 'Pomodoro',
                              ),
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.keyboard_voice),
                                onPressed: () {},
                                tooltip: 'Meditate',
                              ),
                              IconButton(
                                color: Colors.white,
                                icon: FaIcon(FontAwesomeIcons.image),
                                onPressed: () {},
                                tooltip: 'Todo',
                              ),
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.share),
                                onPressed: () {},
                                tooltip: 'Todo',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
//          Align(
//            alignment: Alignment.bottomCenter,
//            child: Padding(
//              padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 25),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  IconButton(
//                    color: Colors.black87,
//                    icon: Icon(Icons.delete),
//                    onPressed: () {
//                      delete();
//                    },
//                    tooltip: 'Notes',
//                  ),
//                  IconButton(
//                    color: Colors.black87,
//                    icon: FaIcon(FontAwesomeIcons.paintBrush),
//                    onPressed: () {},
//                    tooltip: 'Pomodoro',
//                  ),
//                  IconButton(
//                    color: Colors.black87,
//                    icon: Icon(Icons.keyboard_voice),
//                    onPressed: () {},
//                    tooltip: 'Meditate',
//                  ),
//                  IconButton(
//                    color: Colors.black87,
//                    icon: FaIcon(FontAwesomeIcons.image),
//                    onPressed: () {},
//                    tooltip: 'Todo',
//                  ),
//                  IconButton(
//                    color: Colors.black87,
//                    icon: Icon(Icons.share),
//                    onPressed: () {},
//                    tooltip: 'Todo',
//                  ),
//                ],
//              ),
//            ),
//          ),
        ],
      ),
    );

//    return Scaffold(
////      backgroundColor: colors[color],
//      backgroundColor: Colors.white,
//      body: Stack(children: <Widget>[
//        SafeArea(
//          child: Padding(
//            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
//            child: Container(
////              color: colors[color],
//              child: Column(
//                children: <Widget>[
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      InkWell(
//                        onTap: () {
//                          _saveAndNav();
//                        },
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.start,
//                          children: <Widget>[
//                            Icon(Icons.arrow_back_ios,
//                                color: Color(0xff006994)),
//                            Text('screens.Notes',
//                                style: TextStyle(
//                                    color: Color(0xff006994), fontSize: 20))
//                          ],
//                        ),
//                      ),
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.end,
//                        children: <Widget>[
//                          IconButton(
//                            color: Color(0xff006994),
//                            icon: Icon(Icons.share),
//                            onPressed: () {},
//                            tooltip: 'Share',
//                          ),
//                          InkWell(
//                            onTap: () {
//                              _save();
//                              FocusScope.of(context).unfocus();
//                            },
//                            child: Text(
//                              'Done',
//                              style: TextStyle(
//                                color: Color(0xff006994),
//                                fontSize: 20.0,
////                          fontWeight: FontWeight.w700,
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ],
//                  ),
//                  ColorPicker(
//                    selectedIndex: note.color,
//                    onTap: (index) {
//                      setState(() {
//                        color = index;
//                      });
//                      isEdited = true;
//                      note.color = index;
//                    },
//                  ),
//                  Padding(
//                    padding: EdgeInsets.all(10.0),
//                    child: TextField(
//                      controller: titleController,
//                      cursorColor: Colors.black54,
//                      maxLength: 100,
//                      style: TextStyle(
//                          color: Colors.black87,
//                          fontSize: 25,
//                          fontWeight: FontWeight.bold),
//                      onChanged: (value) {
//                        updateTitle();
//                      },
//                      decoration: InputDecoration.collapsed(
//                        hintText: 'Title',
//                        hintStyle: TextStyle(
//                            color: Colors.black87,
//                            fontSize: 25,
//                            fontWeight: FontWeight.bold),
//                      ),
//                    ),
//                  ),
//                  Expanded(
//                    child: Padding(
//                      padding: EdgeInsets.all(10.0),
//                      child: TextField(
//                        autofocus: true,
//                        cursorColor: Colors.black87,
//                        keyboardType: TextInputType.multiline,
//                        maxLines: 20,
//                        controller: descriptionController,
//                        style: TextStyle(color: Colors.black54),
//                        onChanged: (value) {
//                          updateDescription();
//                        },
//                        decoration: InputDecoration.collapsed(
//                          hintText: 'Description',
//                          hintStyle:
//                              TextStyle(color: Colors.black87, fontSize: 20),
//                        ),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ),
//        Align(
//          alignment: Alignment.bottomCenter,
//          child: Padding(
//            padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 25),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                IconButton(
//                  color: Colors.black87,
//                  icon: Icon(Icons.delete),
//                  onPressed: () {
//                    delete();
//                  },
//                  tooltip: 'screens.Notes',
//                ),
//                IconButton(
//                  color: Colors.black87,
//                  icon: FaIcon(FontAwesomeIcons.paintBrush),
//                  onPressed: () {},
//                  tooltip: 'Pomodoro',
//                ),
//                IconButton(
//                  color: Colors.black87,
//                  icon: Icon(Icons.keyboard_voice),
//                  onPressed: () {},
//                  tooltip: 'Meditate',
//                ),
//                IconButton(
//                  color: Colors.black87,
//                  icon: FaIcon(FontAwesomeIcons.image),
//                  onPressed: () {},
//                  tooltip: 'Todo',
//                ),
//                IconButton(
//                  color: Colors.black87,
//                  icon: Icon(Icons.share),
//                  onPressed: () {},
//                  tooltip: 'Todo',
//                ),
//              ],
//            ),
//          ),
//        ),
//      ]),
//    );
  }

  // Save data to database
  void _saveAndNav() async {
    if (isEdited) {
      if (note.id != null) {
        await helper.updateNote(note);
      } else {
        note.date = DateTime.now().toIso8601String();
        await helper.insertNote(note);
      }
    }
    Navigator.pop(context, true);
  }
}
