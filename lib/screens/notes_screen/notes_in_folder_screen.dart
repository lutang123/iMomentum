import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/notes_screen/my_flutter_icons.dart';
import 'package:iMomentum/screens/notes_screen/search_note.dart';
import 'package:iMomentum/screens/notes_screen/build_note_container.dart';
import 'package:iMomentum/app/common_widgets/empty_content.dart';
import 'package:provider/provider.dart';
import 'add_note_screen.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import 'my_flutter_app_icons.dart';

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
//    print(_newList);
    return _newList;
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
                    final _notesInThisFolder =
                        _getNotesInThisFolder(allNotes, folder);
                    if (_notesInThisFolder.isNotEmpty) {
                      return Column(
                        children: [
                          _topRow(_notesInThisFolder),
                          Expanded(
                            child: CustomScrollView(
                              controller: _hideButtonController,
                              slivers: <Widget>[
                                _buildBoxAdaptor(_notesInThisFolder),
                                _buildNotesGrid(_notesInThisFolder),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _topRow(_notesInThisFolder),
                          Expanded(
                            child: Center(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Any thoughts or new ideas you want to write? Click the round plus button to add a new note.',
                                  style: KEmptyContent,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )),
                          ),
                        ],
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Column(
                      children: [
                        _topErrorRow(),
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
            alignment: FractionalOffset(0.97, .87),
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

//                MyFAB(
//                  onPressed: () => _add(database),
//                  heroTag: "btn2",
//                  child: Icon(Icons.add, size: 30, color: Colors.white),
//                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _topRow(List<Note> notes) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    return Column(
      children: <Widget>[
        //this is to make top bar color cover all
        SizedBox(
          height: 30,
          child: Container(
            color: _darkTheme ? darkAppBar : lightSurface,
          ),
        ),
        Container(
          height: 50,
          color: _darkTheme ? darkAppBar : lightSurface,
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
                          ? MyFlutterApp.menu_outline
                          : MyFlutterApp.th_large_outline,
                      size: 20,
                      color: _darkTheme ? Colors.white : lightButton,
                    ),
                    onPressed: () {
                      setState(() {
                        axisCount = axisCount == 2 ? 4 : 2;
                      });
                    },
                  ),
                ),
              ),
//
//                                    FlatButton(
//                                        onPressed: () => null,
////                                    Navigator.push(
////                                    context,
////                                    MaterialPageRoute(
////                                        builder: (_) => HomeScreenKeep())),
//                                        child: Text('Edit'))
            ],
          ),
        ),
      ],
    );
  }

  Widget _topErrorRow() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    return Column(
      children: <Widget>[
        //this is to make top bar color cover all
        SizedBox(
          height: 30,
          child: Container(
            color: _darkTheme ? darkAppBar : lightSurface,
          ),
        ),
        Container(
          height: 50,
          color: _darkTheme ? darkAppBar : lightSurface,
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
                          ? MyFlutterApp.menu_outline
                          : MyFlutterApp.th_large_outline,
                      size: 20,
                      color: _darkTheme ? Colors.white : lightButton,
                    ),
                    onPressed: () {
                      setState(() {
                        axisCount = axisCount == 2 ? 4 : 2;
                      });
                    },
                  ),
                ),
              ),
//
//                                    FlatButton(
//                                        onPressed: () => null,
////                                    Navigator.push(
////                                    context,
////                                    MaterialPageRoute(
////                                        builder: (_) => HomeScreenKeep())),
//                                        child: Text('Edit'))
            ],
          ),
        ),
      ],
    );
  }

  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  int axisCount = 2;
  Widget _buildBoxAdaptor(List<Note> notes) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SliverToBoxAdapter(
      child: notes.length == 0
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, right: 25, top: 20, bottom: 10),
              child: Container(
                  decoration: BoxDecoration(
                      color: _darkTheme ? Colors.black38 : lightSurface,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Row(
                    children: [
                      FlatButton.icon(

                          ///Todo: implement search
                          onPressed: null,
                          icon: Icon(
                            Icons.search,
                            color: Colors.white70,
                          ),
                          label: Text(
                            'Search your notes',
                            style: TextStyle(color: Colors.white70),
                          )),
                    ],
                  )),
            ),
    );
  }

  Widget _buildNotesGrid(List<Note> notes) {
    return SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                dismissal: SlidableDismissal(
                  child: SlidableDrawerDismissal(),
                  onDismissed: (actionType) {
                    _delete(context, note);
                  },
                ),
                actionExtentRatio: 0.25,
                child:

//            BuildNoteContainer(
//              note: note,
//              database: database,
//              onTap: () => _onTap(database, note),
//            ),

                    OpenContainer(
                  useRootNavigator: true,
                  transitionType: _transitionType,
                  closedBuilder: (BuildContext _, VoidCallback openContainer) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        BuildNoteContainer(
                          note: note,
                          database: database,
                          folder: folder,
                          folders: folders,
//                  onTap: () => _onTap(database, note), //changed to OpenContainer
                        ),
//                        IconButton(
//                          icon: FaIcon(
//                            FontAwesomeIcons.trashAlt,
//                            size: 20,
//                            color: Colors.white,
//                          ),
//                          onPressed: () => _delete(context, note),
//                        )
                      ],
                    );
                  },
                  closedColor: Colors.transparent,
                  closedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                    caption: 'Archive',
                    color: Colors.black12,
                    iconWidget: FaIcon(
                      EvaIcons.archiveOutline,
                      color: Colors.white,
                    ),
                    onTap: () => _showSnackBar(context, 'Archive'),
                  ),
                ],
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.black12,
                    iconWidget: FaIcon(
                      FontAwesomeIcons.trashAlt,
                      color: Colors.white,
                    ),
//                icon: Icons.delete,
                    onTap: () => _delete(context, note),
                  ),
                ],
              );
            }));
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

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

  ///delete
  Future<void> _delete(BuildContext context, Note note) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteNote(note);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

//  void navigateToDetail({Database database, Note note}) =>
//      Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
//        builder: (context) => AddNoteScreen(
//          database: database,
//          note: note,
//          folder: folder,
//        ),
//        fullscreenDialog: true,
//      ));
}
