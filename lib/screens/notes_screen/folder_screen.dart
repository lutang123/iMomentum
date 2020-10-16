import 'dart:async';
import 'package:animations/animations.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_sizedbox.dart';
import 'package:iMomentum/app/common_widgets/my_stack_screen.dart';
import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/my_strings.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/notes_screen/notes_in_folder_screen.dart';
import 'package:iMomentum/screens/notes_screen/search_delegate_note.dart';
import 'package:provider/provider.dart';
import 'add_note_screen.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../app/common_widgets/empty_and_error_content.dart';
import 'folder_container.dart';
import 'package:iMomentum/app/utils/extension_firstCaps.dart';

import 'open_container_add_note.dart';

class FolderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FolderScreenState();
  }
}

class FolderScreenState extends State<FolderScreen> {
  bool _addButtonVisible = true;
  ScrollController _hideButtonController;

  TextEditingController searchController = TextEditingController();
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  bool isSearchEmpty = true;

  @override
  void initState() {
    super.initState();
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_addButtonVisible == true) {
          setState(() {
            _addButtonVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_addButtonVisible == false) {
            setState(() {
              _addButtonVisible = true;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _hideButtonController.removeListener(() {});
    _hideButtonController.dispose(); //what's the difference?
    super.dispose();
  }

  List<Note> allNotes = [];
  List<Folder> folders = [];

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return MyStackScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: _buildAppBar(database, _darkTheme),
        body: SafeArea(
          top: false,
          // when remove SafeArea the _botttomRow not show?
          child: Stack(
            alignment: Alignment.bottomCenter,
            //when change Column to Stack, add button not align to bottom, not sure why
            children: <Widget>[
              Column(
                children: [
                  _topRow(database, _darkTheme),
                  // nested StreamBuilder for Note and Folder, this notes StreamBuilder is only to find out how many notes in a folder
                  _buildStreamBuilderNotes(
                      database, _darkTheme), //Expanded CustomScrollView
                ],
              ),
              _bottomRow(database, _darkTheme)
            ],
          ),
        ),
      ),
    );
  }

  Container _topRow(Database database, bool _darkTheme) {
    return Container(
      color: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          MyTopSizedBox(),
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textBaseline: TextBaseline.ideographic,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Folders', style: textStyleFolder(_darkTheme)),
                  InkWell(
                    onTap: _showTipDialog,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Show Tips',
                        style: textStyleShowTip(_darkTheme),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomRow(Database database, bool _darkTheme) {
    return Visibility(
      visible: _addButtonVisible,
      child: Container(
        decoration: BoxDecoration(
          color: _darkTheme ? darkThemeSurface : lightThemeSurface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton.icon(
                label: Text(
                  'Create Folder',
                  style: TextStyle(
                      fontSize: 15,
                      color: _darkTheme ? darkThemeWords : lightThemeWords),
                ),
                icon: Icon(
                  EvaIcons.folderAddOutline,
                  color: _darkTheme ? darkThemeButton : lightThemeButton,
                  size: 33,
                ),
                onPressed: () => _showAddDialog(database),
              ),
              OpenContainerAddNotes(
                context: context,
                openWidget: AddNoteScreen(database: database),
              ),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<Note>> _buildStreamBuilderNotes(
      Database database, bool _darkTheme) {
    return StreamBuilder<List<Note>>(
        stream: database.notesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            allNotes = snapshot.data;
            if (allNotes.isNotEmpty) {
              return _foldersStream(database, allNotes);
            } else {
              //this is for the very beginning, and when no notes,
              // we do not have folder stream too, it's all empty,
              // and once we add folder or add notes, we no longer use this one.
              ///but if notes are empty, we want to show folders too
              return _foldersStream(database, allNotes);
            }
          } else if (snapshot.hasError) {
            print(
                'snapshot.hasError in note stream: ${snapshot.error.toString()}');
            //no access on  allNotes, so we can not use _noAddedFolderContent
            return _notesStreamErrorContent(_darkTheme);
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Expanded _notesStreamErrorContent(bool _darkTheme) {
    // if we don't add Expanded, it will not show in center
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Spacer(),
          EmptyOrError(
            text: '',
            error: Strings.streamErrorMessage,
            // color: _darkTheme ? darkThemeSurface : lightThemeSurface,
          ),
          Spacer(),
        ],
      ),
    ));
  }

  Widget _emptyMessage(String text, bool _darkTheme) {
    //this is after the two default folder, we can not add Expanded
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: EmptyOrError(
        text: text,
      ),
    );
  }

  StreamBuilder<List<Folder>> _foldersStream(
      Database database, List<Note> allNotes) {
    return StreamBuilder<List<Folder>>(
      stream: database
          .foldersStream(), // print(database.todosStream());//Instance of '_MapStream<QuerySnapshot, List<TodoModel>>'
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //this is a list of folder use has added.
          folders = snapshot.data;
          // print('folders.length: ${folders.length}');
          if (folders.isNotEmpty) {
            ///when move this list outside of StreamBuilder as a constant, it keeps showing repeated folders on screen.
            final List<Folder> defaultFolders = [
              Folder(id: 0.toString(), title: 'All Notes'),
              Folder(id: 1.toString(), title: 'Notes'),
            ];
            // we always have two default folders on the screen.
            final List<Folder> finalFolders = defaultFolders..addAll(folders);
            return expandedFolderGrid(database, allNotes, finalFolders);
          }
          //this is for if no added folder, but may have notes
          else {
            return expandedNoAddedFolderContent(
                database, allNotes, Strings.emptyNoteAndFolder);
          }
        } else if (snapshot.hasError) {
          print(
              'snapshot.hasError in folder stream: ${snapshot.error.toString()}');
          //this is for if folder StreamBuilder has error
          return expandedNoAddedFolderContent(
            database,
            allNotes, //text
            Strings.streamErrorMessage, //tips
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Expanded expandedFolderGrid(
      Database database, List<Note> allNotes, List<Folder> finalFolders) {
    return Expanded(
      child: CustomScrollView(
        shrinkWrap: true,
        controller: _hideButtonController,
        slivers: <Widget>[
          _buildBoxAdaptorForSearch(database, allNotes, finalFolders),
          _buildFolderGrid(database, allNotes, finalFolders),
          //filter null views
        ],
      ),
    );
  }

  Expanded expandedNoAddedFolderContent(
      Database database, List<Note> notes, String text) {
    final List<Folder> defaultFolders = [
      Folder(id: 0.toString(), title: 'All Notes'),
      Folder(id: 1.toString(), title: 'Notes'),
    ];
    return Expanded(
      child: CustomScrollView(
        shrinkWrap: true,
        controller: _hideButtonController,
        slivers: <Widget>[
          _buildBoxAdaptorForSearch(database, notes, defaultFolders),
          _buildDefaultFolderGrid(database, notes, defaultFolders),
          _noAddedFolderOrNotesMessage(notes, text),
        ],
      ),
    );
  }

  SliverToBoxAdapter _noAddedFolderOrNotesMessage(
      List<Note> notes, String text) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SliverToBoxAdapter(
        child:
            // notes.isNotEmpty
            //     ? Container()
            //     :
            _emptyMessage(text, _darkTheme));
  }

  Widget _buildBoxAdaptorForSearch(
      Database database, List<Note> allNotes, List<Folder> folders) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 40.0, right: 40, top: 20, bottom: 10),
        child: NoteSearchBar(
          onPressed: () => showSearch(
            context: context,
            delegate: SearchNote(
                database: database, notes: allNotes, folders: folders),
          ),
        ),
      ),
    );
  }

  //https://medium.com/@lets4r/flutorial-create-a-staggered-gridview-9c881a9b0b98
  int axisCount = 2;
  SliverPadding _buildFolderGrid(
      Database database, List<Note> notes, List<Folder> folders) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      sliver: SliverStaggeredGrid.countBuilder(
        // set column count
        crossAxisCount:
            4, //set 2 if using StaggeredTile.extent(1, aspectRatio * columnWidth);
        staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 10.0,
        itemCount: folders.length, //this includes default folders
        // set itemBuilder
        ///_showEditDialog and _showDeleteDialog all get context from here
        itemBuilder: (BuildContext context, int index) {
          final folder = folders[index];
          return _slidableItem(database, notes, folders, folder);
        },
      ),
    );
  }

  Slidable _slidableItem(Database database, List<Note> notes,
      List<Folder> folders, Folder folder) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Slidable(
        key: UniqueKey(),
        closeOnScroll: true,
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: _openContainerFolder(database, notes, folders, folder),
        actions: <Widget>[
          (folder.id != 0.toString()) && (folder.id != 1.toString())
              ? IconSlideAction(
                  caption: 'Edit',
                  foregroundColor:
                      _darkTheme ? Colors.lightBlueAccent : Colors.blue,
                  color: _darkTheme ? darkThemeDrawer : lightThemeDrawer,
                  icon: EvaIcons.edit2Outline,
                  onTap: () => _showEditDialog(database, folder),
                )
              : null,
        ],
        secondaryActions: <Widget>[
          (folder.id != 0.toString()) && (folder.id != 1.toString())
              ? IconSlideAction(
                  caption: 'Delete',
                  foregroundColor: _darkTheme ? Colors.redAccent : Colors.red,
                  color: _darkTheme ? darkThemeDrawer : lightThemeDrawer,
                  icon: EvaIcons.trash2Outline,

                  ///add a flush bar and prevent edit on default one
                  onTap: () => _showDeleteDialog(database, folder),
                )
              : null,
        ]);
  }

