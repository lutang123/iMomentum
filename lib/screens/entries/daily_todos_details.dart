import 'package:flutter/foundation.dart';

import 'entry_job.dart';

/// Temporary model class to store the time tracked and pay for a job
class TodoDetails {
  TodoDetails({
    @required this.title,
    @required this.durationInHours,
    this.date,
  });
  final String title;
  double durationInHours;
  DateTime date;
}

/// Groups together all jobs/entries on a given day
class DailyTodosDetails {
  DailyTodosDetails({@required this.date, @required this.todosDetails});
  final DateTime date;
  final List<TodoDetails> todosDetails;

  /// groups entries by date
  static Map<DateTime, List<TodoDuration>> _entriesByDate(
      List<TodoDuration> entries) {
    Map<DateTime, List<TodoDuration>> map = {};
    for (var entryTodo in entries) {
      final entryDayStart = DateTime(entryTodo.todo.date.year,
          entryTodo.todo.date.month, entryTodo.todo.date.day);
      if (map[entryDayStart] == null) {
        //map_name[key] = value, initialize the map
        map[entryDayStart] = [entryTodo];
      } else {
        map[entryDayStart].add(entryTodo);
      }
    }
    return map;
  }

  /// groups entries by job
  static List<TodoDetails> _todosDetails(List<TodoDuration> entries) {
    Map<DateTime, TodoDetails> todoDuration = {};
    for (var entryTodo in entries) {
      if (todoDuration[entryTodo.todo.date] == null) {
        todoDuration[entryTodo.todo.date] = TodoDetails(
          title: entryTodo.todo.title,
          durationInHours: entryTodo.duration.durationInHours,
        );
      } else {
        todoDuration[entryTodo.todo.date].durationInHours +=
            entryTodo.duration.durationInHours;
      }
    }
    return todoDuration.values.toList();
  }

  static List<DailyTodosDetails> all(List<TodoDuration> entries) {
    List<DailyTodosDetails> list = [];
    final byDate = _entriesByDate(entries);
    for (var date in byDate.keys) {
      final entriesByDate = byDate[date];
      final byTodo = _todosDetails(entriesByDate); //List<TodoDetails>
//      print('byTodo: $byTodo');
      list.add(DailyTodosDetails(date: date, todosDetails: byTodo));
    }
    return list.toList();
  }

  ///for today
  //today list
  static List<DailyTodosDetails> getTodayEntries(List<TodoDuration> entries) {
    final allEntries = all(entries); //List<DailyTodosDetails>
    List<DailyTodosDetails> todayEntries = []; //for today
    allEntries.forEach((entry) {
      DateTime today = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      DateTime date =
          DateTime(entry.date.year, entry.date.month, entry.date.day);
      if (date == today) {
        todayEntries.add(entry);
      }
    });
    return todayEntries; //[Instance of 'DailyTodosDetails']
  }

  ///for selectedDay
  //selectedDay list
  static List<DailyTodosDetails> getSelectedDayEntries(
      DateTime date, List<TodoDuration> entries) {
    final allEntries = all(entries);
//    print(allEntries); //[Instance of 'DailyTodosDetails', Instance of 'DailyTodosDetails']
    List<DailyTodosDetails> selectedDayEntries = [];
    allEntries.forEach((entry) {
      final formattedDate = DateTime(date.year, date.month, date.day);
      DateTime todoDate =
          DateTime(entry.date.year, entry.date.month, entry.date.day);
      if (todoDate == formattedDate) {
        selectedDayEntries.add(entry);
      }
    });
    return selectedDayEntries;
  }

  double get duration => todosDetails
      .map((todoDuration) => todoDuration.durationInHours)
      .reduce((value, element) => value + element);
}
