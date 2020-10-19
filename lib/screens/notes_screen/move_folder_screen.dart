import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/add_screen_top_row.dart';
import 'package:iMomentum/app/common_widgets/empty_and_error_content.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_list_tile.dart';
import 'package:iMomentum/app/common_widgets/my_stateful_dialog.dart';
import 'package:iMomentum/app/constants/my_strings.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:flutter/services.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:provider/provider.dart';

class MoveFolderScreen extends StatefulWidget {
  const MoveFolderScreen({
    @required this.database,
    @required this.note,
  });
  final Database database;
  final Note note;

  @override
  _MoveFolderScreenState createState() => _MoveFolderScreenState();
}

class _MoveFolderScreenState extends State<MoveFolderScreen> {
  // final _formKey = GlobalKey<FormState>();
  String title;
  Database get database => widget.database;
  Note get note => widget.note;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Scaffold(
      body: CustomizedBottomSheet(
        color: _darkTheme ? darkThemeAdd : lightThemeAdd,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AddScreenTopRow(
              title: 'Select a folder',
            ),

            ///why after adding new folder the list showing multi times??
            ///because default folder must inside StreamBuilder.
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => _showAddDialog(database),
                    child: Text(
                      'Add New',
                      style: buildTextStyleAddNew(_darkTheme),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: buildStreamBuilder(),
              ),
            ),
            SizedBox(height: 50)
          ],
        ),
      ),
    );
  }

  TextStyle buildTextStyleAddNew(bool _darkTheme) {
    return TextStyle(
        fontSize: 16,
        color: _darkTheme ? Colors.lightBlueAccent : lightThemeButton,
        decoration: TextDecoration.underline,
        fontStyle: FontStyle.italic);
  }

  StreamBuilder<List<Folder>> buildStreamBuilder() {
    return StreamBuilder<List<Folder>>(
      stream: database
          .foldersStream(), // print(database.todosStream());//Instance of '_MapStream<QuerySnapshot, List<TodoModel>>'
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Folder> folders = snapshot.data;
          final List<Folder> defaultFolders = [
            Folder(id: 1.toString(), title: 'Notes'),
          ];
          if (folders.isNotEmpty) {
            final List<Folder> finalFolders = defaultFolders..addAll(folders);
            //this StreamBuilder is only to find out how many notes in a folder
            return _buildFolderListView(note, finalFolders);
          } else {
            return _buildFolderListView(note, defaultFolders);
          }
        } else if (snapshot.hasError) {
          print(
              'snapshot.hasError in folder stream: ${snapshot.error.toString()}');
          return EmptyOrError(text: '', error: Strings.streamErrorMessage);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildFolderListView(Note note, List<Folder> folders) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return ListView.separated(
        itemCount: folders.length,
        separatorBuilder: (context, index) => Divider(
            indent: 15,
            endIndent: 15,
            height: 0.5,
            color: _darkTheme ? darkThemeDivider : lightThemeDivider),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return FolderListTile(
            folder: folders[index],
            onTap: () => _move(database, note, folders[index]),
          );
        });
  }

  ///move
  Future<void> _move(Database database, Note note, Folder folder) async {
    // print('folder.id: ${folder.id}');
    // print('note.folderId: ${note.folderId}');
    try {
      note.folderId = folder.id;
      await database.setNote(note);
      Navigator.pop(context);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  // String _newFolderName = '';
  // bool _isFolderNameEmpty = true;
  void _showAddDialog(Database database) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext _) {
        ///this StatefulBuilder has a context that can be used in addFolder and cancel
        return MyStatefulDialog(database: database);
      },
    );
  }
}