  OpenContainer<Object> _openContainerFolder(Database database,
      List<Note> notes, List<Folder> folders, Folder folder) {
    return OpenContainer(
      transitionType: _transitionType,
      closedElevation: 0,
      closedColor: Colors.transparent,
      closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))),
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return FolderContainer(
          folder: folder,
          notesNumber: _getNotesNumber(notes, folder),
        );
      },
      openElevation: 0,
      openColor: Colors.transparent,
      openBuilder: (BuildContext context, VoidCallback _) {
        return NotesInFolderScreen(
            database: database, folder: folder, folders: folders);
      },
    );
  }

  // with default folder
  SliverPadding _buildDefaultFolderGrid(
      Database database, List<Note> notes, List<Folder> folders) {
    final List<Folder> defaultFolders = [
      Folder(id: 0.toString(), title: 'All Notes'),
      Folder(id: 1.toString(), title: 'Notes'),
    ];
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      sliver: SliverStaggeredGrid.countBuilder(
        crossAxisCount: 4,
        staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 10.0,
        itemCount: defaultFolders.length,
        itemBuilder: (BuildContext context, int index) {
          final folder = defaultFolders[index];
          return _openContainerFolder(database, notes, folders, folder);
        },
        //the vertical space
      ),
    );
  }

  TextStyle textStyleShowTip(bool _darkTheme) {
    return TextStyle(
        fontSize: 15, color: _darkTheme ? darkThemeWords : lightThemeButton);
  }

  TextStyle textStyleFolder(bool _darkTheme) {
    return TextStyle(
        color: _darkTheme ? darkThemeWords : lightThemeWords,
        fontSize: 33,
        fontWeight: FontWeight.w600);
  }

  Future<void> _showTipDialog() async {
    await PlatformAlertDialog(
      title: 'Tips',
      content: Strings.tipsOnFolderScreen,
      defaultActionText: 'OK.',
    ).show(context);
  }

  TextStyle textStyleCreateFolder(bool _darkTheme) {
    return TextStyle(
        fontSize: 16,
        color: _darkTheme
            ? darkThemeWords.withOpacity(0.7)
            : lightThemeWords.withOpacity(0.7));
  }

  int _getNotesNumber(List<Note> allNotes, Folder folder) {
    ///when write List<Note> notesList; get error saying .add is wrong,
    ///must give an initial value
    List<Note> notesList = [];

    if (allNotes.isNotEmpty) {
      if (folder.id == 0.toString()) {
        return allNotes.length; //return all notes
      } else {
        for (Note note in allNotes) {
          if (note.folderId == folder.id) {
            notesList.add(note);
          }
        }
        return notesList.length;
      }
    }
    return 0;
  }

  ///todo: refactor dialog
  void _showDeleteDialog(Database database, Folder folder) async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(top: 10.0),
            backgroundColor:
                _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Column(
              children: <Widget>[
                Text("Delete Folder",
                    style: TextStyle(
                      fontSize: 20,
                      color: _darkTheme ? darkThemeWords : lightThemeWords,
                    )),
                SizedBox(height: 15),
                Text(
                  'All Notes in this folder will be deleted.',
                  style: TextStyle(
                      fontSize: 16,
                      color: _darkTheme ? darkThemeHint : lightThemeHint,
                      fontStyle: FontStyle.italic),
                )
              ],
            ),
            content: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
