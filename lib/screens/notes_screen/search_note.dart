import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/screens/notes_screen/search_result.dart';

//textInputAction: TextInputAction.search,
class SearchNote extends SearchDelegate<Note> {
  SearchNote({this.notes, this.folders, this.database});
  final List<Note> notes;
  final List<Folder> folders;
  final Database database;

  List<Note> filteredNotes = [];
  String query;

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context).copyWith(
        hintColor: Colors.white,
        primaryColor: darkThemeNoPhotoBkgdColor, //no change
        textTheme: TextTheme(
          headline6: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ));
    assert(theme != null);
    return theme;
  }

//  @override
//  ThemeData bodyTheme(BuildContext context) {
//    assert(context != null);
//    final ThemeData theme = Theme.of(context).copyWith(
//        hintColor: Colors.white,
//        primaryColor: Colors.transparent,
//        textTheme: TextTheme(
//          headline6: TextStyle(
//              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
//        ));
//    assert(theme != null);
//    return theme;
//  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
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
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.white70,
        ),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchResult(
      database: database,
      folders: folders,
      query: query,
    );
  }

  // @override
  // Widget buildResults(BuildContext context) {
  //   if (query == '') {
  //     return Container(
  //       color: Colors.transparent,
  //       child: Center(
  //           child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           SizedBox(
  //             width: 50,
  //             height: 50,
  //             child: Icon(
  //               Icons.search,
  //               size: 50,
  //               color: Colors.white,
  //             ),
  //           ),
  //           Text(
  //             'Enter a keywords to search.',
  //             style: TextStyle(color: Colors.white),
  //           )
  //         ],
  //       )),
  //     );
  //   } else {
  //     filteredNotes = getFilteredList(notes);
  //     if (filteredNotes.length == 0) {
  //       return Container(
  //         color: Colors.transparent,
  //         child: Center(
  //             child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             SizedBox(
  //               width: 50,
  //               height: 50,
  //               child: Icon(
  //                 Icons.sentiment_dissatisfied,
  //                 size: 50,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             Text(
  //               'No results found',
  //               style: TextStyle(color: Colors.black),
  //             )
  //           ],
  //         )),
  //       );
  //     } else {
  //       return Container(
  //         color: Colors.white,
  //         child: ListView.builder(
  //           itemCount: filteredNotes.length == null ? 0 : filteredNotes.length,
  //           itemBuilder: (context, index) {
  //             return ListTile(
  //               leading: Icon(
  //                 Icons.note,
  //                 color: Colors.black,
  //               ),
  //               title: Text(
  //                 filteredNotes[index].title,
  //                 style: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 18.0,
  //                     color: Colors.black),
  //               ),
  //               subtitle: Text(
  //                 filteredNotes[index].description,
  //                 style: TextStyle(fontSize: 14.0, color: Colors.grey),
  //               ),
  //               onTap: () {
  //                 close(context, filteredNotes[index]);
  //               },
  //             );
  //           },
  //         ),
  //       );
  //     }
  //   }
  // }

  List<Note> getFilteredList(List<Note> notes) {
    notes.forEach((note) {
      if (note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.description.toLowerCase().contains(query.toLowerCase()))
        filteredNotes.add(note);
    });
    print('filteredNotes: $filteredNotes');
    return filteredNotes;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == '') {
      return Container(
        color: Colors.white,
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
                color: Colors.black,
              ),
            ),
            Text(
              'Enter a keywords to search.',
              style: TextStyle(color: Colors.black),
            )
          ],
        )),
      );
    } else {
      filteredNotes = getFilteredList(notes);
      if (filteredNotes.length == 0) {
        return Container(
          color: Colors.white,
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.sentiment_dissatisfied,
                  size: 50,
                  color: Colors.black,
                ),
              ),
              Text(
                'No results found',
                style: TextStyle(color: Colors.black),
              )
            ],
          )),
        );
      } else {
        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: filteredNotes.length == null ? 0 : filteredNotes.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(
                  Icons.note,
                  color: Colors.black,
                ),
                title: Text(
                  filteredNotes[index].title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black),
                ),
                subtitle: Text(
                  filteredNotes[index].description,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                onTap: () {
                  close(context, filteredNotes[index]);
                },
              );
            },
          ),
        );
      }
    }
  }
}
