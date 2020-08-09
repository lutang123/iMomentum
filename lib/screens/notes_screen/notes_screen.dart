import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/notes_screen/search_note.dart';
import 'package:iMomentum/screens/notes_screen/build_note_container.dart';
import 'package:iMomentum/app/common_widgets/empty_content.dart';
import 'package:provider/provider.dart';
import 'add_note_screen.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'notes_folder_screen.dart';
import 'notes_test.dart';

class NotesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotesScreenState();
  }
}

const double _fabDimension = 56.0;

class NotesScreenState extends State<NotesScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  SlidableController slidableController;
  Animation<double> _rotationAnimation;

  bool _isVisible;
  ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      value: 0.0,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 75),
      vsync: this,
    )..addStatusListener((AnimationStatus status) {
        setState(() {
          // setState needs to be called to trigger a rebuild because
          // the 'HIDE FAB'/'SHOW FAB' button needs to be updated based
          // the latest value of [_controller.status].
        });
      });
//    slidableController = SlidableController(
//      onSlideAnimationChanged: handleSlideAnimationChanged,
//    );

    _isVisible = true;
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          /* only set when the previous state is false
             * Less widget rebuilds
             */
//          print("**** $_isVisible up"); //Move IO away from setState
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            /* only set when the previous state is false
               * Less widget rebuilds
               */
//            print("**** $_isVisible down"); //Move IO away from setState
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideButtonController.removeListener(() {});
//    _hideButtonController.dispose(); //what's the difference?
    super.dispose();
  }

  int axisCount = 2;

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
    print('_rotationAnimation: $_rotationAnimation');
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
    final database = Provider.of<Database>(context, listen: false);
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
              child: StreamBuilder<List<Note>>(
                stream: database
                    .notesStream(), // print(database.todosStream());//Instance of '_MapStream<QuerySnapshot, List<TodoModel>>'
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<Note> notes = snapshot.data;
                    final themeNotifier = Provider.of<ThemeNotifier>(context);
                    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
                    if (notes.isNotEmpty) {
//                    void _onReorder(int oldIndex, int newIndex) {
//                      setState(
//                        () {
//                          final Note note = notes.removeAt(oldIndex);
//                          notes.insert(newIndex, note);
//                        },
//                      );
//                    }

                      return Column(
                        children: <Widget>[
                          notes.length == 0
                              ? Container()
                              : Padding(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              SizedBox(width: 60),
                                              FlatButton(
                                                child: Text(
                                                  'Search your notes',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: _darkTheme
                                                        ? darkHint
                                                        : lightHint,
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    _search(database, notes),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              IconButton(
                                                icon: Icon(
                                                  axisCount == 2
                                                      ? FontAwesomeIcons.list
                                                      : FontAwesomeIcons
                                                          .gripVertical,
                                                  //dehaze
//                                                    ? Icons.list
//                                                    : Icons.grid_on,
                                                  color: _darkTheme
                                                      ? Colors.white
                                                      : lightButton,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    axisCount =
                                                        axisCount == 2 ? 4 : 2;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                ),
//                          MyFlatButton(
//                              text: 'Notes Folder',
//                              onPressed: () => Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (_) => NotesFolder()))),
                          MyFlatButton(
                              text: 'Notes Folder',
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => NotesTest()))),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: getNotesList(notes),
//                            child: ReorderableWrap(
//                                spacing: 8.0,
//                                runSpacing: 4.0,
//                                onReorder: _onReorder,
//                                padding: const EdgeInsets.all(8),
//                                children: List.generate(
//                                  notes.length,
//                                  (index) {
//                                    return BuildNoteContainer(
//                                      index: index,
//                                      notes: notes,
//                                      database: database,
//                                      onTap: () =>
//                                          _onTap(database, notes[index]),
//                                    );
//                                  },
//                                )),
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
                        )
//                          : RotationTransition(
//                              turns: _rotationAnimation,
//                              child: Icon(Icons.add,
//                                  size: 30, color: Colors.white),
//                            ),
                        );
                  },
                ),

//                MyFAB(
//                  onPressed: () => _add(database),
//                  heroTag: "btn2",
//                  child: _rotationAnimation == null
//                      ? Icon(Icons.add, size: 30, color: Colors.white)
//                      : RotationTransition(
//                          turns: _rotationAnimation,
//                          child: Icon(Icons.add, size: 30, color: Colors.white),
//                        ),
//                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  Widget getNotesList(List<Note> notes) {
    final database = Provider.of<Database>(context, listen: false);
    return StaggeredGridView.countBuilder(
//        controller: _scrollController,
        controller: _hideButtonController,
        staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        physics: BouncingScrollPhysics(),
        crossAxisCount: 4,
        itemCount: notes.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final note = notes[index];
          return Slidable(
//            controller: slidableController,
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
                      onLongPress: () => _onLongPress(),
//                  onTap: () => _onTap(database, note), //changed to OpenContainer
                    ),
                    Visibility(
                      visible: _deleteVisible,
                      child: IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.trashAlt,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () => _delete(context, note),
                      ),
                    )
                  ],
                );
              },
              closedColor: Colors.transparent,
              closedShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              openColor: Colors.transparent,
              openBuilder: (BuildContext context, VoidCallback _) {
                return AddNoteScreen(database: database, note: note);
              },
            ),
            actions: <Widget>[
              IconSlideAction(
                caption: 'Archive',
                color: Colors.black12,
                iconWidget: FaIcon(
                  FontAwesomeIcons.archive,
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
        });
  }

  bool _deleteVisible = false;
  void _onLongPress() {
    setState(() {
      _deleteVisible = !_deleteVisible;
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

  ///update
  void _onTap(Database database, Note note) =>
      navigateToDetail(database: database, note: note);

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
