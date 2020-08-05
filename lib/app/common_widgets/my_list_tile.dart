import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/models/mantra_model.dart';
import 'package:iMomentum/app/models/quote_model.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/services/calendar_bloc.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    Key key,
    @required this.todo,
    this.todoDuration,
    this.onTap,
    this.onPressed,
    this.onChangedCheckbox,
  }) : super(key: key);
  final Todo todo;
  final TodoDuration todoDuration;
  final VoidCallback onTap;
  final VoidCallback onPressed;
  final Function onChangedCheckbox;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return ListTile(
      leading: Theme(
        data: ThemeData(unselectedWidgetColor: Colors.grey[350]),
        child: Checkbox(
            activeColor: Colors.transparent, //black54
            checkColor: _darkTheme ? Colors.grey[350] : lightButton,
            value: todo.isDone,
            onChanged: onChangedCheckbox),
      ),
      title: AutoSizeText(todo.title,
          maxLines: 4,
//          maxFontSize: 19,
          minFontSize: 15,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _darkTheme ? Colors.white : Color(0xF01b262c),
//            fontSize: 19.0,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          )),
      subtitle: todo.comment == null || todo.comment.length == 0
          ? null
          : Row(
              children: <Widget>[
                Icon(
                  Icons.comment,
                  size: 15,
                  color: _darkTheme ? Colors.white70 : lightButton,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(todo.comment,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _darkTheme ? Colors.white70 : Color(0xF01b262c),
                        decoration:
                            todo.isDone ? TextDecoration.lineThrough : null,
                      )),
                )
              ],
            ),
      trailing: IconButton(
        color: _darkTheme ? Colors.grey[350] : lightButton,
        icon: Icon(Icons.chevron_right),
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
            value: todo.isDone,
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
        icon: Icon(FontAwesomeIcons.chevronRight),
        onPressed: onPressed,
        tooltip: 'Edit Task',
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
//    this.onChangedCheckbox,
  }) : super(key: key);
  final MantraModel mantra;
  final VoidCallback onTap;
  final VoidCallback onPressed;
//  final Function onChangedCheckbox;

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
//    this.onChangedCheckbox,
  }) : super(key: key);
  final MantraModel mantra;
  final VoidCallback onTap;
  final VoidCallback onPressed;
//  final Function onChangedCheckbox;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return ListTile(
      title: AutoSizeText(mantra.title,
          maxLines: 4,
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
//    this.onChangedCheckbox,
  }) : super(key: key);
  final QuoteModel quote;
  final VoidCallback onTap;
  final VoidCallback onPressed;
//  final Function onChangedCheckbox;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return ListTile(
      title: AutoSizeText(
          quote.author == null || quote.author == ''
              ? '"${quote.title}"'
              : '"${quote.title} -- ${quote.author}"',
          maxLines: 4,
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
