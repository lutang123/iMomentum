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
import 'package:iMomentum/app/common_widgets/empty_content.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/notes_screen/notes_in_folder_screen.dart';
import 'package:provider/provider.dart';
import 'add_note_screen.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'notes_folder_container.dart';
import 'package:iMomentum/app/utils/cap_string.dart';

class FolderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FolderScreenState();
  }
}

const double _fabDimension = 56.0;

class FolderScreenState extends State<FolderScreen> {
  bool _addButtonVisible = true;
  ScrollController _hideButtonController;

//  // for folder
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
      ImageUrl.randomImageUrl =
          'https://source.unsplash.com/random?nature/$counter';
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
//    print(AppBar().preferredSize.height); //56
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
            appBar: _buildAppBar(),
            body: SafeArea(
              top: false,
              child: Column(
                children: <Widget>[
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
                                  final List<Folder> folders = snapshot.data;
                                  if (folders.isNotEmpty) {
                                    final List<Folder> defaultFolders = [
                                      Folder(
                                          id: 0.toString(), title: 'All Notes'),
                                      Folder(id: 1.toString(), title: 'Notes'),
                                    ];
                                    final List<Folder> finalFolders =
                                        defaultFolders..addAll(folders);
                                    //this StreamBuilder is only to find out how many notes in a folder
                                    return Expanded(
                                      child: CustomScrollView(
                                        shrinkWrap: true,
                                        controller: _hideButtonController,
                                        // put AppBar in NestedScrollView to have it sliver off on scrolling
                                        slivers: <Widget>[
                                          _buildBoxAdaptorForSearch(allNotes),
                                          _buildFolderGrid(
                                              database, allNotes, finalFolders),
                                          //filter null views
                                        ],
                                      ),
                                    );
                                  } else {
                                    return _noAddedFolderContent(
                                        database, allNotes);
                                  }
                                } else if (snapshot.hasError) {
                                  return Expanded(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(snapshot.error.toString()),
                                          EmptyMessage(
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
                                  EmptyMessage(
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

  Widget _buildAppBar() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return AppBar(
      centerTitle: false,
      elevation: 0,
      backgroundColor: _darkTheme ? darkThemeAppBar : lightThemeSurface,
      automaticallyImplyLeading: false,
      titleSpacing: 0.0,
      title: Padding(
        padding: const EdgeInsets.only(left: 40.0),
        child: Text('Folders',
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _bottomRow(Database database) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Visibility(
      visible: _addButtonVisible,
      child: Container(
        decoration: BoxDecoration(
          color: _darkTheme ? Colors.black12 : lightThemeSurface,
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
                icon: Icon(
//                                FontAwesomeIcons.folder,
                  EvaIcons.folderAddOutline,
                  size: 30,
                ),
                label: Text(
                  'Add Folder',
                  style: TextStyle(fontSize: 18),
//                                  style: Theme.of(context).textTheme.headline6,
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
                closedElevation: 6.0,
                closedColor: Colors.transparent,
                closedShape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 2.0),
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
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.white,
                        ),
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
        // put AppBar in NestedScrollView to have it sliver off on scrolling
        slivers: <Widget>[
          _buildBoxAdaptorForSearch(notes),
          _buildEmptyFolderGrid(database, notes),
        ],
      ),
    );
  }

  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  Widget _buildBoxAdaptorForSearch(List<Note> allNotes) {
    return SliverToBoxAdapter(
      child: allNotes.length == 0
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40, top: 20, bottom: 10),
              child: NoteSearchBar(onPressed: null),
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
    ///move default to steam builder list
//    List defaultFolders = [
//      Folder(id: 0.toString(), title: 'All Notes'),
//      Folder(id: 1.toString(), title: 'Notes'),
//    ];
//
//    List finalFolderList = defaultFolders..addAll(folders);
//    int columnCount = orientation == Orientation.portrait ? 2 : 3;
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
        itemBuilder: (BuildContext context, int index) {
          final folder = folders[index];
          return Slidable(
              key: UniqueKey(),
              closeOnScroll: true,
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: OpenContainer(
                transitionType: _transitionType,
                closedElevation: 0,
                closedColor: Colors.transparent,
                closedShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0))),
                closedBuilder: (BuildContext _, VoidCallback openContainer) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      NotesFolderContainer(
                        folder: folder,
                        notesNumber: _getNotesNumber(notes, folder),
                      ),

                      ///not looking good
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: [
//                        IconButton(
//                            icon: Icon(EvaIcons.edit2Outline),
//                            onPressed: () =>
//                                _showEditDialog(context, database, folder)),
//                        IconButton(
//                            icon: Icon(EvaIcons.trash2Outline),
//                            onPressed: () => _showFlushBar(context, folder))
//                      ],
//                    )
                    ],
                  );
                },
                openElevation: 0,
                openColor: Colors.transparent,
                openBuilder: (BuildContext context, VoidCallback _) {
                  return NotesInFolderScreen(
                      database: database, folder: folder, folders: folders);
                },
              ),
              actions: <Widget>[
                (folder.id != 0.toString()) && (folder.id != 1.toString())
                    ? IconSlideAction(
                        caption: 'Edit',
                        foregroundColor: Colors.lightBlue,
                        color: Colors.black45,
                        icon: EvaIcons.edit2Outline,
                        onTap: () => _showEditDialog(context, database, folder),
                      )
                    : null,
              ],
              secondaryActions: <Widget>[
                (folder.id != 0.toString()) && (folder.id != 1.toString())
                    ? IconSlideAction(
                        caption: 'Delete',
                        foregroundColor: Colors.red,
                        color: Colors.black45,
                        icon: EvaIcons.trash2Outline,

                        ///add a flush bar and prevent edit on default one
                        onTap: () =>
                            _showDeleteDialog(context, database, folder),
                      )
                    : null,
              ]);
        },
      ),
    );
  }

  // with default folder
  Widget _buildEmptyFolderGrid(Database database, List<Note> notes) {
    List defaultFolders = [
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
          return OpenContainer(
            transitionType: _transitionType,
            closedBuilder: (BuildContext _, VoidCallback openContainer) {
              return NotesFolderContainer(
                folder: folder,
                notesNumber: _getNotesNumber(notes, folder),
//                onTap: () => _gotoNotesInFolder(database,
//                    folder),
              );
            },
            closedElevation: 0,
            openElevation: 0,
            closedColor: Colors.transparent,
            closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            openColor: Colors.transparent,
            openBuilder: (BuildContext context, VoidCallback _) {
              return NotesInFolderScreen(database: database, folder: folder);
            },
          );
        },
        //the vertical space
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, Database database, Folder folder) async {
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
                                      _delete(context, database, folder)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
  Future<void> _delete(
      BuildContext context, Database database, Folder folder) async {
    ///so this database here needs to be passed and context needs to BuildContext
//    final database = Provider.of<Database>(context, listen: false);
    try {
      await database.deleteFolder(folder);
      Navigator.pop(context);
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
//    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    setState(() {
      _addButtonVisible = false;
    });
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(top: 10.0),
            backgroundColor: Color(0xf01b262c),
            // //
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
                      color: Colors.white,
                      fontStyle: FontStyle.italic),
//                  style: Theme.of(context).textTheme.subtitle2,
                )
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
                      Container(
//                      color: Colors.red,
                        child: Padding(
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
                            onSaved: (value) => _newFolderName = value,
                            style: TextStyle(fontSize: 20.0),
                            autofocus: true,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              )),
                            ),
                          ),
                        ),
                      ),
                      Container(
//                      color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ///Todo: change color when typing
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
                                              color: Colors.white70,
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
                                              color: Colors.white70,
                                              width: 2.0)),
                                  onPressed: () =>
                                      _addFolder(context, database)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
