import 'package:flutter/material.dart';
import 'package:iMomentum/app/models/duration_model.dart';
import 'package:iMomentum/app/models/todo_model.dart';

import 'format.dart';

class DurationListItem extends StatelessWidget {
  const DurationListItem({
    @required this.duration,
    @required this.todo,
    @required this.onTap,
  });

  final DurationModel duration;
  final TodoModel todo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(context),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final dayOfWeek = Format.dayOfWeek(todo.date);
    final startDate = Format.date(todo.date);
//    final startTime = TimeOfDay.fromDateTime(todo.date).format(context);
//    final endTime = TimeOfDay.fromDateTime(todo.date).format(context);
    final durationFormatted = Format.hours(duration.durationInHours);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(dayOfWeek, style: TextStyle(fontSize: 18.0, color: Colors.grey)),
          SizedBox(width: 15.0),
          Text(startDate, style: TextStyle(fontSize: 18.0)),
        ]),
        Row(children: <Widget>[
//          Text('$startTime - $endTime', style: TextStyle(fontSize: 16.0)),
          Expanded(child: Container()),
          Text(durationFormatted, style: TextStyle(fontSize: 16.0)),
        ]),
      ],
    );
  }
}

class DismissibleEntryListItem extends StatelessWidget {
  const DismissibleEntryListItem({
    this.key,
    this.duration,
    this.todo,
    this.onDismissed,
    this.onTap,
  });

  final Key key;
  final DurationModel duration;
  final TodoModel todo;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed(),
      child: DurationListItem(
        duration: duration,
        todo: todo,
        onTap: onTap,
      ),
    );
  }
}
