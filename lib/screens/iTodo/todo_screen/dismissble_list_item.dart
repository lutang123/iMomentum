import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/my_todo_list_tile.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/services/database.dart';

class DismissibleListItem extends StatelessWidget {
  const DismissibleListItem(
      {this.index,
      this.key,
      this.listItems,
      this.database,
      this.delete,
      this.onTap,
      this.onChangedCheckbox});

  final int index;
  final Key key;
  final List<Todo> listItems;
  final Database database;
  final Function delete;
  final Function onTap;
  final Function onChangedCheckbox;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.black54,
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Text(
                'Delete',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        )),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => delete,
      child: TodoListTile(
        todo: listItems[index],
        onTap: onTap,
        onChangedCheckbox: onChangedCheckbox,
      ),
    );
  }
}
