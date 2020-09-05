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

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    Key key,
    @required this.todo,
    this.onTap,
    this.onPressed,
    this.onChangedCheckbox,
    this.alarmText,
  }) : super(key: key);
  final Todo todo;
  final VoidCallback onTap;
  final VoidCallback onPressed;
  final Function onChangedCheckbox;
  final String alarmText;

//  List _categories = [
//    'Focus', //0
//    'Work', //1
//    'Home', //2
//    'Shopping', //3
//    'Others' //4
//  ];

  //this is for dark them only
  Color getColor() {
    if (todo.category == 0 || todo.category == null) {
      return todo.isDone
          ? Colors.white.withOpacity(0.5)
          : Colors.orangeAccent; //;
    } else if (todo.category == 1) {
      return todo.isDone
          ? Colors.white.withOpacity(0.5)
          : Colors.lightBlueAccent;
    } else if (todo.category == 2) {
      return todo.isDone ? Colors.white.withOpacity(0.5) : Colors.purpleAccent;
    } else if (todo.category == 3) {
      return todo.isDone
          ? Colors.white.withOpacity(0.5)
          : Colors.lightGreenAccent;
    } else if (todo.category == 4) {
      return todo.isDone
          ? Colors.white.withOpacity(0.5)
          : Colors.deepPurpleAccent;
    } else {
      return todo.isDone
          ? Colors.white.withOpacity(0.5)
          : Colors.deepPurpleAccent;
    }
  }

  Color getColorLight() {
    if (todo.category == 0 || todo.category == null) {
      return todo.isDone ? lightThemeWords.withOpacity(0.5) : Colors.orange; //;
    } else if (todo.category == 1) {
      return todo.isDone ? lightThemeWords.withOpacity(0.5) : Colors.blueAccent;
    } else if (todo.category == 2) {
      return todo.isDone
          ? lightThemeWords.withOpacity(0.5)
          : Colors.purpleAccent;
    } else if (todo.category == 3) {
      return todo.isDone ? lightThemeWords.withOpacity(0.5) : Colors.green;
    } else if (todo.category == 4) {
      return todo.isDone
          ? lightThemeWords.withOpacity(0.5)
          : Colors.deepPurpleAccent;
    } else {
      return todo.isDone
          ? lightThemeWords.withOpacity(0.5)
          : Colors.deepPurpleAccent;
    }
  }

  Widget getIcon() {
    if (todo.category == 0 || todo.category == null) {
//      return Icon(Icons.timer); //clock-outline
//      return Icon(EvaIcons.clockOutline); //clock-outline, bulb-outline
      return Icon(EvaIcons.bulbOutline);
    } else if (todo.category == 1) {
      return Icon(EvaIcons.briefcaseOutline);
    } else if (todo.category == 2) {
      return Icon(EvaIcons.homeOutline);
    } else if (todo.category == 3) {
      return Icon(EvaIcons.shoppingCartOutline); //list-outline
    } else {
      return Icon(EvaIcons.listOutline);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    return ListTile(
      leading: Theme(
        data: ThemeData(
            unselectedWidgetColor:
                _darkTheme ? getColor() : getColorLight()), //Colors.grey[350]
        child: Checkbox(
            activeColor: Colors.transparent, //black54
            checkColor: _darkTheme
                ? Colors.white.withOpacity(0.5)
                : lightThemeWords.withOpacity(0.5),
            value: todo.isDone ? true : false,
            onChanged: onChangedCheckbox),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: AutoSizeText(todo.title,
                maxLines: 3,
                maxFontSize: 18,
                minFontSize: 15,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _darkTheme ? Colors.white : Colors.black87,
                  fontSize: 18.0,
                  //1 means is done
                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                )),
          ),

          /// if we want to change here, we have to add a property of reminder date in Todo
          todo.hasReminder == null || todo.hasReminder == false
              ? Container()
              : todo.reminderDate.difference(DateTime.now()).inSeconds > 0
                  ? Icon(Icons.alarm,
                      color:
                          _darkTheme ? Colors.yellowAccent : Colors.yellow[500],
                      size: 22)
                  : Icon(Icons.alarm_off,
                      color: _darkTheme
                          ? Colors.grey
                          : Colors.grey.withOpacity(0.8),
                      size: 22)
        ],
      ),
      subtitle: todo.comment == null || todo.comment.length == 0
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 5.0, top: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
//              textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Icon(
                    Icons.comment,
                    size: 15,
                    color: _darkTheme ? darkThemeHint : lightThemeHint,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(todo.comment,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _darkTheme
                              ? Color(0xfff3f9fb)
                              : Color(0xF01b262c),
                          decoration:
                              todo.isDone ? TextDecoration.lineThrough : null,
                        )),
                  )
                ],
              ),
            ),
      trailing: IconButton(
        color: _darkTheme ? getColor() : getColorLight(),
        icon: getIcon(),
        onPressed: onPressed,
      ),
      onTap: onTap,
    );
  }
}

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
          data: ThemeData(unselectedWidgetColor: Colors.grey[350]),
          child: Checkbox(
            activeColor: Colors.transparent,
            checkColor: Colors.grey[350],
            value: todo.isDone ? true : false,
            onChanged: onChangedCheckbox,
          )),
      title: AutoSizeText(
        todo.title,
        maxLines: 4,
        maxFontSize: 25,
        overflow: TextOverflow.ellipsis,
        minFontSize: 20,
        textAlign: TextAlign.center,
        style: GoogleFonts.varelaRound(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 25.0,
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        color: Colors.grey[350],
        iconSize: 18,
//        icon: Icon(FontAwesomeIcons.edit),
        icon: Icon(Icons.clear),
        onPressed: onPressed,
        tooltip: 'Delete Task',
      ),
      onTap: onTap,
    );
  }
}

class FolderListTile extends StatelessWidget {
  const FolderListTile({
    Key key,
    @required this.folder,
    this.onTap,
  }) : super(key: key);
  final Folder folder;
  final VoidCallback onTap;

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
        maxFontSize: 35,
        minFontSize: 30,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 35.0,
        ),
      ),
      onTap: onTap,
    );
  }
}

class MantraListTile extends StatelessWidget {
  const MantraListTile({
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
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return ListTile(
      title: AutoSizeText(mantra.title,
          maxLines: 3,
          maxFontSize: 20,
          minFontSize: 15,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _darkTheme ? Colors.white : Color(0xF01b262c),
            fontSize: 20.0,
          )),
      onTap: onTap,
    );
  }
}

class QuoteListTile extends StatelessWidget {
  const QuoteListTile({
    Key key,
    @required this.quote,
    this.onTap,
    this.onPressed,
  }) : super(key: key);
  final QuoteModel quote;
  final VoidCallback onTap;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return ListTile(
      title: AutoSizeText(
          quote.author == null || quote.author == ''
              ? '"${quote.title}"'
              : '"${quote.title} -- ${quote.author}"',
          maxLines: 3,
          maxFontSize: 20,
          minFontSize: 15,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: _darkTheme ? Colors.white : Color(0xF01b262c),
              fontSize: 20.0,
              fontStyle: FontStyle.italic)),
      onTap: onTap,
    );
  }
}