//            actions: <Widget>[],
          );
        });
      },
    );
  }

  /// only allow unique name for folder, and can not be notes or all notes
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

  //when we don't have BuildContext context, we used a wrong context and it popped to black screen
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
            title: _newFolderName.firstCaps,
          );
          //add newTodo to database
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

  //The reason not to put the add and edit together is because in add button, no access to folder.
  void _showEditDialog(
      BuildContext context, Database database, Folder folder) async {
//    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    setState(() {
      _addButtonVisible = false;
    });
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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
                      Container(
//                      color: Colors.red,
                        child: Padding(
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
                            onSaved: (value) => _newFolderName = value,
                            style: TextStyle(fontSize: 20.0),
                            autofocus: true,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              )),
                            ),
                          ),
                        ),
                      ),
                      Container(
//                      color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ///Todo: change color when typing
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
                                              color: Colors.white70,
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
                                              color: Colors.white70,
                                              width: 2.0)),
                                  onPressed: () =>
                                      _editFolder(context, database, folder)),
                            ],
                          ),
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
            title: _newFolderName.firstCaps,
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

/// spent a lot of time on Sliver App Bar but the space is too big or too small,
/// later learnt that I should use SliverToBoxAdapter
//  Widget _buildSearchAppBar() {
//    final themeNotifier = Provider.of<ThemeNotifier>(context);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//    return SliverPadding(
//      padding: const EdgeInsets.only(top: 0.0),
//      sliver: SliverAppBar(
//        backgroundColor: Colors.transparent,
////        backgroundColor: _darkTheme ? Colors.black38 : lightSurface,
//        titleSpacing: 0,
//        elevation: 0,
//        centerTitle: true,
//        snap: true,
//        toolbarHeight: 100,
//        automaticallyImplyLeading: false,
//        stretch: false,
//        floating: true,
////        bottom: PreferredSize(
////          // Add this code
////          preferredSize: Size.fromHeight(0.0), // Add this code
////          child: Text(''), // Add this code
////        ), // Add this code
////          flexibleSpace: /title
//        title: Column(
//          children: [
////              Container(
//////                height: 80,
////                child: Row(
////                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
////                  children: <Widget>[
////                    Padding(
////                      padding: const EdgeInsets.only(left: 25.0),
////                      child: Text('Folders',
////                          style: Theme.of(context).textTheme.headline4),
////                    ),
////                    FlatButton(
////                        onPressed: () => _showEditDialog(context),
////                        child: Text('Edit'))
////                  ],
////                ),
////              ),
//            Padding(
//              padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 0),
//              child: Container(
//                  decoration: BoxDecoration(
//                      color: _darkTheme ? Colors.black38 : lightSurface,
//                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                  child: Row(
//                    children: <Widget>[
//                      FlatButton.icon(
//                          onPressed: null,
//                          icon: Icon(
//                            Icons.search,
//                            color: Colors.white70,
//                          ),
//                          label: Text(
//                            'Search your notes',
//                            style: TextStyle(color: Colors.white70),
//                          ))
//                    ],
//                  )),
//            ),
//          ],
//        ),
//      ),
//    );
//  }

