import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/models/todo.dart';

class MyTodoListTile extends StatelessWidget {
  MyTodoListTile({
    this.key,
    this.todo,
    this.leading,
    this.onTap,
    this.onChangedCheckbox,
    this.onPressed,
  });
  final Key key;
  final Todo todo;
  final Widget leading;

  final VoidCallback onTap;
  final Function onChangedCheckbox;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text(
                todo.title,
                softWrap: true,
                maxLines: 4,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ),
//          Spacer(),
//          Expanded(child: Container()),
          IconButton(
            color: Colors.white,
            icon: Icon(FontAwesomeIcons.ellipsisH),
            onPressed: onPressed,
          ),
        ],
      ),
      trailing: Theme(
        data: ThemeData(
          unselectedWidgetColor: Colors.white,
        ),
        child: Checkbox(
            activeColor: Colors.transparent,
            checkColor: Colors.white,
            value: todo.isDone,
            onChanged: onChangedCheckbox),
      ),
//      trailing: IconButton(
//        color: Colors.white,
//        icon: Icon(Icons.chevron_right),
//        onPressed: onPressed,
//      ),
      onTap: onTap,
    );
  }
}
