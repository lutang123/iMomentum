import 'package:auto_size_text/auto_size_text.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

/// Note Card UI in List
///
class FolderContainer extends StatelessWidget {
  final Folder folder;
  final Function onTap;
  final int notesNumber;

  FolderContainer({this.folder, this.onTap, this.notesNumber});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    double height = MediaQuery.of(context)
        .size
        .height; //iPhone large: height: 180/896 = 0.2
    double width =
        MediaQuery.of(context).size.width; //iPhone large: width: 414,

    return Center(
      child: Container(
        height: height * 0.2,
        width: width * 0.4,
        margin: EdgeInsets.only(left: 8.0, right: 8),
        decoration: BoxDecoration(
          color: _darkTheme ? darkThemeDrawer : lightThemeDrawer,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Spacer(),
                      Icon(EvaIcons.bookOutline,
                          size: height > 700 ? 50 : 40,
                          color:
                              _darkTheme ? darkThemeButton : lightThemeButton),
                      // SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AutoSizeText(
                          folder.title ?? '',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          minFontSize: 18,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              color:
                                  _darkTheme ? Colors.white : lightThemeWords,
                              fontFamily: 'OpenSans'),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${notesNumber.toString()}',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
