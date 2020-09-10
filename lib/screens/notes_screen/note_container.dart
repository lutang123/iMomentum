import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/notes_screen/color_picker.dart';
import 'package:provider/provider.dart';
import 'font_picker.dart';

class NoteContainer extends StatelessWidget {
  NoteContainer(
      {this.note, this.database, this.folder, this.folders, this.onTap});
  final Note note;
  final Database database;
  final Folder folder;
  final List<Folder> folders;
  final Function onTap;

  String _getFolderTitle(List<Folder> folders) {
    String title = '';
    for (Folder folder in folders) {
      if (folder.id == note.folderId) {
        title = folder.title;
      }
    }
    return title;
  }

  final String myFont = fontList[0];

  @override
  Widget build(BuildContext context) {
//    print('note.colorIndex: ${note.colorIndex}'); //null?
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: note.colorIndex != null
                ? _darkTheme
                    ? colorsDark[note.colorIndex]
                    : colorsLight[note.colorIndex]
                : _darkTheme ? colorsDark[0] : colorsLight[0],
            border: Border.all(
                width: 2, color: _darkTheme ? Colors.white54 : Colors.black54),
            borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: <Widget>[
            note.title == null || note.title == ''
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(note.title,
                            style: GoogleFonts.getFont(note.fontFamily,
                                color: _darkTheme
                                    ? darkThemeWords
                                    : lightThemeWords,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
            note.description == null || note.description == ''
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          note.description,
                          style: GoogleFonts.getFont(
                            // e.g. 'Crafty Girls',
                            note.fontFamily,
                            color:
                                _darkTheme ? darkThemeWords : lightThemeWords,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 7,
                        ),
                      ),
                      //visible: _showAll,
                    ],
                  ),
            folder.id == 0.toString()
                ? Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //this is the folder we passed, if the folder is All notes,
                        // how do we display folder
                        SmallContainer(text: _getFolderTitle(folders))
                      ],
                    ),
                  )
//                : folder == null || folder.id == note.folderId
                : Container(),
          ],
        ),
      ),
    );
  }
}

class MySignInContainer extends StatelessWidget {
  const MySignInContainer({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
      child: child,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: _darkTheme ? darkThemeSurface : lightThemeSurface,
          border: Border.all(
              width: 2, color: _darkTheme ? Colors.white54 : Colors.black38),
          borderRadius: BorderRadius.circular(20.0)),
    );
  }
}
