import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_fab.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/screens/iNotes/notes_model/notes_db_helper.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/screens/iNotes/notes_screen/search_note.dart';
import 'package:iMomentum/screens/iTodo/todo_screen/ReorderableNote.dart';
import 'package:iMomentum/screens/iTodo/todo_screen/build_note_container.dart';
import 'package:iMomentum/screens/jobs/empty_content.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'add_note_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:reorderables/reorderables.dart';

class NotesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotesScreenState();
  }
}

class NotesScreenState extends State<NotesScreen> {
  int axisCount = 2;
  @override
  void initState() {
//    updateListView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.network(Constants.homePageImage, fit: BoxFit.cover),
        ContainerLinearGradient(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: StreamBuilder<List<Note>>(
              stream: database
                  .notesStream(), // print(database.todosStream());//Instance of '_MapStream<QuerySnapshot, List<TodoModel>>'
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Note> notes = snapshot.data;
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 10),
                                child: Container(
                                    decoration: KBoxDecorationNotes,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            IconButton(
                                              iconSize: 35,
                                              icon: Icon(
                                                Icons.search,
                                              ),
                                              onPressed: () =>
                                                  _search(database, notes),
                                            ),
                                            FlatButton(
                                              child: Text(
                                                'Search your notes',
                                                style: KNoteDescription,
                                              ),
                                              onPressed: () =>
                                                  _search(database, notes),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            IconButton(
                                              iconSize: 35,
                                              icon: Icon(
                                                axisCount == 2
                                                    ? Icons.list
                                                    : Icons.grid_on,
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
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
                        ErrorMessage(
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
        Stack(
          overflow: Overflow.visible,
          alignment: FractionalOffset(0.93, .87),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: MyFAB(heroTag: "btn2", onPressed: () => _add(database)),
            ),
          ],
        ),
      ],
    );
  }

  Widget getNotesList(List<Note> notes) {
    final database = Provider.of<Database>(context, listen: false);
    return StaggeredGridView.countBuilder(
        staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        physics: BouncingScrollPhysics(),
        crossAxisCount: 4,
        itemCount: notes.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final note = notes[index];
          return BuildNoteContainer(
              note: note,
              database: database,
              onTap: () => _onTap(database, note),
              onLongPress: () => _delete(context, note));
        });
  }

  Future<void> _search(Database database, List<Note> notes) async {
    final Note result =
        await showSearch(context: context, delegate: NotesSearch(notes: notes));
    if (result != null) {
      navigateToDetail(database: database, note: result);
    }
  }

  ///for fab, add new
  void _add(Database database) => navigateToDetail(database: database);

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
//    final deleteSnackBar = MySnackBar(
//      text: 'deleted note',
//      actionText: 'undo',
//      onTap: null, //TODO
//    ) as SnackBar;
//    Scaffold.of(context).showSnackBar(deleteSnackBar);
  }

  void navigateToDetail({Database database, Note note}) =>
      showCupertinoModalBottomSheet(
        useRootNavigator: true,
        expand: true,
        context: context,
        backgroundColor: Colors.black, //this does not change
        builder: (context, scrollController) => AddNoteScreen(
            database: database, note: note, scrollController: scrollController),
      );
}
