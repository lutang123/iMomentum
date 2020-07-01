import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:provider/provider.dart';

import 'edit_job_page.dart';
import 'job_entries_page.dart';
import 'job_list_tile_original.dart';
import 'list_items_builder.dart';

class JobsPage extends StatelessWidget {
  //+ icon
  void _editJobPage(context) {
    EditJobPage.show(
      context,
      database: Provider.of<Database>(context, listen: false),
//      job: job,
    );
  }

  Future<void> _delete(BuildContext context, Todo job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteTodo(job);
      //PlatformException is from import 'package:flutter/services.dart';
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Jobs'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => _editJobPage(context),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Todo>>(
      stream: database.todosStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Todo>(
          //ListView.separated
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: Key('job-${job.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            child: JobListTileOriginal(
              job: job,
              onTap: () => JobEntriesPage.show(context, job),
            ),
          ),
        );
      },
    );
  }
}
