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
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/notes_screen/note_container.dart';
import 'package:iMomentum/app/common_widgets/error_message.dart';
import 'package:provider/provider.dart';
import 'add_note_screen.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'empty_content.dart';
import 'move_folder_screen.dart';

class SearchResult extends StatefulWidget {
  final List<Folder> folders;
  final Database database;
  final String query;

  const SearchResult({Key key, this.folders, this.database, this.query})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SearchResultState();
  }
}

class SearchResultState extends State<SearchResult> {
  List<Folder> get folders => widget.folders;
  Database get database => widget.database;
  String get query => widget.query;

  List<Note> filteredNotes = [];

  final List<Folder> defaultFolders = [
    Folder(id: 0.toString(), title: 'All Notes'),
    Folder(id: 1.toString(), title: 'Notes'),
  ];

  int counter = 0;
  void _onDoubleTap() {
    setState(() {
      ImageUrl.randomImageUrl = '${ImageUrl.randomImageUrlFirstPart}$counter';
      counter++;
    });
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

  List<Note> _getFilteredNotes(List<Note> notes) {
    List<Note> filteredNotes = [];
    notes.forEach((note) {
      if (note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.description.toLowerCase().contains(query.toLowerCase()))
        filteredNotes.add(note);
    });
    print('filteredNotes: $filteredNotes');
    return filteredNotes;
  }

  @override
  Widget build(BuildContext context) {
    final randomNotifier = Provider.of<RandomNotifier>(context, listen: false);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context, listen: false);

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
                builder: (con, snapshot) {
                  if (snapshot.hasData) {
                    final List<Note> allNotes = snapshot.data;
                    filteredNotes = _getFilteredNotes(allNotes);
                    final List<Note> pinnedNotes =
                        _getPinnedNote(filteredNotes);
                    final List<Note> notPinnedNotes =
                        _getNotPinnedNote(filteredNotes);

                    if (pinnedNotes.isNotEmpty || notPinnedNotes.isNotEmpty) {
                      return Column(
                        children: [
                          Expanded(
                            child: Opacity(
                              opacity: _notesOpacity,
                              child: CustomScrollView(
                                slivers: <Widget>[
                                  //this is just for the word 'PINNED'
                                  _buildBoxAdaptorForPinned(pinnedNotes),
                                  //this is for pinned notes
                                  _buildNotesGrid(pinnedNotes),
                                  //this is just for the word 'OTHERS'
                                  pinnedNotes.length > 0
                                      ? _buildBoxAdaptorForOthers(
                                          notPinnedNotes)
                                      : SliverToBoxAdapter(child: Container()),
                                  //this is for not pinned notes
                                  _buildNotesGrid(notPinnedNotes),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          Expanded(
                              child: EmptyContent(text: 'No result found.')),
                        ],
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Column(
                      children: [
                        Expanded(
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
                        ),
                        // _bottomRow(),
                      ],
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBoxAdaptorForPinned(List<Note> notes) {
    return SliverToBoxAdapter(
      child: notes.length == 0
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25, top: 10),
              child: ContainerOnlyText(text: 'PINNED'),
            ),
    );
  }

  Widget _buildBoxAdaptorForOthers(List<Note> notes) {
    return SliverToBoxAdapter(
      child: notes.length == 0
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25),
              child: ContainerOnlyText(text: 'OTHERS'),
            ),
    );
  }

  int axisCount = 2;
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
              return _slidableItem(note);
            }));
  }

  ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  Widget _slidableItem(Note note) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
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
            folder: defaultFolders[0],
            folders: folders,
          );
        },
        openElevation: 0,
        openColor: Colors.transparent,
        openBuilder: (BuildContext context, VoidCallback _) {
          return AddNoteScreen(
              database: database, note: note, folders: folders);
        },
      ),
      actions: <Widget>[
        IconSlideAction(
          foregroundColor: Colors.blue,
          caption: 'Move',
          color: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
          icon: EvaIcons.folderOutline,
          onTap: () => _move(note),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          foregroundColor: Colors.red,
          caption: 'Delete',
          color: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
          icon: EvaIcons.trash2Outline,
          onTap: () => _delete(database, note),
        ),
      ],
    );
  }

  double _notesOpacity = 1.0;

  void _move(Note note) async {
    setState(() {
      _notesOpacity = 0.0;
      // _addButtonVisible = false;
    });
    await showModalBottomSheet(
        context: context,

        ///must not have this line in this case
        // isScrollControlled: true,
        builder: (context) => MoveFolderScreen(
              database: database,
              // folders: folders,
              note: note,
            ));

    setState(() {
      _notesOpacity = 1.0;
      // _addButtonVisible = true;
    });
  }

  ///https://stackoverflow.com/questions/54617432/looking-up-a-deactivated-widgets-ancestor-is-unsafe
  ///
  /// if we don't add BuildContext, context is red color
  Future<void> _delete(Database database, Note note) async {
    setState(() {
      // _addButtonVisible = false;
    });
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
              ///add BuildContext context, so that it won't pop to folder screen,
              ///it doesn't seem to matter
              Navigator.of(context).pop();
              await database.setNote(note);
            } on PlatformException catch (e) {
              PlatformExceptionAlertDialog(
                title: 'Operation failed',
                exception: e,
              ).show(context);
            }
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
      duration: Duration(seconds: 3),
      icon: Icon(
        EvaIcons.trash2Outline,
        color: Colors.white,
      ),
      titleText: Text(
        'Deleted.',
        style: KFlushBarTitle,
      ),
      messageText: Text(note.title.isEmpty ? note.description : note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: KFlushBarMessage),
    )..show(context);
  }
}
