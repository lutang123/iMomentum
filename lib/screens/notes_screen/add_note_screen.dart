import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/utils/format.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/utils/package/popup_menu/popup_menu.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/my_global_keys.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/notes_screen/color_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:flutter/widgets.dart';
import 'font_picker.dart';
import 'my_custom_icon.dart';
import 'package:iMomentum/app/utils/extension_firstCaps.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({this.database, this.note, this.folder, this.folders});
  final Database database;
  final Note note;
  final Folder folder;
  final List<Folder> folders;

  @override
  State<StatefulWidget> createState() {
    return AddNoteScreenState();
  }
}

class AddNoteScreenState extends State<AddNoteScreen> {
  bool _isEdited = false;
  //for note properties
  String folderId;
  String title = '';
  String description = '';
  DateTime date;
  int color;
  String fontFamily;
  bool isPinned;
  //must give an initial value
  Icon pinIcon = Icon(MyCustomIcon.pin_outline);

  final FocusNode _node = FocusNode();

  Note get note => widget.note;
  Database get database => widget.database;
  Folder get folder => widget.folder;
  List<Folder> get folders => widget.folders;

  String formattedToday;
  String formattedDate;

  Folder defaultFolder = Folder(id: 1.toString(), title: 'Notes');

  String folderTitle = '';
  String _getFolderTitle(List<Folder> folders) {
    for (Folder folder in folders) {
      if (folder.id == note.folderId) {
        folderTitle = folder.title;
      }
    }
    return folderTitle;
  }

