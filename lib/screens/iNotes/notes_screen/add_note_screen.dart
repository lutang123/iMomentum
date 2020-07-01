import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/models/note.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({this.database, this.note, this.scrollController});
  final Note note;
  final Database database;
  final ScrollController scrollController;

  @override
  State<StatefulWidget> createState() {
    return AddNoteScreenState();
  }
}

class AddNoteScreenState extends State<AddNoteScreen> {
  bool isEdited = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String title;
  String description;
  DateTime date;

  @override
  void initState() {
//    //'title' can't be used as a setter because it's final.
//    titleController.addListener(() {
//      note.title = titleController.text;
//    });
//    descriptionController.addListener(() {
//      note.description = descriptionController.text;
//    });

    if (widget.note != null) {
      title = widget.note.title;
      description = widget.note.description;
      date = widget.note.date;
    }
    super.initState();
  }

  void _updateTitle() {
    isEdited = true;
    title = titleController.text;
  }

  void _updateDescription() {
    isEdited = true;
    description = descriptionController.text;
  }

//    if (isEdited) {
//      if (note.id != null) {
//        await helper.updateNote(note);
//      } else {
//        note.date = DateTime.now().toIso8601String();
//        await helper.insertNote(note);
//      }
//    }

  /// update & at the same time update _selectedList
  void _set(Database database, Note note) async {
    if (isEdited) {
      if (title != null) {
        try {
          final id = note?.id ?? documentIdFromCurrentDate();

          ///first we find this specific Todo item that we want to update
          final newNote = Note(
              id: id,
              title: title,
              description: description,
              date: DateTime.now());
          //add newTodo to database
          await database.setNote(newNote);
        } on PlatformException catch (e) {
          PlatformExceptionAlertDialog(
            title: 'Operation failed',
            exception: e,
          ).show(context);
        }
      }
    }

    Navigator.pop(context);
  }

  // Save data to database
  void _saveAndNav(Database database) async {
    if (title != null) {
      try {
        final newNote = Note(
            id: documentIdFromCurrentDate(),
            title: title,
            description: description,
            date: DateTime.now());
        //add newNote to database
        await database.setNote(newNote);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
    //if not using bottom modal, this line will take to home screen
    Navigator.of(context).pop();
  }

  ///delete
  Future<void> _delete(Database database, Note note) async {
    try {
      await database.deleteNote(note);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
//    final deleteSnackBar = MySnackBar(
//      text: 'deleted note',
//      actionText: 'undo',
//      onTap: null, //TODO
//    ) as SnackBar;
//    Scaffold.of(context).showSnackBar(deleteSnackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.network(Constants.homePageImage, fit: BoxFit.cover),
        ContainerLinearGradient(),
        Scaffold(
          backgroundColor: Colors.black45.withOpacity(0.8),
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 30,
                ),

                ///if use Navigator.pop(context), it takes me to home screen
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: 25.0),
                    ),
                    onPressed: () => _saveAndNav(widget.database)),
              ]),
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      controller: widget.scrollController,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.only(left: 15.0, right: 15, top: 20),
                            child: TextField(
                              autofocus: true,
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
                                  title = value;
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
                            padding: const EdgeInsets.all(15.0),
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
                                  description = value;
                                }
                              },
                              //what is this
                              onEditingComplete: () {
//                                  _save(widget.database);
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
                  Container(
                    color: Colors.black38,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, top: 15, bottom: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  iconSize: 30,
                                  color: Colors.white,
                                  icon: FaIcon(FontAwesomeIcons.microphoneAlt),
                                  onPressed: () {},
                                  tooltip: 'audio',
                                ),
                                SizedBox(width: 20),
                                IconButton(
                                  iconSize: 30,
                                  color: Colors.white,
                                  icon: FaIcon(FontAwesomeIcons.paintBrush),
                                  onPressed: () {},
                                  tooltip: 'draw',
                                ),
                                SizedBox(width: 20),
                                IconButton(
                                  iconSize: 30,
                                  color: Colors.white,
                                  icon: FaIcon(FontAwesomeIcons.image),
                                  onPressed: () {},
                                  tooltip: 'picture',
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                iconSize: 30,
                                color: Colors.white,
                                icon: FaIcon(FontAwesomeIcons.ellipsisV),
                                onPressed: () {},
                                tooltip: 'more',
                              ),
//                              IconButton(
//                                iconSize: 30,
//                                color: Colors.white,
//                                icon: FaIcon(FontAwesomeIcons.share),
//                                onPressed: () {},
//                                tooltip: 'share',
//                              ),
//                              IconButton(
//                                iconSize: 30,
//                                color: Colors.white,
//                                icon: FaIcon(FontAwesomeIcons.trashAlt),
//                                onPressed: () {
//                                  _delete();
//                                },
//                                tooltip: 'delete',
//                              ),
                            ],
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
      ],
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    //TODO??
//    _save();
    super.dispose();
  }
}
