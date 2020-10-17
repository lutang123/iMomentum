import 'package:animations/animations.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_stack_screen.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/my_strings.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/notes_screen/note_container.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'add_note_screen.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../app/common_widgets/empty_and_error_content.dart';
import 'move_folder_screen.dart';
import 'my_custom_icon.dart';
import 'open_container_add_note.dart';

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

class NotesInFolderScreenState extends State<NotesInFolderScreen> {
  Folder get folder => widget.folder;
  List<Folder> get folders => widget.folders;
  Database get database => widget.database;

  ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  int axisCount = 2;
  bool _addButtonVisible = true;
  ScrollController _hideButtonController;

  @override
  void initState() {
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
    super.initState();
  }

  @override
  void dispose() {
    _hideButtonController.removeListener(() {});
    _hideButtonController.dispose(); //what's the difference?
    super.dispose();
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
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return MyStackScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
        appBar: buildAppBar(_darkTheme),
        body: SafeArea(
          // when remove SafeArea the _botttomRow not show?
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              _buildStreamBuilderNotes(_darkTheme), //Expanded CustomScrollView
              _bottomRow(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(bool _darkTheme) {
    return AppBar(
      backgroundColor: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
      elevation: 0.0,
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              size: 30, color: _darkTheme ? darkThemeButton : lightThemeButton),
          onPressed: () => Navigator.pop(context)),
      title: Text(folder.title, style: Theme.of(context).textTheme.headline6),
      actions: [
        IconButton(
          icon: Icon(
            axisCount == 2
                ? MyCustomIcon.menu_outline
                : MyCustomIcon.th_large_outline,
            size: 22,
            color: _darkTheme ? darkThemeButton : lightThemeButton,
          ),
          onPressed: () {
            setState(() {
              axisCount = axisCount == 2 ? 4 : 2;
            });
          },
        ),
      ],
    );
  }

  Widget _bottomRow() {
    return Visibility(
      visible: _addButtonVisible,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0, bottom: 15),
            child: OpenContainerAddNotes(
              context: context,
              openWidget: AddNoteScreen(database: database, folder: folder),
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<List<Note>> _buildStreamBuilderNotes(bool _darkTheme) {
    return StreamBuilder<List<Note>>(
      stream: database
          .notesStream(), // print(database.todosStream());//Instance of '_MapStream<QuerySnapshot, List<TodoModel>>'
      builder: (con, snapshot) {
        if (snapshot.hasData) {
          final List<Note> allNotes = snapshot.data;
          final List<Note> pinnedNotes = _getPinnedNote(allNotes);
          final List<Note> notPinnedNotes = _getNotPinnedNote(allNotes);
          final _pinnedNotesInThisFolder =
              _getNotesInThisFolder(pinnedNotes, folder);
          final _notPinnedNotesInThisFolder =
              _getNotesInThisFolder(notPinnedNotes, folder);
          if (_notPinnedNotesInThisFolder.isNotEmpty ||
              _pinnedNotesInThisFolder.isNotEmpty) {
            return buildExpandedCustomScrollView(_darkTheme,
                _pinnedNotesInThisFolder, _notPinnedNotesInThisFolder);
          } else {
            //if notes are empty
            return Column(
              children: [
                Spacer(), //add this to make it center in screen
                EmptyOrError(text: Strings.emptyNote),
                Spacer(),
              ],
            );
          }
        } else if (snapshot.hasError) {
          print(
              'snapshot.hasError in notes stream: ${snapshot.error.toString()}');
          return Column(
            children: [
              Spacer(),
              EmptyOrError(error: Strings.streamErrorMessage),
              Spacer(),
            ],
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  ///Main content
  CustomScrollView buildExpandedCustomScrollView(
      bool _darkTheme,
      List<Note> _pinnedNotesInThisFolder,
      List<Note> _notPinnedNotesInThisFolder) {
    return CustomScrollView(
      controller: _hideButtonController,
      slivers: <Widget>[
        //this is just for the word 'PINNED'
        _buildBoxAdaptorForPinned(_pinnedNotesInThisFolder, _darkTheme),
        //this is for pinned notes
        _buildNotesGrid(_pinnedNotesInThisFolder),
        //this is just for the word 'OTHERS'
        _pinnedNotesInThisFolder.length > 0
            ? _buildBoxAdaptorForOthers(_notPinnedNotesInThisFolder, _darkTheme)
            : SliverToBoxAdapter(child: Container()),
        //this is for no pinned notes.
        _buildNotesGrid(_notPinnedNotesInThisFolder),
      ],
    );
  }

  Widget _buildBoxAdaptorForPinned(List<Note> notes, bool _darkTheme) {
    return SliverToBoxAdapter(
      child: notes.length == 0
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10),
              child: Row(
                children: [
                  SmallContainerFolderName(text: 'PINNED'),
                ],
              ),
            ),
    );
  }

  Widget _buildBoxAdaptorForOthers(List<Note> notes, bool _darkTheme) {
    return SliverToBoxAdapter(
      child: notes.length == 0
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Row(
                children: [SmallContainerFolderName(text: 'OTHERS')],
              )),
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
              return _slidableItem(note);
            }));
  }

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
            folder: folder,
            folders: folders,
          );
        },
        openElevation: 0,
        openColor: Colors.transparent,
        openBuilder: (BuildContext context, VoidCallback _) {
          return AddNoteScreen(
              database: database, note: note, folder: folder, folders: folders);
        },
      ),
      actions: <Widget>[
        IconSlideAction(
          foregroundColor: _darkTheme ? Colors.lightBlueAccent : Colors.blue,
          caption: 'Move',
          color: _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
          icon: EvaIcons.folderOutline,
          onTap: () => _move(note, context),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          foregroundColor: _darkTheme ? Colors.redAccent : Colors.red,
          caption: 'Delete',
          color: _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
          icon: EvaIcons.trash2Outline,
          onTap: () => _delete(database, note),
        ),
      ],
    );
  }

  void _move(Note note, BuildContext context) async {
    await showCupertinoModalBottomSheet(
        expand: true,
        context: context,
        // backgroundColor: _darkTheme?
        builder: (context, scrollController) => MoveFolderScreen(
              database: database,
              note: note,
            ));
  }

  ///https://stackoverflow.com/questions/54617432/looking-up-a-deactivated-widgets-ancestor-is-unsafe
  ///
  Future<void> _delete(Database database, Note note) async {
    setState(() {
      _addButtonVisible = false;
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
              // Navigator.of(context).pop();
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
      padding: const EdgeInsets.all(8),
      borderRadius: 15,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundGradient: KFlushBarGradient,
      duration: Duration(seconds: 4),
      icon: Icon(
        EvaIcons.trash2Outline,
        color: Colors.white,
      ),
      titleText: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(
          'Deleted: ',
          style: KFlushBarTitle,
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(left: 3.0),
        child: Text(note.title.isEmpty ? note.description : note.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: KFlushBarMessage),
      ),
    )..show(context).then((value) => setState(() {
          _addButtonVisible = true;
        }));
  }
}

