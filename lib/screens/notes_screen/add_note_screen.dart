import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/format.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/notes_screen/notes_color.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'notes_add_more.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({this.database, this.note});
  final Note note;
  final Database database;
  @override
  State<StatefulWidget> createState() {
    return AddNoteScreenState();
  }
}

class AddNoteScreenState extends State<AddNoteScreen> {
  bool isEdited = false;
  String title = '';
  String description = '';
  DateTime date;
  int color;

  Note get note => widget.note;
  Database get database => widget.database;

  String formattedToday;
  String formattedDate;

  /// Active image file
  File _imageFile;
  final picker = ImagePicker();

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final PickedFile selected = await picker.getImage(source: source);

    setState(() {
      _imageFile = File(selected.path);
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  void initState() {
    if (note != null) {
      title = note.title;
      description = note.description;
      date = note.date;
      color = note.color;
      print(color);
    } else {
      // if note == null
      date = DateTime.now();
      formattedToday = DateFormat("yyyy-MM-dd").format(DateTime.now());
      formattedDate = DateFormat("yyyy-MM-dd").format(date);
      color = 0;
    }

    super.initState();
  }

  ///delete
  Future<void> _deleteAndNav(Database database, Note note) async {
    try {
      await database.deleteNote(note);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
//https://stackoverflow.com/questions/49672706/flutter-navigation-pop-to-index-1
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == 2;
    });
//    Navigator.popUntil(context, ModalRoute.withName(name));
//    final deleteSnackBar = MySnackBar(
//      text: 'deleted note',
//      actionText: 'undo',
//      onTap: null, //TODO
//    ) as SnackBar;
//    Scaffold.of(context).showSnackBar(deleteSnackBar);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Scaffold(
//      backgroundColor: _darkTheme ? darkBkgdColor : lightSurface,
      backgroundColor:
//      note == null
//          ? _darkTheme ? colorsDark[colorApplied] : colorsLight[colorApplied]
//          :

          _darkTheme ? colorsDark[color] : colorsLight[color],

      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: _darkTheme ? darkButton : lightButton,
                size: 30,
              ),
              onPressed: () => _save(database, note),

//              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          actions: <Widget>[
            FlatButton(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Save',
                    style: TextStyle(
                        fontSize: 25.0,
                        color: _darkTheme ? darkButton : lightButton,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () => _save(database, note)),
          ]),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15.0, right: 15, top: 20),
                      child: TextFormField(
                        initialValue: title,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(
                            color: _darkTheme ? darkButton : lightButton,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                        onChanged: (value) {
                          if (value != null) {
                            isEdited = true;
                            title = value;
                          }
                        },
                        cursorColor: _darkTheme ? darkButton : lightButton,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Title',
                          hintStyle: TextStyle(
                              color:
                                  _darkTheme ? Colors.white38 : Colors.black38,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15.0, right: 15, top: 5),
                      child: TextFormField(
                        initialValue: description,
                        autofocus: note == null ? true : false,
                        cursorColor: _darkTheme ? darkButton : lightButton,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(
                          color: _darkTheme ? darkButton : lightButton,
                          fontSize: 18,
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            isEdited = true;
                            description = value;
                          }
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: 'Note',
                          hintStyle: TextStyle(
                              color:
                                  _darkTheme ? Colors.white38 : Colors.black38,
                              fontSize: 18),
                        ),
                      ),
                    ),

                    ///TODO: but can't add to note yet
                    Flexible(
                      child: ListView(
                        children: <Widget>[
                          if (_imageFile != null) ...[
                            Image.file(_imageFile),
                            Row(
                              children: <Widget>[
                                FlatButton(
                                  child: Icon(Icons.crop),
                                  onPressed: _cropImage,
                                ),
                                FlatButton(
                                  child: Icon(Icons.refresh),
                                  onPressed: _clear,
                                ),
                              ],
                            ),
//                            Uploader(file: _imageFile)
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
//                color: _darkTheme ? darkAdd : lightAdd,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15, top: 15, bottom: 10),
                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
//                      IconButton(
//                        iconSize: 28,
//                        color: _darkTheme ? darkButton : lightButton,
//                        icon: FaIcon(FontAwesomeIcons.plusSquare),
//                        onPressed: _addMore,
//                        tooltip: 'Add more',
//                      ),
                      widget.note == null
                          ? Text('Edited ${Format.time(DateTime.now())}')
                          : formattedToday == formattedDate
                              ? Text('Edited ${Format.time(note.date)}')
                              : Text('Edited ${Format.date(note.date)}'),
//                      _simplePopup(),

//                      IconButton(
//                        iconSize: 28,
//                        color: _darkTheme ? darkButton : lightButton,
//                        icon: FaIcon(FontAwesomeIcons.ellipsisV),
//                        onPressed: () =>
//                            _addAction(widget.database, widget.note),
//                        tooltip: 'more',
//                      ),
                    ],
                  ),
                ),
              ),
              ColorPicker(
                selectedIndex: note == null ? 0 : note.color,
                onTap: (index) => _pickColor(index),
              ),