///the original StaggeredGridView.countBuilder
//  Widget getDefaultFolderList(Database database) {
//    List defaultFolders = [
//      Folder(id: 0.toString(), title: 'All Notes', colorCode: '4278238420'),
//      Folder(id: 1.toString(), title: 'Notes', colorCode: '4278228616'),
//    ];
//
//    return StaggeredGridView.countBuilder(
//        controller: _hideButtonController,
//        staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
//        mainAxisSpacing: 8.0,
//        crossAxisSpacing: 8.0,
//        physics: BouncingScrollPhysics(),
//        crossAxisCount: 4,
//        itemCount: defaultFolders.length,
//        shrinkWrap: true,
//        itemBuilder: (BuildContext context, int index) {
//          final folder = defaultFolders[index];
//          return Slidable(
////            controller: slidableController,
//            key: UniqueKey(),
//            closeOnScroll: true,
//            actionPane: SlidableDrawerActionPane(),
//            dismissal: SlidableDismissal(
//              child: SlidableDrawerDismissal(),
//              onDismissed: (actionType) {
//                _delete(context, folder);
//              },
//            ),
//            actionExtentRatio: 0.25,
//            child: OpenContainer(
//              useRootNavigator: true,
//              transitionType: _transitionType,
//              closedBuilder: (BuildContext _, VoidCallback openContainer) {
//                return Stack(
//                  alignment: Alignment.topRight,
//                  children: <Widget>[
//                    NotesFolderContainer(
//                      folder: folder,
////                onTap: () => _gotoNotesInFolder(database,
////                    folder),
//                    ),
//                    IconButton(
//                      icon: FaIcon(
//                        FontAwesomeIcons.trashAlt,
//                        size: 20,
//                        color: Colors.white,
//                      ),
//                      onPressed: () => _delete(context, folder),
//                    )
//                  ],
//                );
//              },
//              closedElevation: 0,
//              openElevation: 0,
//              closedColor: Colors.transparent,
//              closedShape: const RoundedRectangleBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(0))),
//              openColor: Colors.transparent,
//              openBuilder: (BuildContext context, VoidCallback _) {
//                return NotesInFolder(database: database, folder: folder);
//              },
//            ),
//
////            NotesFolderContainer(
////                folder: folder,
////                onTap: () => _gotoNotesInFolder(database,
////                    folder)), //on tap: NoteFolderDetail(note: folder);
//            actions: <Widget>[],
//            secondaryActions: <Widget>[
//              IconSlideAction(
//                caption: 'Delete',
//                color: Colors.black12,
//                iconWidget: FaIcon(
//                  FontAwesomeIcons.trashAlt,
//                  color: Colors.white,
//                ),
////                icon: Icons.delete,
//                onTap: () => _delete(context, folder),
//              ),
//            ],
//          );
//        });
//  }

