import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';
import 'package:iMomentum/app/utils/extension_firstCaps.dart';

class MyStatefulDialog extends StatefulWidget {
  final Database database;

  const MyStatefulDialog({Key key, this.database}) : super(key: key);

  @override
  _MyStatefulDialogState createState() => _MyStatefulDialogState();
}

class _MyStatefulDialogState extends State<MyStatefulDialog> {
  String _newFolderName = '';
  bool _isFolderNameEmpty = true;
  final _formKey = GlobalKey<FormState>();

  Database get database => widget.database;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        contentPadding: EdgeInsets.only(top: 10.0),
        backgroundColor:
            _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: buildColumnTitle(_darkTheme),
        content: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildTextFormFolder(_darkTheme, setState),
                buildFormButton(_darkTheme, context),
              ],
            ),
          ),
        ),
      );
    });
  }

  Padding buildFormButton(bool _darkTheme, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlatButton(
              child: Text(
                'Cancel',
                style: GoogleFonts.varelaRound(
                  fontSize: 18,
                  color: _darkTheme ? darkThemeWords : lightThemeWords,
                  fontWeight: FontWeight.w600,
                ),
              ),
              shape: _isFolderNameEmpty
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(68.0),
                      side: BorderSide(
                          color: _darkTheme ? darkThemeHint : lightThemeHint,
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
                  color: _darkTheme ? darkThemeWords : lightThemeWords,
                  fontWeight: FontWeight.w600,
                ),
              ),
              shape: _isFolderNameEmpty
                  ? null
                  : RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(68.0),
                      side: BorderSide(
                          color: _darkTheme ? darkThemeHint : lightThemeHint,
                          width: 1.0)),
              onPressed: () => _addFolder(context, database)),
        ],
      ),
    );
  }

  Padding buildTextFormFolder(bool _darkTheme, StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        keyboardAppearance: _darkTheme ? Brightness.dark : Brightness.light,
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
        validator: (value) =>
            (value.isNotEmpty) ? null : 'Folder name can not be empty',
        onSaved: (value) {
          _newFolderName = value.firstCaps;
        },
        style: TextStyle(
            fontSize: 20.0,
            color: _darkTheme ? darkThemeWords : lightThemeWords),
        autofocus: true,
        cursorColor: _darkTheme ? darkThemeHint2 : lightThemeHint2,
        decoration: InputDecoration(
          focusedBorder: buildUnderlineInputBorder(_darkTheme),
          enabledBorder: buildUnderlineInputBorder(_darkTheme),
        ),
      ),
    );
  }

  UnderlineInputBorder buildUnderlineInputBorder(bool _darkTheme) {
    return UnderlineInputBorder(
      borderSide:
          BorderSide(color: _darkTheme ? darkThemeHint : lightThemeHint),
    );
  }

  Column buildColumnTitle(bool _darkTheme) {
    return Column(
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
    );
  }

  /// only allow unique name for folder, and can not be notes or all notes
  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
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