//              Container(
////                color: _darkTheme ? darkAdd : lightAdd,
//                child: Padding(
//                  padding: const EdgeInsets.only(
//                      left: 15.0, right: 15, top: 15, bottom: 30),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      IconButton(
//                        iconSize: 28,
//                        color: _darkTheme ? darkButton : lightButton,
//                        icon: FaIcon(FontAwesomeIcons.plusSquare),
//                        onPressed: _addMore,
//                        tooltip: 'Add more',
//                      ),
//                      widget.note == null
//                          ? Text('Edited ${Format.time(DateTime.now())}')
//                          : formattedToday == formattedDate
//                              ? Text('Edited ${Format.time(note.date)}')
//                              : Text('Edited ${Format.date(note.date)}'),
////                      _simplePopup(),
//
//                      IconButton(
//                        iconSize: 28,
//                        color: _darkTheme ? darkButton : lightButton,
//                        icon: FaIcon(FontAwesomeIcons.ellipsisV),
//                        onPressed: () =>
//                            _addAction(widget.database, widget.note),
//                        tooltip: 'more',
//                      ),
//                    ],
//                  ),
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save(Database database, Note note) async {
    if (isEdited) {
      try {
        final id = note?.id ?? documentIdFromCurrentDate();

        ///first we find this specific Todo item that we want to update
        final newNote = Note(
            id: id,
            title: title,
            description: description,
            color: color,
            date: DateTime.now());
        //add newTodo to database
        await database.setNote(newNote);
        print('newNote.color: ${newNote.color}');
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
    Navigator.pop(context);
  }

  void _addMore() {
    showModalBottomSheet(
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) => NoteAddMore(
              takePhoto: () => _pickImage(ImageSource.camera),
              choosePhoto: () => _pickImage(ImageSource.gallery),
              onTap: (index) => _pickColor(index),
            ));
  }

  void _pickColor(index) {
    setState(() {
      color = index;
    });
//    isEdited = true;
//    note.color = index;
  }

  void _addAction(Database database, Note note) {
    showModalBottomSheet(
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) => NoteAddAction(
              note: note,
              delete: () => _deleteAndNav(database, note),
              send: null,
            ));
  }
}

///FOR POPUP
//  Widget _buildPopUpMenu() {
//    return AppBar(
//      actions: <Widget>[
//        IconButton(
//          onPressed: () {
//            Share.share(
//                'check out my Nots app \n https://github.com/simformsolutions/flutter_note_app');
//          },
//          icon: Icon(Icons.share),
//        ),
//        PopupMenuButton<bool>(
//          onSelected: (res) {
////            bloc.changeTheme(res);
////            _setPref(res);
////            setState(() {
////              if (_themeType == 'Dark Theme') {
////                _themeType = 'Light Theme';
////              } else {
////                _themeType = 'Dark Theme';
////              }
////            });
//          },
//          itemBuilder: (context) {
//            return <PopupMenuEntry<bool>>[
//              PopupMenuItem<bool>(child: Text('hello')
////                value: !widget.darkThemeEnabled,
////                child: Text(_themeType),
//                  )
//            ];
//          },
//        )
//      ],
//      title: Text('Notes'),
//    );
//  }

///notes on popup menu: can't make the position work
//RelativeRect buttonMenuPosition(BuildContext c) {
//    final RenderBox bar = c.findRenderObject();
//    final RenderBox overlay = Overlay.of(c).context.findRenderObject();
//    final RelativeRect position = RelativeRect.fromRect(
//      Rect.fromPoints(
//        bar.localToGlobal(bar.size.bottomRight(Offset.zero), ancestor: overlay),
//        bar.localToGlobal(bar.size.bottomRight(Offset.zero), ancestor: overlay),
//      ),
//      Offset.zero & overlay.size,
//    );
//    return position;
//  }
//
//  Widget _simplePopup() => PopupMenuButton<int>(
//      icon: FaIcon(FontAwesomeIcons.ellipsisV),
//      offset: Offset(0, 50),
//      itemBuilder: (context) => [
//            PopupMenuItem(
//              value: 1,
//              child: Text("Share"),
//            ),
//            PopupMenuItem(
//              value: 2,
//              child: Text("Delete"),
//            ),
//          ],
//      onSelected: (int) {
//        if (int == 2) {
//          _deleteAndNav(database, note);
//        }
//      });
