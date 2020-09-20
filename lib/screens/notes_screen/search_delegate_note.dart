import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/notes_screen/notes_search_result.dart';
import 'package:provider/provider.dart';

//textInputAction: TextInputAction.search,
class SearchNote extends SearchDelegate<Note> {
  SearchNote({this.notes, this.folders, this.database});
  final List<Note> notes;
  final List<Folder> folders;
  final Database database;

  List<Note> filteredNotes = [];

  @override
  ThemeData appBarTheme(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    assert(context != null);
    final ThemeData theme = Theme.of(context).copyWith(
        cursorColor: _darkTheme ? darkThemeHint : lightThemeHint,
        hintColor: _darkTheme ? darkThemeHint : lightThemeHint,
        primaryColor: _darkTheme
            ? darkThemeNoPhotoColor
            : lightThemeNoPhotoColor, //no change
        textTheme: TextTheme(
          headline6: TextStyle(
              color: _darkTheme ? darkThemeWords : lightThemeWords,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ));
    assert(theme != null);
    return theme;
  }

  @override
  Widget buildLeading(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: _darkTheme ? Colors.white : lightThemeButton,
        size: 30,
      ),
      onPressed: () {
        // Navigator.of(context).pop();
        close(context, null);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return [
      query == '' || query == null
          ? Container()
          : IconButton(
              icon: Icon(
                Icons.clear,
                color: _darkTheme ? Colors.white70 : lightThemeButton,
              ),

              ///this query is pre-built, not need to create a query variable
              onPressed: () => query = '',
            )
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == '' || query == null) {
      return searchStartContent(context);
    } else {
      return NotesSearchResult(
        database: database,
        folders: folders,
        query: query,
      );
    }
  }

  Widget searchStartContent(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
      color: _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 50,
            height: 50,
            child: Icon(
              Icons.search,
              size: 50,
              color: _darkTheme ? darkThemeButton : lightThemeButton,
            ),
          ),
          Text(
            'Enter a keywords to search.',
            style:
                TextStyle(color: _darkTheme ? darkThemeWords : lightThemeWords),
          )
        ],
      )),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == '' || query == null) {
      return searchStartContent(context);
    } else {
      return NotesSearchResult(
        database: database,
        folders: folders,
        query: query,
      );
    }
  }
}
