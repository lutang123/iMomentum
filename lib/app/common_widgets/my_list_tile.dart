import 'package:auto_size_text/auto_size_text.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/models/mantra_model.dart';
import 'package:iMomentum/app/models/quote_model.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

class HomeTodoListTile extends StatelessWidget {
  const HomeTodoListTile({
    Key key,
    @required this.todo,
    this.onTap,
    this.onPressed,
    this.onChangedCheckbox,
  }) : super(key: key);
  final Todo todo;
  final VoidCallback onTap;
  final VoidCallback onPressed;
  final Function onChangedCheckbox;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Theme(
          data: ThemeData(unselectedWidgetColor: Colors.grey[200]),
          child: Checkbox(
            activeColor: Colors.transparent,
            checkColor: Colors.grey[200],
            value: todo.isDone ? true : false,
            onChanged: onChangedCheckbox,
          )),
      title: AutoSizeText(
        todo.title,
        maxLines: 4, // do not chang this
        maxFontSize: 25,
        overflow: TextOverflow.ellipsis,
        minFontSize: 18,
        textAlign: TextAlign.center,
        style: GoogleFonts.varelaRound(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 25.0,
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        color: Colors.white60,
        // iconSize: 18,
        icon: Icon(Icons.clear),
        onPressed: onPressed,
        tooltip: 'Delete Task',
      ),
      onTap: onTap,
    );
  }
}

class FolderListTile extends StatelessWidget {
  const FolderListTile(
      {Key key, @required this.folder, this.onTap, this.onPressed})
      : super(key: key);
  final Folder folder;
  final VoidCallback onTap;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    return ListTile(
      leading: Icon(EvaIcons.folderOutline,
          color: _darkTheme ? darkThemeButton : lightThemeButton),
      title: AutoSizeText(
        folder.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        minFontSize: 14,
        style: TextStyle(
          color: _darkTheme ? darkThemeWords : lightThemeWords,
          fontSize: 16.0,
        ),
      ),
      onTap: onTap,
    );
  }
}

class HomeMantraListTile extends StatelessWidget {
  const HomeMantraListTile({
    Key key,
    @required this.mantra,
    this.onTap,
    this.onPressed,
  }) : super(key: key);
  final MantraModel mantra;
  final VoidCallback onTap;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //this automatically gives title some padding
      title: AutoSizeText(
        mantra.title,
        maxLines: 3,
        maxFontSize: 33,
        minFontSize: 24,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 33.0,
        ),
      ),
      onTap: onTap,
    );
  }
}

class MantraList extends StatelessWidget {
  const MantraList({
    Key key,
    @required this.text,
    this.onTap,
  }) : super(key: key);
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: AutoSizeText(text,
            maxLines: 3,
            maxFontSize: 18,
            minFontSize: 16,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _darkTheme ? darkThemeWords : lightThemeWords,
              fontSize: 18.0,
            )),
      ),
    );
  }
}