  @override
  void initState() {
    if (note != null) {
      folderId = note.folderId;
      title = note.title;
      description = note.description;
      date = note.date;
      color = note.colorIndex;
      fontFamily = note.fontFamily;
      isPinned = note.isPinned;
    } else {
      // if note == null
      date = DateTime.now();
      formattedToday = DateFormat("yyyy-MM-dd").format(DateTime.now());
      formattedDate = DateFormat("yyyy-MM-dd").format(date);
      color = 0;
      fontFamily = fontList[0];
      isPinned = false;
      //this means we add new notes from folder screen
      if (folder == null) {
        folderId = defaultFolder.id;
        folderTitle = defaultFolder.title;
      } else {
        //this is the case we add note from NotesInFolder screen
        if (folder.id == 0.toString()) {
          folderId = defaultFolder.id;
          folderTitle = defaultFolder.title;
        } else {
          folderTitle = folder.title;
          folderId = folder.id;
        }
      }
    }

    ///we can't assign value here, need to give it an initial value otherwise screen crash
    isPinned
        ? pinIcon = Icon(MyCustomIcon.pin)
        : Icon(MyCustomIcon.pin_outline);
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Scaffold(
      backgroundColor: _darkTheme ? colorsDark[color] : colorsLight[color],
      appBar: _buildAppBar(_darkTheme),
      body: Column(
        children: <Widget>[
          Expanded(
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: <Widget>[
                SliverToBoxAdapter(child: _buildMiddleContent(_darkTheme)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _bottomRow(_darkTheme), // Your footer widget
          ),
        ],
      ),
    );
  }

  void _togglePinned() {
    setState(() {
      isPinned = !isPinned;
      _isEdited = true;
    });
  }

  AppBar _buildAppBar(bool _darkTheme) {
    return AppBar(
      backgroundColor: _darkTheme ? colorsDark[color] : colorsLight[color],
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: _darkTheme ? darkThemeButton : lightThemeButton),
          onPressed: () => _saveAndBack(database, note)),
      titleSpacing: 0.0,
      title: note != null
          ? Text(_getFolderTitle(folders),
              style: Theme.of(context).textTheme.headline6)
          : Text(folderTitle, style: Theme.of(context).textTheme.headline6),
      centerTitle: false,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: _isEdited ? 0.0 : 8.0),
          child: IconButton(
            icon: isPinned
                ? Icon(MyCustomIcon.pin,
                    color: _darkTheme ? darkThemeButton : lightThemeButton)
                : Icon(MyCustomIcon.pin_outline,
                    color: _darkTheme ? darkThemeButton : lightThemeButton),
            onPressed: _togglePinned,
          ),
        ),
        Visibility(
          visible: (_isEdited) ? true : false,
          child: FlatButton(
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(
                  'Done',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: _darkTheme ? darkThemeButton : lightThemeButton,
                      fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () => _saveAndBack(database, note)),
        ),
      ],
    );
  }

  Column _buildMiddleContent(bool _darkTheme) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: textFormFieldTitle(_darkTheme),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
          child: textFormFieldNote(_darkTheme),
        ),
      ],
    );
  }

  TextFormField textFormFieldTitle(bool _darkTheme) {
    return TextFormField(
      initialValue: title,
      focusNode: _node,
      onEditingComplete: () => _node.nextFocus(),
      keyboardType: TextInputType.multiline,
      keyboardAppearance: _darkTheme ? Brightness.dark : Brightness.light,
      maxLines: null,
      // maxLength: 100,
      style: titleStyle(_darkTheme),
      onChanged: (value) {
        if (note == null) {
          if (value.isNotEmpty) {
            setState(() {
              _isEdited = true;
            });
            title = value.firstCaps; //we should add here
          }
        }
        if (note != null) {
          if (value != note.title && value.isNotEmpty) {
            setState(() {
              _isEdited = true;
            });
            title = value.firstCaps; //we should add here
          }
        }
      },
      // onSaved: (value) => title = value.firstCaps,
      cursorColor: _darkTheme ? darkThemeButton : lightThemeButton,
      decoration: InputDecoration.collapsed(
          hintText: 'Title', hintStyle: titleHintStyle(_darkTheme)),
    );
  }

  TextFormField textFormFieldNote(bool _darkTheme) {
    return TextFormField(
      initialValue: description,
      autofocus: note == null ? true : false,
      cursorColor: _darkTheme ? darkThemeButton : lightThemeButton,
      keyboardType: TextInputType.multiline,
      keyboardAppearance: _darkTheme ? Brightness.dark : Brightness.light,
      maxLines: null,
      style: noteStyle(_darkTheme),

      ///moved this into a function onChangedNote, it's not working
      onChanged: (value) {
        if (note == null) {
          if (value.isNotEmpty) {
            setState(() {
              _isEdited = true;
            });
            description = value.firstCaps; //we should add here
          }
        }
        if (note != null) {
          if (value != note.description && value.isNotEmpty) {
            setState(() {
              _isEdited = true;
            });
            description = value.firstCaps; //we should add here
          }
        }
      },
      // onSaved: (value) => description = value.firstCaps,
      decoration: InputDecoration.collapsed(
        hintText: 'Note',
        hintStyle: noteHintStyle(_darkTheme),
      ),
    );
  }

  TextStyle titleHintStyle(bool _darkTheme) {
    return GoogleFonts.getFont(fontFamily,
        color: _darkTheme ? darkThemeHint : lightThemeHint,
        fontSize: 20,
        fontWeight: FontWeight.w600);
  }

  TextStyle titleStyle(bool _darkTheme) {
    return GoogleFonts.getFont(
      fontFamily,
      color: _darkTheme ? darkThemeWords : lightThemeWords,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle noteStyle(bool _darkTheme) {
    return GoogleFonts.getFont(
      fontFamily,
      color: _darkTheme ? darkThemeWords : lightThemeWords,
      fontSize: 18,
    );
  }

  TextStyle noteHintStyle(bool _darkTheme) {
    return GoogleFonts.getFont(
      fontFamily,
      color: _darkTheme ? darkThemeHint : lightThemeHint,
      fontSize: 18,
    );
  }

  TextStyle textStyleEditTime(bool _darkTheme) {
    return TextStyle(color: _darkTheme ? darkThemeHint : lightThemeHint);
  }

  Widget _bottomRow(bool _darkTheme) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
        color: _darkTheme ? colorsDark[color] : colorsLight[color],
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
        child: Column(
          children: [
            visibilityPick(_darkTheme),
            rowBottom(_darkTheme),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Row rowBottom(bool _darkTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          iconSize: 30,
          color: _darkTheme ? darkThemeButton : lightThemeButton,
          icon: _pickerVisible == true
              ? Icon(EvaIcons.closeSquareOutline)
              : Icon(EvaIcons.plusSquareOutline),
          onPressed: _showPicker,
          tooltip: 'Add more',
        ),
        widget.note == null
            ? Text('Edited ${Format.time(DateTime.now())}',
                style: textStyleEditTime(_darkTheme))
            : formattedToday == formattedDate
                ? Text('Edited ${Format.time(note.date)}',
                    style: textStyleEditTime(_darkTheme))
                : Text('Edited ${Format.date(note.date)}',
                    style: textStyleEditTime(_darkTheme)),
        IconButton(
          key: MyGlobalKeys.addNoteKey,
          iconSize: 28,
          color: _darkTheme ? darkThemeButton : lightThemeButton,
          icon: Icon(EvaIcons.moreVerticalOutline),
          onPressed: _showPopUp,
          tooltip: 'more',
        ),
      ],
    );
  }

  Visibility visibilityPick(bool _darkTheme) {
    return Visibility(
      visible: _pickerVisible,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Column(
          children: [
            rowPickTitle(_darkTheme, 'Pick a font for your Note.'),
            FontPicker(
                selectedFont: note == null ? fontList[0] : note.fontFamily,
                onTap: _pickFont,
                backgroundColor:
                    _darkTheme ? colorsDark[color] : colorsLight[color]),
            rowPickTitle(_darkTheme, 'Pick a color for your Note.'),
            ColorPicker(
              selectedIndex: note == null ? 0 : note.colorIndex,
              onTap: _pickColor,
            ),
          ],
        ),
      ),
    );
  }

  Row rowPickTitle(bool _darkTheme, String text) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10),
          child: Text(
            text,
            style: textStyleEditTime(_darkTheme),
          ),
        ),
      ],
    );
  }

  ///this will not work
  void onChangedTitle(value) {}
  void onChangedNote(value) {}

  bool _pickerVisible = false;
  void _showPicker() {
    setState(() {
      _pickerVisible = !_pickerVisible;
    });
  }

  void _pickColor(index) {
    setState(() {
      color = index;
    });
    //add this if statement because we don't want user to save an empty note with only color
    if (note != null && note.colorIndex != color) {
      setState(() {
        _isEdited = true;
      });
    }
  }

  void _pickFont(selectedFont) {
    setState(() {
      fontFamily = selectedFont;
    });
    //add this if statement because we don't want user to save an empty note with only color
    if (note != null && note.fontFamily != fontFamily) {
      setState(() {
        _isEdited = true;
      });
    }
  }

  Future<void> _saveAndBack(Database database, Note note) async {
    if (_isEdited) {
      if ((title.isNotEmpty) || (description.isNotEmpty)) {
        try {
          final id = note?.id ?? documentIdFromCurrentDate();

          ///first we find this specific Todo item that we want to update
          final newNote = Note(
            id: id,
            folderId:
                folderId, //folderId is 1 if added to the default Notes folder
            title: title,
            description: description,
            date: DateTime.now(),
            colorIndex: color,
            fontFamily: fontFamily,
            isPinned: isPinned,
          );
          print('hello note');
          //add newTodo to database
          // print('newNote.folderId in Add Note: ${newNote.folderId}'); //newNote.folderId in Add Note: 2020-09-27T16:07:31.578943
          await database.setNote(newNote);
          print('saved');
        } on PlatformException catch (e) {
          PlatformExceptionAlertDialog(
            title: 'Operation failed',
            exception: e,
          ).show(context);
        }
      }
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _showPopUp() {
    PopupMenu menu = PopupMenu(
      context: context,
      backgroundColor: Colors.teal,
      lineColor: Colors.white54,
      maxColumn: 2,
      items: [
        MenuItem(
            title: 'Delete',
            image: Icon(
              EvaIcons.trash2Outline,
              color: Colors.white,
            )),
        MenuItem(
            title: 'Share',
            image: Icon(
              EvaIcons.shareOutline,
              color: Colors.white,
            )),
      ],
      onClickMenu: onClickMenu,
    );
    menu.show(
      widgetKey: MyGlobalKeys.addNoteKey,
    );
  }

  void onClickMenu(MenuItemProvider item) {
    if (item.menuTitle == 'Delete') {
      _deleteAndNav(database, note);
    } else if (item.menuTitle == 'Share') {
      _share();
    } else {}
  }

  void _share() {
    final RenderBox box = context.findRenderObject();
    if (note == null) {
      if (title.length == 0) {
        Share.share('To title',
            subject: description,
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      }

      if (description.length == 0) {
        Share.share(description,
            subject: 'No description',
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      } else {
        Share.share(title,
            subject: description,
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      }

      ///this is the case note is not null
    } else {
      if (note.title.isEmpty && note.description.isEmpty) {
        return null;
      } else {
        if (note.title.isEmpty) {
          Share.share('No Title',
              subject: note.description,
              sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
        }
        if (note.description.isEmpty) {
          Share.share(note.title,
              subject: 'No description',
              sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
        }
        if (note.title.isNotEmpty && note.description.isNotEmpty) {
          Share.share(note.title,
              subject: note.description,
              sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
        }
      }
    }
  }

  ///delete
  Future<void> _deleteAndNav(Database database, Note note) async {
    if (note != null) {
      try {
        await database.deleteNote(note);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
      Navigator.of(context).pop();
    } else {
      return null;
    }
  }
}

///notes on two level pop up with delete
//https://stackoverflow.com/questions/49672706/flutter-navigation-pop-to-index-1
//    int count = 0;
//    Navigator.popUntil(context, (route) {
//      return count++ == 2;
//    });

///notes on add more function:
//void _addAction(Database database, Note note) {
//  showModalBottomSheet(
//      useRootNavigator: true,
//      backgroundColor: Colors.transparent,
//      context: context,
//      isScrollControlled: true,
//      builder: (context) => NoteAddAction(
//        note: note,
//        delete: () => _deleteAndNav(database, note),
//        send: null,
//      ));
//}
//
//void _addMore(Database database, Note note) {
//  showModalBottomSheet(
//      useRootNavigator: true,
//      backgroundColor: Colors.transparent,
//      context: context,
//      isScrollControlled: true,
//      builder: (context) => NoteAddMore(
//        note: note,
////          delete: () => _deleteAndNav(database, note),
////          send: null,
//      ));
//}
///https://stackoverflow.com/questions/56326005/how-to-use-expanded-in-singlechildscrollview
///notes on LayoutBuilder
//      LayoutBuilder(
//        builder: (context, constraint) {
//          return SingleChildScrollView(
//            child: ConstrainedBox(
//              constraints: BoxConstraints(minHeight: constraint.maxHeight),
//              child: IntrinsicHeight(
//                child: Column(
//                  children: <Widget>[
////                    firstRow(),
//                    Expanded(
//                      child: CustomScrollView(
//                        shrinkWrap: true,
//                        // put AppBar in NestedScrollView to have it sliver off on scrolling
//                        slivers: <Widget>[
//                          _buildBoxAdaptor(),
//                          _buildMiddleContent(),
//                          //filter null views
//                        ],
//                      ),
//                    ),
////                    Expanded(child: middleRow()),
//                    Align(
//                      alignment: Alignment.bottomCenter,
//                      child: lastRow(), // Your footer widget
//                    ),
//                  ],
//                ),
//              ),
//            ),
//          );
//        },
//      ),

///original firsRow
//  Widget firstRow() {
//    final themeNotifier = Provider.of<ThemeNotifier>(context);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//
//    final bool isKeyboardVisible =
//        KeyboardVisibilityProvider.isKeyboardVisible(context);
//
//    return Container(
//      height: 50,
//      color: Colors.transparent,
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.end,
//            children: [
//              Container(
//                key: RIKeys.riKey1,
//                child: RoundSmallIconButton(
//                  icon: EvaIcons.moreHorizotnalOutline,
//                  onPressed: _showPopUp,
//                  color: Colors.white,
//                ),
//              ),
//              Visibility(
//                visible: isKeyboardVisible == false || _isEdited == false
//                    ? false
//                    : true,
//                child: FlatButton(
//                    child: Padding(
//                      padding: const EdgeInsets.only(right: 5.0),
//                      child: Text(
//                        'Done',
//                        style: TextStyle(
//                            fontSize: 20.0,
//                            color: _darkTheme ? darkButton : lightButton,
//                            fontWeight: FontWeight.bold),
//                      ),
//                    ),
//                    onPressed: () => _saveAndBack(database, note)),
//              ),
//            ],
//          )
//        ],
//      ),
//    );
//  }

///note on last row layout:
//  Widget lastRow() {
//    return Column(
//      children: [
//        Padding(
//          padding:
//              const EdgeInsets.only(left: 15.0, right: 15, top: 15, bottom: 10),
//          child: Row(
////                    mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              widget.note == null
//                  ? Text('Edited ${Format.time(DateTime.now())}')
//                  : formattedToday == formattedDate
//                      ? Text('Edited ${Format.time(note.date)}')
//                      : Text('Edited ${Format.date(note.date)}'),
//            ],
//          ),
//        ),
//        Padding(
//          padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 30),
//          child: ColorPicker(
//            selectedIndex: note == null ? 0 : note.colorIndex,
//            onTap: (index) => _pickColor(index),
//          ),
//        ),
//      ],
//    );
//  }
///persistent footer button:
//      bottomNavigationBar: _buildBottomAppBar(context),
//      persistentFooterButtons: <Widget>[
//        widget.note == null
//            ? Text('Edited ${Format.time(DateTime.now())}')
//            : formattedToday == formattedDate
//                ? Text(
//                    'Edited ${Format.time(note.date)}',
//                    style: Theme.of(context).textTheme.subtitle2,
//                  )
//                : Text('Edited ${Format.date(note.date)}',
//                    style: Theme.of(context).textTheme.subtitle2),
//        SizedBox(width: 15),
//        Padding(
//          padding: const EdgeInsets.symmetric(horizontal: 15),
//          child: IconButton(
//            icon: Icon(EvaIcons.plusSquareOutline, size: 30),
//            onPressed: () => _addMore(database, note),
//          ),
//        )
//      ],
///bottom app bar:
//Widget _buildBottomAppBar(BuildContext context) => BottomAppBar(
//  child: Container(
//    height: 56.0, //kBottomBarSize,
//    padding: const EdgeInsets.symmetric(horizontal: 9),
//    child: Row(
//      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//      children: <Widget>[
//        IconButton(
//          icon: const Icon(EvaIcons.plusSquareOutline),
//          color: Color(0xFF5F6368), //kIconTintLight,
//          onPressed: null,
//        ),
//        Text('Edited nbvgbhjnhb'),
//        IconButton(
//          icon: const Icon(Icons.more_vert),
//          color: Color(0xFF5F6368),
//          onPressed: () => _addMore(database, note),
//        ),
//      ],
//    ),
//  ),
//);

///notes on adding image
//  /// Active image file
//  File _imageFile;
//  final picker = ImagePicker();
//
//  /// Cropper plugin
//  Future<void> _cropImage() async {
//    File cropped = await ImageCropper.cropImage(
//      sourcePath: _imageFile.path,
//    );
//
//    setState(() {
//      _imageFile = cropped ?? _imageFile;
//    });
//  }
//
//  /// Select an image via gallery or camera
//  Future<void> _pickImage(ImageSource source) async {
//    final PickedFile selected = await picker.getImage(source: source);
//
//    setState(() {
//      _imageFile = File(selected.path);
//    });
//  }
//
//  /// Remove image
//  void _clear() {
//    setState(() => _imageFile = null);
//  }

///note on additional GoogleKeep-like design

///image
//                    Flexible(
//                      child: ListView(
//                        children: <Widget>[
//                          if (_imageFile != null) ...[
//                            Image.file(_imageFile),
//                            Row(
//                              children: <Widget>[
//                                FlatButton(
//                                  child: Icon(Icons.crop),
//                                  onPressed: _cropImage,
//                                ),
//                                FlatButton(
//                                  child: Icon(Icons.refresh),
//                                  onPressed: _clear,
//                                ),
//                              ],
//                            ),
//                          ]
//                        ],
//                      ),
//                    ),

///FOR POPUP

//          note.title.isEmpty && note.description.isEmpty
//              ? null
//              :
//            // A builder is used to retrieve the context immediately
//            // surrounding the RaisedButton.
//            //
//            // The context's `findRenderObject` returns the first
//            // RenderObject in its descendent tree when it's not
//            // a RenderObjectWidget. The RaisedButton's RenderObject
//            // has its position and size after it's built.
//          () {
//            final RenderBox box = context.findRenderObject();
//            Share.share(note.title,
//                subject: note.description,
//                sharePositionOrigin:
//                box.localToGlobal(Offset.zero) &
//                box.size);
//          };

///
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
