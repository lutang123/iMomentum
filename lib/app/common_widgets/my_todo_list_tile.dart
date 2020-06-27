import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/models/todo_model.dart';
import 'package:iMomentum/screens/entries/entry_job.dart';

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    Key key,
    @required this.todo,
    this.todoDuration,
    this.onTap,
    this.onPressed,
    this.onChangedCheckbox,
  }) : super(key: key);
  final TodoModel todo;
  final TodoDuration todoDuration;
  final VoidCallback onTap;
  final VoidCallback onPressed;
  final Function onChangedCheckbox;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Theme(
        data: ThemeData(
          unselectedWidgetColor: Colors.white,
        ),
        child: Checkbox(
            activeColor: Colors.transparent,
            checkColor: Colors.white,
            value: todo.isDone,
            onChanged: onChangedCheckbox),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text(todo.title,
                  softWrap: true,
                  maxLines: 4,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25.0,
                    decoration: todo.isDone ? TextDecoration.lineThrough : null,
                  )),
            ),
          ),
//          Spacer(),
//          Expanded(child: Container()),
//          Text('2')
        ],
      ),
      trailing: IconButton(
        color: Colors.white,
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
  final TodoModel todo;
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
            checkColor: Colors.white,
            value: todo.isDone,
            onChanged: onChangedCheckbox,
          )),
      title: AutoSizeText(
        todo.title,
//        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        textAlign: TextAlign.center,
        style: GoogleFonts.varelaRound(
          fontWeight: FontWeight.w600,
          fontSize: 30.0,
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
        ),

//        TextStyle(
//          color: Colors.white,
//          fontSize: 30.0,
//          decoration: todo.isDone ? TextDecoration.lineThrough : null,
//        ),
      ),
      trailing: Opacity(
        opacity: 0.8,
        child: IconButton(
          color: Colors.grey[350],
          icon: Icon(Icons.clear),
          onPressed: onPressed,
        ),
      ),
      onTap: onTap,
    );
  }
}
