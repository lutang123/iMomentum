import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/common_widgets/empty_and_error_content.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_list_tile.dart';
import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
import 'package:iMomentum/app/constants/my_strings.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:flutter/services.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:provider/provider.dart';
import 'package:iMomentum/app/utils/extension_firstCaps.dart';

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
  final _formKey = GlobalKey<FormState>();

  ///need to add
//  bool processing;

  String title;

  // List<Folder> get folders => widget.folders;
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
            SizedBox(height: 20),
            Row(
              children: [
                Opacity(
                  opacity: 0.0,
                  child: IconButton(onPressed: null, icon: Icon(Icons.clear)),
                ),
                Spacer(),
                Text('Select a folder',
                    style: TextStyle(
                      fontSize: 23,
                      color: _darkTheme ? darkThemeWords : lightThemeWords,
                      fontWeight: FontWeight.w600,
                    )),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.clear),
                      color: _darkTheme ? darkThemeHint : lightThemeHint),
                ),
              ],
            ),

            ///why after adding new folder the list showing multi times??
            ///because default folder must inside StreamBuilder.
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  FlatButton(
                      child: Text(
                        'Add New',
                        style: TextStyle(
                            fontSize: 16,
                            color: _darkTheme
                                ? Colors.lightBlueAccent
                                : lightThemeButton,
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic),
                      ),
                      onPressed: () => _showAddDialog(database)),
                ],
              ),
            ),
            StreamBuilder<List<Folder>>(
              stream: database
                  .foldersStream(), // print(database.todosStream());//Instance of '_MapStream<QuerySnapshot, List<TodoModel>>'
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Folder> folders = snapshot.data;
                  final List<Folder> defaultFolders = [
                    Folder(id: 1.toString(), title: 'Notes'),
                  ];
                  if (folders.isNotEmpty) {
                    final List<Folder> finalFolders = defaultFolders
                      ..addAll(folders);
                    //this StreamBuilder is only to find out how many notes in a folder
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: _buildFolderListView(note, finalFolders),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: _buildFolderListView(note, defaultFolders),
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  print(
                      'snapshot.hasError in folder stream: ${snapshot.error.toString()}');
                  return Expanded(
                      child: EmptyOrError(
                          text: '',
                          tips: Strings.textError,
                          textTap: Strings.textErrorOnTap,
                          //Todo contact us
                          onTap: null));
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
            SizedBox(height: 50)
          ],
        ),
      ),
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
            // onPressed: () => _showEditDialog(database, folders[index]),
          );
        });
  }

  ///move
  Future<void> _move(Database database, Note note, Folder folder) async {
    //
    print('folder.id: ${folder.id}');
    print('note.folderId: ${note.folderId}');
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

  String _newFolderName = '';
  bool _isFolderNameEmpty = true;
  void _showAddDialog(Database database) async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext _) {
        ///this StatefulBuilder has a context that can be used in addFolder and cancel
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(top: 10.0),
            backgroundColor:
                _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Column(
              children: <Widget>[
                Text("New Folder",
                    style: TextStyle(
                      fontSize: 20,
                      color: _darkTheme ? darkThemeWords : lightThemeWords,
                    )),
                SizedBox(height: 15),
                Text(
                  'Enter a name for this folder.',
                  style: TextStyle(
                      fontSize: 16,
                      color: _darkTheme ? darkThemeHint : lightThemeHint,
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
                        keyboardAppearance:
                            _darkTheme ? Brightness.dark : Brightness.light,
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
                        style: TextStyle(
                            fontSize: 20.0,
                            color:
                                _darkTheme ? darkThemeWords : lightThemeWords),
                        autofocus: true,
                        cursorColor:
                            _darkTheme ? darkThemeHint2 : lightThemeHint2,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: _darkTheme
                                    ? darkThemeHint
                                    : lightThemeHint),
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: _darkTheme ? darkThemeHint : lightThemeHint,
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
                                  color: _darkTheme
                                      ? darkThemeWords
                                      : lightThemeWords,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              shape: _isFolderNameEmpty
                                  ? RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(68.0),
                                      side: BorderSide(
                                          color: _darkTheme
                                              ? darkThemeHint
                                              : lightThemeHint,
                                          width: 1.0))
                                  : null,
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          FlatButton(
                              child: Text(
                                'Save',
                                style: GoogleFonts.varelaRound(
                                  fontSize: 18,
                                  color: _darkTheme
                                      ? darkThemeWords
                                      : lightThemeWords,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              shape: _isFolderNameEmpty
                                  ? null
                                  : RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(68.0),
                                      side: BorderSide(
                                          color: _darkTheme
                                              ? darkThemeHint
                                              : lightThemeHint,
                                          width: 1.0)),
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

  ///when we don't have BuildContext context, we used a wrong context and it popped to black screen
  void _addFolder(BuildContext context, Database database) async {
    if (_validateAndSaveForm()) {
      try {
        final folders = await database.foldersStream().first;
        final allNames =
            folders.map((folder) => folder.title.toLowerCase()).toList();
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