//  Widget getFolderList(Database database, List<Folder> folders) {
//    List defaultFolders = [
//      Folder(id: 0.toString(), title: 'All Notes', colorCode: '4278238420'),
//      Folder(id: 1.toString(), title: 'Notes', colorCode: '4278228616'),
//    ];
//
//    List finalFolderList = defaultFolders..addAll(folders);
//
//    return StaggeredGridView.countBuilder(
//        controller: _hideButtonController,
//        staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
//        mainAxisSpacing: 15.0,
//        crossAxisSpacing: 15.0,
//        physics: BouncingScrollPhysics(),
//        crossAxisCount: 4,
//        itemCount: finalFolderList.length,
//        shrinkWrap: true,
//        itemBuilder: (BuildContext context, int index) {
//          final folder = finalFolderList[index];
//          return Slidable(
////            controller: slidableController,
//            key: UniqueKey(),
//            closeOnScroll: true,
//            actionPane: SlidableDrawerActionPane(),
//            dismissal: SlidableDismissal(
//              child: SlidableDrawerDismissal(),
//              onDismissed: (actionType) {
//                _delete(context, folder);
//              },
//            ),
//            actionExtentRatio: 0.25,
//            child: OpenContainer(
//              useRootNavigator: true,
//              transitionType: _transitionType,
//              closedBuilder: (BuildContext _, VoidCallback openContainer) {
//                return NotesFolderContainer(
//                  folder: folder,
////                onTap: () => _gotoNotesInFolder(database,
////                    folder),
//                );
//              },
//              closedElevation: 0,
//              openElevation: 0,
//              closedColor: Colors.transparent,
//              closedShape: const RoundedRectangleBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(0))),
//              openColor: Colors.transparent,
//              openBuilder: (BuildContext context, VoidCallback _) {
//                return NotesInFolder(database: database, folder: folder);
//              },
//            ), //on tap: NoteFolderDetail(note: folder);
//            actions: <Widget>[
//              IconSlideAction(
//                caption: 'Edit folder name',
//                color: Colors.black12,
//                iconWidget: FaIcon(
//                  FontAwesomeIcons.trashAlt,
//                  color: Colors.white,
//                ),
////                icon: Icons.delete,
//                onTap: () => _showAddDialog(context),
//              ),
//            ],
//            secondaryActions: <Widget>[
//              IconSlideAction(
//                caption: 'Delete',
//                color: Colors.black12,
//                iconWidget: FaIcon(
//                  FontAwesomeIcons.trashAlt,
//                  color: Colors.white,
//                ),
////                icon: Icons.delete,
//                onTap: () => _delete(context, folder),
//              ),
//            ],
//          );
//        });
//  }

//this is just to make UI look consistent
//  Widget getButtonFolderContainer(Database database) {
//    List defaultFolders = [
//      NotesFolderContainerButton(onTap: () => _showAddDialog(context)),
//    ];
//
//    return StaggeredGridView.countBuilder(
////        controller: _hideButtonController,
//        staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
//        mainAxisSpacing: 8.0,
//        crossAxisSpacing: 8.0,
//        physics: BouncingScrollPhysics(),
//        crossAxisCount: 4,
//        itemCount: defaultFolders.length,
//        shrinkWrap: true,
//        itemBuilder: (BuildContext context, int index) {
////          final folder = defaultFolders[index];
//          return NotesFolderContainerButton(
//              onTap: () => _showAddDialog(context));
//        });
//  }
