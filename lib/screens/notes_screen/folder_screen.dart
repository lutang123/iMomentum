import 'dart:async';
import 'package:animations/animations.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/error_message.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/notes_screen/notes_in_folder_screen.dart';
import 'package:iMomentum/screens/notes_screen/search_note.dart';
import 'package:provider/provider.dart';
import 'add_note_screen.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'empty_content.dart';
import 'folder_container.dart';
import 'package:iMomentum/app/utils/cap_string.dart';

class FolderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FolderScreenState();
  }
}

const double _fabDimension = 56.0;

final List<Folder> defaultFolders = [
  Folder(id: 0.toString(), title: 'All Notes'),
  Folder(id: 1.toString(), title: 'Notes'),
];

class FolderScreenState extends State<FolderScreen> {
  bool _addButtonVisible = true;
  ScrollController _hideButtonController;

  TextEditingController searchController = TextEditingController();

  bool isSearchEmpty = true;

//  bool isMobile = true;
//  Device device;

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

  int counter = 0;
  void _onDoubleTap() {
    setState(() {
      ImageUrl.randomImageUrl = '${ImageUrl.randomImageUrlFirstPart}$counter';
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    final randomNotifier = Provider.of<RandomNotifier>(context);
    bool _randomOn = (randomNotifier.getRandom() == true);

    final imageNotifier = Provider.of<ImageNotifier>(context);

//    double deviceHeight = MediaQuery.of(context).size.height;
//    double deviceWidth = MediaQuery.of(context).size.width;
//    isMobile = deviceWidth > deviceHeight ? false : true;
//
//    device = Device(
//        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        BuildPhotoView(
          imageUrl:
              _randomOn ? ImageUrl.randomImageUrl : imageNotifier.getImage(),
        ),
        ContainerLinearGradient(),
        GestureDetector(
          onDoubleTap: _onDoubleTap,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            // appBar: _buildAppBar(), //created another appBar because default one is too high
            body: SafeArea(
              top: false,
              child: Column(
                children: <Widget>[
                  _topRow(), //this is just for the words 'Folders'.
                  // nested StreamBuilder for Note and Folder
                  //this StreamBuilder is only to find out how many notes in a folder
                  StreamBuilder<List<Note>>(
                      stream: database.notesStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final List<Note> allNotes = snapshot.data;
                          if (allNotes.isNotEmpty) {
                            return StreamBuilder<List<Folder>>(
                              stream: database
                                  .foldersStream(), // print(database.todosStream());//Instance of '_MapStream<QuerySnapshot, List<TodoModel>>'
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  //this is a list of folder use has added.
                                  final List<Folder> folders = snapshot.data;
                                  if (folders.isNotEmpty) {
                                    // we always have two default folders on the screen.
                                    final List<Folder> finalFolders =
                                        defaultFolders..addAll(folders);
                                    return Expanded(
                                      child: CustomScrollView(
                                        shrinkWrap: true,
                                        controller: _hideButtonController,
                                        slivers: <Widget>[
                                          _buildBoxAdaptorForSearch(
                                              database, allNotes, finalFolders),
                                          _buildFolderGrid(
                                              database, allNotes, finalFolders),
                                          //filter null views
                                        ],
                                      ),
                                    );
                                  } else {
                                    return _noAddedFolderContent(
                                      database,
                                      allNotes,
                                    );
                                  }
                                } else if (snapshot.hasError) {
                                  return Expanded(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(snapshot.error.toString()),
                                          ErrorMessage(
                                            title: 'Something went wrong',
                                            message:
                                                'Can\'t load items right now, please try again later',
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                            );
                          } else {
                            //this is for if no notes
                            return _noAddedFolderContent(database, allNotes);
                          }
                        } else if (snapshot.hasError) {
                          return Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(snapshot.error.toString()),
                                  ErrorMessage(
                                    title: 'Something went wrong',
                                    message:
                                        'Can\'t load items right now, please try again later',
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                  _bottomRow(database),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _topRow() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Column(
      children: <Widget>[
        SizedBox(
          height: 35,
          child: Container(
            color: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
          ),
        ),
        Container(
          height: 50,
          color: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
          child: Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Row(
              children: [
                Text('Folders',
                    style: TextStyle(
                        color: _darkTheme ? darkThemeButton : lightThemeButton,
                        fontSize: 34,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomRow(Database database) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Visibility(
      visible: _addButtonVisible,
      child: Container(
        decoration: BoxDecoration(
          color: _darkTheme ? darkThemeDrawer : lightThemeAppBar,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: FlatButton.icon(
                icon: Icon(EvaIcons.folderAddOutline,
                    size: 30,
                    color: _darkTheme ? darkThemeButton : lightThemeButton),
                label: Text(
                  'Create Folder',
                  style: TextStyle(
                      fontSize: 18,
                      color: _darkTheme
                          ? darkThemeWords.withOpacity(0.7)
                          : lightThemeWords.withOpacity(0.7)),
                ),
                onPressed: () => _showAddDialog(database),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: OpenContainer(
                useRootNavigator: true,
                transitionType: _transitionType,
                openElevation: 0.0,
                openColor: Colors.transparent,
                openBuilder: (BuildContext context, VoidCallback _) {
                  return AddNoteScreen(database: database);
                },
                closedElevation: 0.0,
                closedColor: Colors.transparent,
                closedShape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: _darkTheme ? darkThemeButton : lightThemeButton,
                      width: 2.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(_fabDimension / 2),
                  ),
                ),
                closedBuilder:
                    (BuildContext context, VoidCallback openContainer) {
                  return SizedBox(
                      height: _fabDimension,
                      width: _fabDimension,
                      child: Center(
                        child: Icon(Icons.add,
                            size: 30,
                            color: _darkTheme
                                ? darkThemeButton
                                : lightThemeButton),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noAddedFolderContent(Database database, List<Note> notes) {
    return Expanded(
      child: CustomScrollView(
        shrinkWrap: true,
        controller: _hideButtonController,
        slivers: <Widget>[
          _buildBoxAdaptorForSearch(database, notes, defaultFolders),
          _buildDefaultFolderGrid(database, notes, defaultFolders),
          SliverToBoxAdapter(
              child: notes.length > 0
                  ? Container()
                  : EmptyContent(text: emptyNoteAndFolder)),
        ],
      ),
    );
  }

  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

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

  //https://medium.com/@lets4r/flutorial-create-a-staggered-gridview-9c881a9b0b98
  int axisCount = 2;

  Widget _buildFolderGrid(
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
          return slidableItem(database, notes, folders, folder);
        },
      ),
    );
  }

  Widget slidableItem(Database database, List<Note> notes, List<Folder> folders,
      Folder folder) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Slidable(
        key: UniqueKey(),
        closeOnScroll: true,
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: openContainerFolder(database, notes, folders, folder),
        actions: <Widget>[
          (folder.id != 0.toString()) && (folder.id != 1.toString())
              ? IconSlideAction(
                  caption: 'Edit',
                  foregroundColor: Colors.lightBlue,
                  color: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
                  icon: EvaIcons.edit2Outline,
                  onTap: () => _showEditDialog(database, folder),
                )
              : null,
        ],
        secondaryActions: <Widget>[
          (folder.id != 0.toString()) && (folder.id != 1.toString())
              ? IconSlideAction(
                  caption: 'Delete',
                  foregroundColor: Colors.red,
                  color: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
                  icon: EvaIcons.trash2Outline,

                  ///add a flush bar and prevent edit on default one
                  onTap: () => _showDeleteDialog(database, folder),
                )
              : null,
        ]);
  }

  Widget openContainerFolder(Database database, List<Note> notes,
      List<Folder> folders, Folder folder) {
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
  Widget _buildDefaultFolderGrid(
      Database database, List<Note> notes, List<Folder> folders) {
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
          return openContainerFolder(database, notes, folders, folder);
        },
        //the vertical space
      ),
    );
  }

  void _showDeleteDialog(Database database, Folder folder) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(top: 10.0),
            backgroundColor: Color(0xf01b262c),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Column(
              children: <Widget>[
                Text("Delete Folder",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    )),
                SizedBox(height: 15),
                Text(
                  'All Notes in this folder will be deleted.',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
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
            backgroundColor: Color(0xf01b262c),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Column(
              children: <Widget>[
                Text("New Folder",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    )),
                SizedBox(height: 15),
                Text(
                  'Enter a name for this folder.',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white60,
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
                        onChanged: (value) {
                          setState(() {
                            value.length == 0
                                ? _isFolderNameEmpty = true
                                : _isFolderNameEmpty = false;
                          });
                        },
                        maxLength: 20,
                        maxLines: 1, //limit only one line
                        initialValue: _newFolderName,
                        validator: (value) => (value.isNotEmpty)
                            ? null
                            : 'Folder name can not be empty',
                        onSaved: (value) {
                          _newFolderName = value.firstCaps;
                        },
                        style: TextStyle(fontSize: 20.0, color: Colors.white70),
                        autofocus: true,
                        cursorColor: Colors.white70,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: darkThemeHint),
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: darkThemeHint,
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              shape: _isFolderNameEmpty
                                  ? RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(68.0),
                                      side: BorderSide(
                                          color: Colors.white70, width: 2.0))
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              shape: _isFolderNameEmpty
                                  ? null
                                  : RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(68.0),
                                      side: BorderSide(
                                          color: Colors.white70, width: 2.0)),
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
            backgroundColor: Color(0xf01b262c),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Column(
              children: <Widget>[
                Text(
                  "Rename Folder",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            content: Container(
//              color: Colors.purpleAccent,
              child: Form(
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
                          onChanged: (value) {
                            setState(() {
                              value.length == 0
                                  ? _isFolderNameEmpty = true
                                  : _isFolderNameEmpty = false;
                            });
                          },
                          maxLines: 1,
                          maxLength: 20,
                          initialValue: folder.title,
                          validator: (value) => (value.isNotEmpty)
                              ? null
                              : 'Folder name can not be empty',
                          onSaved: (value) => _newFolderName = value.firstCaps,
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.white70),
                          autofocus: true,
                          cursorColor: Colors.white70,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: darkThemeHint),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: darkThemeHint)),
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                shape: _isFolderNameEmpty
                                    ? RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(68.0),
                                        side: BorderSide(
                                            color: Colors.white70, width: 2.0))
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                shape: _isFolderNameEmpty
                                    ? null
                                    : RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(68.0),
                                        side: BorderSide(
                                            color: Colors.white70, width: 2.0)),
                                onPressed: () =>
                                    _editFolder(context, database, folder)),
                          ],
                        ),
                      ),
                    ],
                  ),
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
