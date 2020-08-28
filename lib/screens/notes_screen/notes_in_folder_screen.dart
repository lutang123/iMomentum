import 'package:animations/animations.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_list_tile.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/notes_screen/note_container.dart';
import 'package:iMomentum/app/common_widgets/empty_content.dart';
import 'package:provider/provider.dart';
import 'add_note_screen.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'move_folder_screen.dart';
import 'my_flutter_app_icon.dart';

class NotesInFolderScreen extends StatefulWidget {
  final Folder folder;
  final List<Folder> folders;
  final Database database;

  const NotesInFolderScreen({Key key, this.folder, this.folders, this.database})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NotesInFolderScreenState();
  }
}

const double _fabDimension = 56.0;

class NotesInFolderScreenState extends State<NotesInFolderScreen> {
  Folder get folder => widget.folder;
  List<Folder> get folders => widget.folders;
  Database get database => widget.database;

  bool _addButtonVisible = true;
  ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
//    print('folders: $folders');
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

  List<Note> _getNotesInThisFolder(List<Note> allNotes, Folder folder) {
    final List<Note> _newList = [];
    for (Note note in allNotes) {
      if (folder.id == 0.toString()) {
        _newList.add(note); //add all notes
      } else if (folder.id != 0.toString()) {
        if (note.folderId == folder.id) {
          _newList.add(note);
        }
      }
    }
    return _newList;
  }

  List<Note> _getPinnedNote(List<Note> allNotes) {
    List<Note> pinnedNotes = [];
    allNotes.forEach((note) {
      if (note.isPinned == true) {
        pinnedNotes.add(note);
      }
    });
    return pinnedNotes;
  }

  List<Note> _getNotPinnedNote(List<Note> allNotes) {
    List<Note> pinnedNotes = [];
    allNotes.forEach((note) {
      if (note.isPinned == false || note.isPinned == null) {
        pinnedNotes.add(note);
      }
    });
    return pinnedNotes;
  }

