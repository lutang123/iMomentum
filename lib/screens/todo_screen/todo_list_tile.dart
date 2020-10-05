import 'package:auto_size_text/auto_size_text.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/todo.dart';
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
//    'Focus (with Pomodoro Timer)', //0
//    'Work', //1
//    'Home', //2
//    'Shopping', //3
//    'Others' //4
//  ];

  //this is for dark them only
  Color getColor() {
    if (todo.category == 0 || todo.category == null) {
      return todo.isDone
          ? darkThemeWords.withOpacity(0.5)
          : Colors.orangeAccent; //;
    } else if (todo.category == 1) {
      return todo.isDone
          ? darkThemeWords.withOpacity(0.5)
          : Colors.lightBlueAccent;
    } else if (todo.category == 2) {
      return todo.isDone
          ? darkThemeWords.withOpacity(0.5)
          : Colors.purpleAccent;
    } else if (todo.category == 3) {
      return todo.isDone
          ? darkThemeWords.withOpacity(0.5)
          : Colors.lightGreenAccent;
    } else if (todo.category == 4) {
      return todo.isDone ? darkThemeWords.withOpacity(0.5) : Colors.pinkAccent;
    } else {
      return todo.isDone ? darkThemeWords.withOpacity(0.5) : Colors.brown;
    }
  }

  Color getColorLight() {
    if (todo.category == 0 || todo.category == null) {
      return todo.isDone ? lightThemeWords.withOpacity(0.5) : Colors.orange;
    } else if (todo.category == 1) {
      return todo.isDone ? lightThemeWords.withOpacity(0.5) : Colors.blue;
    } else if (todo.category == 2) {
      return todo.isDone ? lightThemeWords.withOpacity(0.5) : Colors.deepPurple;
    } else if (todo.category == 3) {
      return todo.isDone ? lightThemeWords.withOpacity(0.5) : Colors.green;
    } else if (todo.category == 4) {
      return todo.isDone ? lightThemeWords.withOpacity(0.5) : Colors.pink;
    } else {
      return todo.isDone ? lightThemeWords.withOpacity(0.5) : Colors.brown;
    }
  }

  Widget getIcon() {
    if (todo.category == 0 || todo.category == null) {
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
            unselectedWidgetColor: _darkTheme ? getColor() : getColorLight()),
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
                maxLines: 5,
                maxFontSize: 18,
                minFontSize: 15,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _darkTheme ? darkThemeWords : lightThemeWords,
                  fontSize: 18.0,
                  // 1 means is done
                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                )),
          ),

          /// if we want to change here, we have to add a property of reminder date in Todo
          todo.hasReminder == null || todo.hasReminder == false
              ? Container()
              : todo.reminderDate.difference(DateTime.now()).inSeconds > 0
                  ? Icon(Icons.alarm,
                      color: _darkTheme
                          ? Colors.yellowAccent
                          : Colors.teal.withOpacity(0.8),
                      // : Colors.lime.withOpacity(0.8),
                      size: 22)
                  : Icon(Icons.alarm_off,
                      color: _darkTheme
                          ? Colors.grey[400]
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
                            color: _darkTheme ? darkThemeHint : lightThemeHint,
                            decoration:
                                todo.isDone ? TextDecoration.lineThrough : null,
                            fontSize: 14)),
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