//                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.lightBlue),
                                ),
                                onPressed: () => Navigator.of(context).pop()),
                            FlatButton(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.red),
                                ),
                                onPressed: () =>
                                    _deleteFolder(context, database, folder)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
//            actions: <Widget>[],
          );
        });
      },
    );
  }

  ///delete
  ///When removing BuildContext context, it goes back to black screen after delete.
  Future<void> _deleteFolder(
      BuildContext context, Database database, Folder folder) async {
    try {
      Navigator.pop(context);
      await database.deleteFolder(folder);
      print('deleted folder: ${folder.title}');
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  String _newFolderName = '';
  bool _isFolderNameEmpty = true;

  final _formKey = GlobalKey<FormState>();

  //because in add button, we can't access notes unless we move steamBuilder up,
  // so I make add and edit separate, lots of repeated code
  //https://stackoverflow.com/questions/50964365/alert-dialog-with-rounded-corners-in-flutter/50966702#50966702
  void _showAddDialog(Database database) async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    setState(() {
      _addButtonVisible = false;
    });
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext _) {
        ///this StatefulBuilder has a context that can be used in addFolder and cancel
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(top: 10.0),
            backgroundColor:
                _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Column(
              children: <Widget>[
                Text("New Folder",
                    style: TextStyle(
                      fontSize: 20,
                      color: _darkTheme ? darkThemeWords : lightThemeWords,
                    )),
                SizedBox(height: 15),
                Text(
                  'Enter a name for this folder.',
                  style: TextStyle(
                      fontSize: 16,
                      color: _darkTheme ? darkThemeHint : lightThemeHint,
                      fontStyle: FontStyle.italic),
//                  style: Theme.of(context).textTheme.subtitle2,
                )
              ],
            ),
            content: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        keyboardAppearance:
                            _darkTheme ? Brightness.dark : Brightness.light,
                        onChanged: (value) {
                          setState(() {
                            value.length == 0
                                ? _isFolderNameEmpty = true
                                : _isFolderNameEmpty = false;
                          });
                        },
                        maxLength: 15,
                        maxLines: 1, //limit only one line
                        initialValue: _newFolderName,
                        validator: (value) => (value.isNotEmpty)
                            ? null
                            : 'Folder name can not be empty',
                        onSaved: (value) {
                          _newFolderName = value.firstCaps;
                        },
                        style: TextStyle(
                            fontSize: 20.0,
                            color:
                                _darkTheme ? darkThemeWords : lightThemeWords),
                        autofocus: true,
                        cursorColor:
                            _darkTheme ? darkThemeHint2 : lightThemeHint2,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: _darkTheme
                                    ? darkThemeHint
                                    : lightThemeHint),
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: _darkTheme ? darkThemeHint : lightThemeHint,
                          )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.varelaRound(
                                  fontSize: 18,
                                  color: _darkTheme
                                      ? darkThemeWords
                                      : lightThemeWords,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              shape: _isFolderNameEmpty
                                  ? RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(68.0),
                                      side: BorderSide(
                                          color: _darkTheme
                                              ? darkThemeHint
                                              : lightThemeHint,
                                          width: 1.0))
                                  : null,
                              onPressed: () {
                                setState(() {
                                  _addButtonVisible = true;
                                });
                                Navigator.of(context).pop();
                              }),
                          FlatButton(
                              child: Text(
                                'Save',
                                style: GoogleFonts.varelaRound(
                                  fontSize: 18,
                                  color: _darkTheme
                                      ? darkThemeWords
                                      : lightThemeWords,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              shape: _isFolderNameEmpty
                                  ? null
                                  : RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(68.0),
                                      side: BorderSide(
                                          color: _darkTheme
                                              ? darkThemeHint
                                              : lightThemeHint,
                                          width: 1.0)),
                              onPressed: () => _addFolder(context, database)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
//            actions: <Widget>[],
          );
        });
      },
    );
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    //validate
    if (form.validate()) {
      //save
      form.save();
      return true;
    }
    return false;
  }

  /// only allow unique name for folder, and can not be notes or all notes
  ///when we don't have BuildContext context, we used a wrong context and it
  ///popped to black screen
  void _addFolder(BuildContext context, Database database) async {
    if (_validateAndSaveForm()) {
      try {
        final folders = await database.foldersStream().first;
        final allNames =
            folders.map((folder) => folder.title.toLowerCase()).toList();
//        print('allNames: $allNames');
        //and this is to make sure when we edit job, we can keep the name
//        if (folder != null) {
//          allNames.remove(widget.job.name);
//        }
        //this is to make sure when we create job, we do not write the same name
        if (allNames.contains(_newFolderName.toLowerCase())) {
          PlatformAlertDialog(
            title: 'Name already used',
            content: 'Please choose a different folder name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          final newFolder = Folder(
            id: documentIdFromCurrentDate(),
            title: _newFolderName,
          );
          // pop
          Navigator.of(context).pop();
          //add newTodo to database
          await database.setFolder(newFolder);
          setState(() {
            _addButtonVisible = true;
          });
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  //The reason not to put the add and edit together is because in add button, no access to folder.
  void _showEditDialog(Database database, Folder folder) async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    setState(() {
      _addButtonVisible = false;
    });
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext _) {
        ///cancel and edit function all used this context
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(top: 10.0),
            backgroundColor:
                _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Column(
              children: <Widget>[
                Text(
                  "Rename Folder",
                  style: TextStyle(
                      fontSize: 20,
                      color: _darkTheme ? darkThemeWords : lightThemeWords),
                ),
              ],
            ),
            content: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        keyboardAppearance:
                            _darkTheme ? Brightness.dark : Brightness.light,
                        onChanged: (value) {
                          setState(() {
                            value.length == 0
                                ? _isFolderNameEmpty = true
                                : _isFolderNameEmpty = false;
                          });
                        },
                        maxLines: 1,
                        maxLength: 15,
                        initialValue: folder.title,
                        validator: (value) => (value.isNotEmpty)
                            ? null
                            : 'Folder name can not be empty',
                        onSaved: (value) => _newFolderName = value.firstCaps,
                        style: TextStyle(
                            fontSize: 20.0,
                            color:
                                _darkTheme ? darkThemeWords : lightThemeWords),
                        autofocus: true,
                        cursorColor:
                            _darkTheme ? darkThemeHint2 : lightThemeHint2,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: _darkTheme
                                    ? darkThemeHint
                                    : lightThemeHint),
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: _darkTheme
                                      ? darkThemeHint
                                      : lightThemeHint)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.varelaRound(
                                  fontSize: 18,
                                  color: _darkTheme
                                      ? darkThemeWords
                                      : lightThemeWords,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              shape: _isFolderNameEmpty
                                  ? RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(68.0),
                                      side: BorderSide(
                                          color: _darkTheme
                                              ? darkThemeHint2
                                              : lightThemeHint2,
                                          width: 2.0))
                                  : null,
                              onPressed: () {
                                setState(() {
                                  _addButtonVisible = true;
                                });
                                Navigator.of(context).pop();
                              }),
                          FlatButton(
                              child: Text(
                                'Save',
                                style: GoogleFonts.varelaRound(
                                  fontSize: 18,
                                  color: _darkTheme
                                      ? darkThemeWords
                                      : lightThemeWords,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              shape: _isFolderNameEmpty
                                  ? null
                                  : RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(68.0),
                                      side: BorderSide(
                                          color: _darkTheme
                                              ? darkThemeHint2
                                              : lightThemeHint2,
                                          width: 1.0)),
                              onPressed: () =>
                                  _editFolder(context, database, folder)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _editFolder(
      BuildContext context, Database database, Folder folder) async {
    if (_validateAndSaveForm()) {
      try {
        final folders = await database.foldersStream().first;
        final allNames =
            folders.map((folder) => folder.title.toLowerCase()).toList();
        //and this is to make sure when we edit job, we can keep the name
        if (folder != null) {
          allNames.remove(folder.title);
        }
        //this is to make sure when we create job, we do not write the same name
        if (allNames.contains(_newFolderName.toLowerCase())) {
          PlatformAlertDialog(
            title: 'Name already used',
            content: 'Please choose a different folder name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          ///first we find this specific Todo item that we want to update
          final id = folder?.id ?? documentIdFromCurrentDate();
          final newFolder = Folder(
            id: id,
            title: _newFolderName,
          );
          await database.setFolder(newFolder);
          setState(() {
            _addButtonVisible = true;
          });
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }
}

///original, build appbar
///created another appBar because default one is too high
/// if using default appBar, can't make two words align together
//   AppBar _buildAppBar(Database database, bool _darkTheme) {
//     return AppBar(
//       elevation: 0.0,
//       backgroundColor: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
//       automaticallyImplyLeading: false,
//       title: Padding(
//         padding: const EdgeInsets.only(left: 15.0),
//         child: Text('Folders', style: textStyleFolder(_darkTheme)),
//       ),
//       titleSpacing: 0.0,
//       centerTitle: false,
//       actions: [
//         InkWell(
//           onTap: _showTipDialog,
//           child: Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: Text(
//               'Show Tips',
//               style: textStyleShowTip(_darkTheme),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
