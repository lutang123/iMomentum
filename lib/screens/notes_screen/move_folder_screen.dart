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
    this.database,
    // this.folders,
    this.note,
  });
  final Database database;
  // final List<Folder> folders;
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
    return CustomizedBottomSheet(
      color: _darkTheme ? darkThemeAdd : lightThemeAdd,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 20),
          Text('Select a folder', style: Theme.of(context).textTheme.headline5),

          ///why after adding new folder the list showing multi times??
          ///because default folder must inside StreamBuilder.
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
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
          SizedBox(height: 20)
        ],
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
          );
        });
  }

  ///move
  Future<void> _move(Database database, Note note, Folder folder) async {
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
    await showDialog(
      context: context,
      builder: (BuildContext _) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(top: 10.0),
            backgroundColor: Color(0xf01b262c),
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
                Row(
                  children: [
                    Text(
                      'Enter a name for this folder.',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white60,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
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
                        style: TextStyle(fontSize: 20.0, color: Colors.white70),
                        autofocus: true,
                        cursorColor: Colors.white70,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: darkThemeHint),
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: darkThemeHint,
                          )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                      borderRadius: BorderRadius.circular(68.0),
                                      side: BorderSide(
                                          color: Colors.white70, width: 2.0))
                                  : null,
                              onPressed: () => Navigator.of(context).pop()),
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
                                      borderRadius: BorderRadius.circular(68.0),
                                      side: BorderSide(
                                          color: Colors.white70, width: 2.0)),
                              onPressed: () => _addFolder(context, database)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