  @override
  Widget build(BuildContext context) {
    final randomNotifier = Provider.of<RandomNotifier>(context);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context);

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
            body: SafeArea(
              top: false,
              child: StreamBuilder<List<Note>>(
                stream: database
                    .notesStream(), // print(database.todosStream());//Instance of '_MapStream<QuerySnapshot, List<TodoModel>>'
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<Note> allNotes = snapshot.data;
                    final List<Note> pinnedNotes = _getPinnedNote(allNotes);
                    final List<Note> notPinnedNotes =
                        _getNotPinnedNote(allNotes);

                    final _notPinnedNotesInThisFolder =
                        _getNotesInThisFolder(notPinnedNotes, folder);
                    final _pinnedNotesInThisFolder =
                        _getNotesInThisFolder(pinnedNotes, folder);

                    if (_notPinnedNotesInThisFolder.isNotEmpty ||
                        _pinnedNotesInThisFolder.isNotEmpty) {
                      return Column(
                        children: [
                          //this parameter is just a replace of allNotes after added pinned function
                          _topRow(_notPinnedNotesInThisFolder),
                          Expanded(
                            child: Opacity(
                              opacity: _notesOpacity,
                              child: CustomScrollView(
                                controller: _hideButtonController,
                                slivers: <Widget>[
                                  //this is for search bar.
                                  _buildBoxAdaptorForSearch(
                                      _notPinnedNotesInThisFolder),
                                  //this is just for the word 'PINNED'
                                  _buildBoxAdaptorForPinned(
                                      _pinnedNotesInThisFolder),
                                  //this is for pinned notes
                                  _buildNotesGrid(_pinnedNotesInThisFolder),
                                  //this is just for the word 'OTHERS'
                                  _buildBoxAdaptorForOthers(
                                      _pinnedNotesInThisFolder),
                                  //this is for
                                  _buildNotesGrid(_notPinnedNotesInThisFolder),
                                ],
                              ),
                            ),
                          ),
//                          SizedBox(height: 25),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _topRow(_notPinnedNotesInThisFolder),
                          Expanded(
                            child: Center(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    'Any thoughts or new ideas you want to write? Click the plus button to add a new note.',
                                    style: KEmptyContent,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )),
                          ), //empty content
                        ],
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Column(
                      children: [
                        ///no need for this
                        _topErrorRow(), //no toggle button
                        Expanded(
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
                        ),
                      ],
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ),
        Visibility(
          visible: _addButtonVisible,
          child: Stack(
            overflow: Overflow.visible,
            alignment: FractionalOffset(0.99, .90),
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: OpenContainer(
                  useRootNavigator: true,
                  transitionType: _transitionType,
                  openBuilder: (BuildContext context, VoidCallback _) {
                    return AddNoteScreen(database: database, folder: folder);
                  },
                  closedElevation: 6.0,
                  closedColor: Colors.transparent,
                  openColor: Colors.transparent,
//                  shape: CircleBorder(side: BorderSide(color: Colors.white, width: 2.0)),
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
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //if use appBar, then no access to notes, unless move SteamBuilder above Scaffold, but the empty content and error message will look terrible if no scaffold
  Widget _topRow(List<Note> notes) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Column(
      children: <Widget>[
        //this is to make top bar color cover all
        SizedBox(
          height: 35,
          child: Container(
            color: _darkTheme ? darkThemeAppBar : lightThemeSurface,
          ),
        ),
        Container(
          height: 50,
          color: _darkTheme ? darkThemeAppBar : lightThemeSurface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context)),
              Text(folder.title, style: Theme.of(context).textTheme.headline6),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Opacity(
                  opacity: notes.length > 0 ? 1 : 0,
                  child: IconButton(
                    icon: Icon(
                      axisCount == 2
                          ? MyFlutterAppIcon.menu_outline
                          : MyFlutterAppIcon.th_large_outline,
                      size: 20,
                      color: _darkTheme ? Colors.white : lightThemeButton,
                    ),
                    onPressed: () {
                      setState(() {
                        axisCount = axisCount == 2 ? 4 : 2;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //if there is error, still want to show top row, this one does not have toggle view button
  Widget _topErrorRow() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Column(
      children: <Widget>[
        SizedBox(
          height: 35,
          child: Container(
            color: _darkTheme ? darkThemeAppBar : lightThemeSurface,
          ),
        ),
        Container(
          height: 50,
          color: _darkTheme ? darkThemeAppBar : lightThemeSurface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context)),
              Text(folder.title, style: Theme.of(context).textTheme.headline6),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Opacity(
                  opacity: 0,
                  child: IconButton(
                    icon: Icon(
                      axisCount == 2
                          ? MyFlutterAppIcon.menu_outline
                          : MyFlutterAppIcon.th_large_outline,
                      size: 20,
                      color: _darkTheme ? Colors.white : lightThemeButton,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  int axisCount = 2;
  Widget _buildBoxAdaptorForSearch(List<Note> notes) {
    return SliverToBoxAdapter(
      child: notes.length == 0
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25, top: 20),
              child: NoteSearchBar(onPressed: null),
            ),
    );
  }

  Widget _buildBoxAdaptorForPinned(List<Note> notes) {
    return SliverToBoxAdapter(
      child: notes.length == 0
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25, top: 10),
              child: ContainerForNotesPinned(text: 'PINNED'),
            ),
    );
  }

  Widget _buildBoxAdaptorForOthers(List<Note> notes) {
    return SliverToBoxAdapter(
      child: notes.length == 0
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25),
              child: ContainerForNotesPinned(text: 'OTHERS'),
            ),
    );
  }

  Widget _buildNotesGrid(List<Note> notes) {
    return SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        sliver: SliverStaggeredGrid.countBuilder(
            crossAxisCount: 4, // set column count, why it's 4?
            staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0, //the vertical space
            itemCount: notes.length,
            itemBuilder: (BuildContext context, int index) {
              final note = notes[index];
              return Slidable(
                key: UniqueKey(),
                closeOnScroll: true,
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: OpenContainer(
                  useRootNavigator: true,
                  transitionType: _transitionType,
                  //added this elevation, the error placeholder called null is gone
                  closedElevation: 0,
                  closedColor: Colors.transparent,
                  closedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  closedBuilder: (BuildContext _, VoidCallback openContainer) {
                    return NoteContainer(
                      note: note,
                      database: database,
                      folder: folder,
                      folders: folders,
//                  onTap: () => _onTap(database, note), //changed to OpenContainer
                    );
                  },
                  openElevation: 0,
                  openColor: Colors.transparent,
                  openBuilder: (BuildContext context, VoidCallback _) {
                    return AddNoteScreen(
                        database: database,
                        note: note,
                        folder: folder,
                        folders: folders);
                  },
                ),
                actions: <Widget>[
                  IconSlideAction(
                    foregroundColor: Colors.blue,
                    caption: 'Move',
                    color: Colors.black45,
                    icon: EvaIcons.folderOutline,
                    onTap: () => _showMoveDialog(note),
                  ),
                ],
                secondaryActions: <Widget>[
                  IconSlideAction(
                    foregroundColor: Colors.red,
                    caption: 'Delete',
                    color: Colors.black45,
                    icon: EvaIcons.trash2Outline,
                    onTap: () => _delete(database, note),
                  ),
                ],
              );
            }));
  }

  double _notesOpacity = 1.0;
  void _showMoveDialog(Note note) async {
    setState(() {
      _notesOpacity = 0.0;
      _addButtonVisible = false;
    });
    await showModalBottomSheet(
        context: context,
        // isScrollControlled: true,
        builder: (context) => MoveFolderScreen(
              database: database,
              // folders: folders,
              note: note,
            ));

    setState(() {
      _notesOpacity = 1.0;
      _addButtonVisible = true;
    });
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

    Flushbar(
      isDismissible: true,
      mainButton: FlatButton(
          onPressed: () async {
            //reset
            try {
              await database.setNote(note);
            } on PlatformException catch (e) {
              PlatformExceptionAlertDialog(
                title: 'Operation failed',
                exception: e,
              ).show(context);
            }

            ///should not add this line, because when it's going to be automatically
            ///dismissed, and then press this will take to black screen.
//          Navigator.pop(context);
            ///changed the word 'Undo' to'added back', but the words not change, why?
          },
          child: FlushBarButtonChild(
            title: 'UNDO',
          )),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(left: 10),
      borderRadius: 15,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundGradient: LinearGradient(colors: [
        Color(0xF0888888).withOpacity(0.85),
        darkThemeNoPhotoBkgdColor,
      ]),
      duration: Duration(seconds: 10),
      icon: Icon(
        EvaIcons.trash2Outline,
        color: Colors.white,
      ),
      titleText: Text(
        'Deleted',
        style: KFlushBarTitle,
      ),
      messageText: Text(note.title.isEmpty ? note.description : note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: KFlushBarMessage),
    )..show(context);
  }
}

///notes for a bottom row
//  Widget _bottomRow(Database database) {
//    final themeNotifier = Provider.of<ThemeNotifier>(context);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//    return Visibility(
//      visible: _addButtonVisible,
//      child: Container(
//        decoration: BoxDecoration(
//          color: _darkTheme ? Colors.black38 : lightSurface,
//          borderRadius: BorderRadius.only(
//            topLeft: Radius.circular(20.0),
//            topRight: Radius.circular(20.0),
//          ),
//        ),
//        height: 60,
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.end,
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.only(right: 12.0),
//              child: OpenContainer(
//                useRootNavigator: true,
//                transitionType: _transitionType,
//                openBuilder: (BuildContext context, VoidCallback _) {
//                  return AddNoteScreen(database: database, folder: folder);
//                },
//                closedElevation: 6.0,
//                closedColor: Colors.transparent,
//                openColor: Colors.transparent,
////                  shape: CircleBorder(side: BorderSide(color: Colors.white, width: 2.0)),
//                closedShape: const RoundedRectangleBorder(
//                  side: BorderSide(color: Colors.white, width: 2.0),
//                  borderRadius: BorderRadius.all(
//                    Radius.circular(_fabDimension / 2),
//                  ),
//                ),
//                closedBuilder:
//                    (BuildContext context, VoidCallback openContainer) {
//                  return SizedBox(
//                    height: _fabDimension,
//                    width: _fabDimension,
//                    child: Center(
//                      child: Icon(
//                        Icons.add,
//                        size: 30,
//                        color: Colors.white,
//                      ),
//                    ),
//                  );
//                },
//              ),
//
////                MyFAB(
////                  onPressed: () => _add(database),
////                  heroTag: "btn2",
////                  child: Icon(Icons.add, size: 30, color: Colors.white),
////                ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }

//  void _showSnackBar(BuildContext context, String text) {
//    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
//  }

//  Future<void> _search(Database database, List<Note> notes) async {
//    final Note result =
//        await showSearch(context: context, delegate: NotesSearch(notes: notes));
//    if (result != null) {
//      navigateToDetail(database: database, note: result);
//    }
//  }
//
//  ///for fab, add new, later changed to OpenContainer
//  void _add(Database database) => navigateToDetail(database: database);

//  ///update
//  void _onTap(Database database, Note note) =>
//      navigateToDetail(database: database, note: note);
