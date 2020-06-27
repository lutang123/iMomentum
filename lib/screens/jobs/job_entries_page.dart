import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/models/duration_model.dart';
import 'package:iMomentum/app/models/todo_model.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'duration_list_item.dart';
import 'list_items_builder.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({@required this.database, @required this.job});
  final Database database;
  final TodoModel job;

  static Future<void> show(BuildContext context, TodoModel job) async {
    final Database database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      //use this instead of MaterialPageRoute
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteDuration(BuildContext context, DurationModel todo) async {
    try {
      await database.deleteDuration(todo);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TodoModel>(
        stream: database.todoStream(todoId: job.id),
        builder: (context, snapshot) {
          final job = snapshot.data;
          return Scaffold(
//            appBar: AppBar(
//              elevation: 2.0,
//              title: Text(jobName),
//              centerTitle: true,
//              actions: <Widget>[
//                IconButton(
//                  icon: Icon(Icons.edit, color: Colors.white),
//                  onPressed: () => EditJobPage.show(
//                    context,
//                    database: database,
//                    job: job,
//                  ),
//                ),
//                IconButton(
//                  icon: Icon(Icons.add, color: Colors.white),
//                  onPressed: () => EntryPage(
//                    database: database,
//                    job: job,
//                  ),
//                ),
//              ],
//            ),
            body: _buildContent(context, job),
          );
        });
  }

  Widget _buildContent(BuildContext context, TodoModel todo) {
    return StreamBuilder<List<DurationModel>>(
      stream: database.durationsStream(todo: todo),
      builder: (context, snapshot) {
        return ListItemsBuilder<DurationModel>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              duration: entry,
              todo: todo,
              onDismissed: () => _deleteDuration(context, entry),
//              onTap: () => EntryPage(
//                database: database,
//                todo: todo,
//                duration: entry,
//              ),
            );
          },
        );
      },
    );
  }
}