/// original: making an appbar
// Widget _topRow(List<Note> notes) {
//   final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
//   bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//   return Container(
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(5.0),
//       color: _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
//       boxShadow: [
//         BoxShadow(
//           color: _darkTheme ? Colors.black45 : darkThemeDrawer,
//           offset: Offset(0.0, 1.0), //(x,y)
//           blurRadius: 5.0,
//         ),
//       ],
//     ),
//     child: Column(
//       children: <Widget>[
//         //this is to make top bar color cover all
//         MyTopSizedBox(),
//         SizedBox(
//           height: 50,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               IconButton(
//                   icon: Icon(Icons.arrow_back_ios, size: 30),
//                   onPressed: () => Navigator.pop(context)),
//               Text(folder.title,
//                   style: Theme.of(context).textTheme.headline6),
//               Padding(
//                 padding: const EdgeInsets.only(right: 8.0),
//                 child: Opacity(
//                   opacity: notes.length > 1 ? 1 : 0,
//                   child: IconButton(
//                     icon: Icon(
//                       axisCount == 2
//                           ? MyCustomIcon.menu_outline
//                           : MyCustomIcon.th_large_outline,
//                       size: 22,
//                       color: _darkTheme ? darkThemeButton : lightThemeButton,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         axisCount = axisCount == 2 ? 4 : 2;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
//if there is error, still want to show top row, this one does not have toggle view button
// Widget _topErrorRow() {
//   final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
//   bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//   return Column(
//     children: <Widget>[
//       SizedBox(
//         height: 35,
//         child: Container(
//           color: _darkTheme ? darkThemeDrawer : lightThemeAppBar,
//         ),
//       ),
//       Container(
//         height: 50,
//         color: _darkTheme ? darkThemeDrawer : lightThemeAppBar,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             IconButton(
//                 icon: Icon(Icons.arrow_back_ios),
//                 onPressed: () => Navigator.pop(context)),
//             Text(folder.title, style: Theme.of(context).textTheme.headline6),
//             Padding(
//               padding: const EdgeInsets.only(right: 8.0),
//               child: Opacity(
//                 opacity: 0,
//                 child: IconButton(
//                   icon: Icon(
//                     axisCount == 2
//                         ? MyCustomIcon.menu_outline
//                         : MyCustomIcon.th_large_outline,
//                     size: 20,
//                     color: _darkTheme ? Colors.white : lightThemeButton,
//                   ),
//                   onPressed: () {},
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }
