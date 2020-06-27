import 'package:flutter/material.dart';
import 'package:iMomentum/app/models/todo_model.dart';

class JobListTileOriginal extends StatelessWidget {
  const JobListTileOriginal({Key key, @required this.job, this.onTap})
      : super(key: key);
  final TodoModel job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.title),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
