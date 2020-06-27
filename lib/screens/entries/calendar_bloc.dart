import 'package:flutter/foundation.dart';
import 'package:iMomentum/app/common_widgets/format.dart';
import 'package:iMomentum/app/models/duration_model.dart';
import 'package:iMomentum/app/models/todo_model.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:rxdart/rxdart.dart';

import 'daily_todos_details.dart';
import 'entries_list_tile.dart';
import 'entry_job.dart';

class CalendarBloc {
  CalendarBloc({@required this.database});
  final Database database;

  /// combine List<Job>, List<Entry> into List<EntryJob>
  // Observable isn't available in RxDart 2.4, need update, changed to Rx
  Stream<List<TodoDuration>> get allTodoDurationStream => Rx.combineLatest2(
        database.durationsStream(),
        database.todosStream(),
        _entriesTodosCombiner,
      );

  static List<TodoDuration> _entriesTodosCombiner(
      List<DurationModel> durations, List<TodoModel> todos) {
    return durations.map((duration) {
      final todo = todos.firstWhere((todo) => todo.id == duration.todoId);
      return TodoDuration(duration, todo);
    }).toList();
  }

  /// Output stream
  Stream get entriesStream => allTodoDurationStream.map(_createModels);

  static _createModels(List<TodoDuration> allEntries) {
    //without this line, when there's no content, it will show an error message
    if (allEntries.isEmpty) {
      return [];
    }
    final allDailyJobsDetails = DailyTodosDetails.all(allEntries);
    print(
        allDailyJobsDetails); //flutter: Instance of '_MapStream<List<TodoDuration>, dynamic>'

    // total duration across all jobs
    final totalDuration = allDailyJobsDetails
        .map((dateJobsDuration) => dateJobsDuration.duration)
        .reduce((value, element) => value + element);

    return <EntriesListTileModel>[
//      EntriesListTileModel(
//        leadingText: 'Total Focus Time',
//        trailingText: Format.hours(totalDuration),
//      ),
      for (DailyTodosDetails dailyJobsDetails in allDailyJobsDetails) ...[
        EntriesListTileModel(
          isHeader: true,
          leadingText: Format.date(dailyJobsDetails.date),
          trailingText: Format.hours(dailyJobsDetails.duration),
        ),
        for (TodoDetails jobDuration in dailyJobsDetails.todosDetails)
          EntriesListTileModel(
            leadingText: jobDuration.title,
            trailingText: Format.hours(jobDuration.durationInHours),
          ),
      ]
    ];
  }
}
