import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/device.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/notes_screen/search_note.dart';
import 'package:iMomentum/app/common_widgets/empty_content.dart';
import 'package:provider/provider.dart';
import 'add_note_screen.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'notes_folder_container.dart';
import 'notes_folder_detail.dart';

class NotesFolderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotesFolderScreenState();
  }
}

const double _fabDimension = 56.0;

class NotesFolderScreenState extends State<NotesFolderScreen>
    with SingleTickerProviderStateMixin {
//  AnimationController _controller;

  SlidableController slidableController;
//  Animation<double> _rotationAnimation;

  bool _isVisible;
  ScrollController _hideButtonController;

  // for folder
  bool isMobile = true;
  bool showNote = false;
  Timer timer;
  AnimationController _controller;
  Animation<Color> animation, animation2;
  Device device;

  @override
  void initState() {
    super.initState();
    _isVisible = true;
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });

    // for folder
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    /// Change Background Color animation
    animation = ColorTween(
      begin: Colors.white,
      end: Colors.grey[800],
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    /// Change Text and Icon Color invert of [animation]
    animation2 = ColorTween(
      begin: Colors.grey[800],
      end: Colors.white,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideButtonController.removeListener(() {});
//    _hideButtonController.dispose(); //what's the difference?
    super.dispose();
  }

  int axisCount = 2;

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
    final database = Provider.of<Database>(context, listen: false);
    final randomNotifier = Provider.of<RandomNotifier>(context);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context);

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    isMobile = deviceWidth > deviceHeight ? false : true;

    device = Device(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

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
              child: StreamBuilder<List<Folder>>(
                stream: database
                    .foldersStream(), // print(database.todosStream());//Instance of '_MapStream<QuerySnapshot, List<TodoModel>>'
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<Folder> folders = snapshot.data;
                    final themeNotifier = Provider.of<ThemeNotifier>(context);
                    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
                    if (folders.isNotEmpty) {
                      return Column(
                        children: <Widget>[
//                          folders.length == 0
//                              ? Container()
//                              :
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25, bottom: 10),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: _darkTheme
                                        ? darkSurfaceTodo
                                        : lightSurface,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Row(
                                  children: <Widget>[
                                    FlatButton.icon(
                                        onPressed: null,
                                        icon: Icon(Icons.search),
                                        label: Text('Search your notes'))
                                  ],
                                )),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: getNotesList(folders),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Please enter a task from HomePage first',
                            style: KEmptyContent,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ));
                    }
                  } else if (snapshot.hasError) {
                    return Center(
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
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ),
        Visibility(
          visible: _isVisible,
          child: Stack(
            overflow: Overflow.visible,
            alignment: FractionalOffset(0.97, .87),
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: OpenContainer(
                  transitionType: _transitionType,
                  openBuilder: (BuildContext context, VoidCallback _) {
                    return AddNoteScreen(database: database);
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
                        child:
//                      _rotationAnimation == null
//                          ?
                            Center(
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
      ],
    );
  }

  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  Widget getNotesList(List<Folder> folders) {
    final database = Provider.of<Database>(context, listen: false);

    List defaultFolders = [
      Folder(id: 0.toString(), title: 'All Notes'),
      Folder(id: 1.toString(), title: 'Notes'),
    ];

    List finalFolderList = defaultFolders..addAll(folders);
    return StaggeredGridView.countBuilder(
        controller: _hideButtonController,
        staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        physics: BouncingScrollPhysics(),
        crossAxisCount: 4,
        itemCount: finalFolderList.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final folder = finalFolderList[index];
          return Slidable(
//            controller: slidableController,
            key: UniqueKey(),
            closeOnScroll: true,
            actionPane: SlidableDrawerActionPane(),
            dismissal: SlidableDismissal(
              child: SlidableDrawerDismissal(),
              onDismissed: (actionType) {
                _delete(context, folder);
              },
            ),
            actionExtentRatio: 0.25,
            child: OpenContainer(
              useRootNavigator: true,
              transitionType: _transitionType,
              closedBuilder: (BuildContext _, VoidCallback openContainer) {
                return NotesFolderContainer(folder
//                  database: database,
//                  onTap: () => _onTap(database, note),
                    );
              },
              closedColor: Colors.transparent,
//              closedShape: const RoundedRectangleBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              openColor: Colors.transparent,
              openBuilder: (BuildContext context, VoidCallback _) {
                return NoteFolderDetail(note: folder);
              },
            ),
            actions: <Widget>[],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: Colors.black12,
                iconWidget: FaIcon(
                  FontAwesomeIcons.trashAlt,
                  color: Colors.white,
                ),
//                icon: Icons.delete,
                onTap: () => _delete(context, folder),
              ),
            ],
          );
        });
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _search(Database database, List<Note> notes) async {
    final Note result =
        await showSearch(context: context, delegate: NotesSearch(notes: notes));
    if (result != null) {
      navigateToDetail(database: database, note: result);
    }
  }
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

  void navigateToDetail({Database database, Note note}) =>
      Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
        builder: (context) => AddNoteScreen(database: database, note: note),
        fullscreenDialog: true,
      ));
}
