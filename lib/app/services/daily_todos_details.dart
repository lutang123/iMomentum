import 'package:flutter/foundation.dart';
import 'package:iMomentum/app/models/todo.dart';

import 'calendar_bloc.dart';

/// Temporary model class to store the time tracked and pay for a job
class TodoDetails {
  TodoDetails({
    @required this.title,
    @required this.durationNumber,
  });
  final String title;
  double durationNumber;
}

/// Groups together all jobs/entries on a given day
class DailyTodosDetails {
  DailyTodosDetails({@required this.date, @required this.todosDetails});
  final DateTime date;
  final List<TodoDetails> todosDetails;

  /// for first calendar
  static Map<DateTime, List<dynamic>> getEvents(List<Todo> todos) {
    Map<DateTime, List<dynamic>> map = {}; //for first calendar
    todos.forEach((todo) {
      DateTime date =
          DateTime(todo.date.year, todo.date.month, todo.date.day, 12);
      if (map[date] == null) map[date] = [];
      map[date].add(todo);
    });
    return map;
  }

  ///for listView builder
  static List<Todo> getTodosGroupByData(DateTime date, List<Todo> todos) {
    List<Todo> list = [];
    todos.forEach((todo) {
      final formattedDate = DateTime(date.year, date.month, date.day);
      DateTime todoDate =
          DateTime(todo.date.year, todo.date.month, todo.date.day);
      if (todoDate == formattedDate) {
        list.add(todo);
      }
    });
    return list;
  }

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
  static List<TodoDetails> _todoDetails(List<TodoDuration> entries) {
    Map<DateTime, TodoDetails> todoDuration = {};
    for (var entryTodo in entries) {
      if (todoDuration[entryTodo.todo.date] == null) {
        todoDuration[entryTodo.todo.date] = TodoDetails(
          title: entryTodo.todo.title,
          durationNumber: entryTodo.duration.durationInMin,
        );
      } else {
        todoDuration[entryTodo.todo.date].durationNumber +=
            entryTodo.duration.durationInMin;
      }
    }
    return todoDuration.values.toList();
  }

  ///combine above two function
  static List<DailyTodosDetails> _all(List<TodoDuration> entries) {
    List<DailyTodosDetails> list = [];
    final byDate = _entriesByDate(entries);
    for (var date in byDate.keys) {
      final entriesByDate = byDate[date];
      final byTodo = _todoDetails(entriesByDate); //List<TodoDetails>
//      print('byTodo: $byTodo');
      list.add(DailyTodosDetails(date: date, todosDetails: byTodo));
    }
    return list.toList();
  }

  static List<DailyTodosDetails> _groupByDate(
      DateTime date, List<TodoDuration> entries) {
    ///returns all the List<DailyTodosDetails>
    final allEntries = _all(entries);
    //without this line, when there's no content, it will show an error message
    if (allEntries.isEmpty) {
      return [];
    }
//    print(allEntries); //[Instance of 'DailyTodosDetails', Instance of 'DailyTodosDetails']
    List<DailyTodosDetails> selectedDayEntries = [];
    allEntries.forEach((entry) {
      // if it's today, calendarDate will be DateTime.now()
      final DateTime formattedDate = DateTime(date.year, date.month, date.day);
      final DateTime formattedTodoDate =
          DateTime(entry.date.year, entry.date.month, entry.date.day);
      if (formattedTodoDate == formattedDate) {
        selectedDayEntries.add(entry);
      }
    });
    return selectedDayEntries;
  }

  double get duration => todosDetails
      .map((todoDuration) => todoDuration.durationNumber)
      .reduce((value, element) => value + element);

  //https://stackoverflow.com/questions/55520270/sum-of-value-in-a-collection-using-flutter
  /// for total duration
  static double getTotalDuration(List<TodoDuration> entries) {
    // total duration across all jobs
    //return List<DailyTodosDetails>
    final allDailyJobsDetails = DailyTodosDetails._all(entries);
//    print(allDailyJobsDetails); //flutter: Instance of '_MapStream<List<TodoDuration>, dynamic>'
    final totalDuration = allDailyJobsDetails
        .map((allJobsDuration) => allJobsDuration.duration)
        .reduce((value, element) => value + element);
    return totalDuration;
  }

  ///this will be directly used for daily total duration
  static double getDailyTotalDuration(
      DateTime calendarDate, List<TodoDuration> entries) {
    ///returns List<DailyTodosDetails> groupByDate
    final _groupByDate = DailyTodosDetails._groupByDate(calendarDate, entries);

    ///this should not be final
    double duration;
    _groupByDate.forEach((dailyTodosDetails) {
      /// this function returns total duration
      duration = dailyTodosDetails.duration;
    });
    return duration;
  }

  ///this is for second calendar
  /// groupby only one day, change to: map[date] = entry.todosDetails, instead of map[date] = entry;
  static Map<DateTime, List<dynamic>> getEventsNew(List<TodoDuration> entries) {
    final allEntries =
        DailyTodosDetails._all(entries); //List<DailyTodosDetails>
    Map<DateTime, List<dynamic>> map = {}; //for calendar
    allEntries.forEach((entry) {
      DateTime date =
          DateTime(entry.date.year, entry.date.month, entry.date.day, 12);
//      if (map[date] == null) map[date] = [];
      map[date] = entry.todosDetails;
    });
    return map; //{2020-06-22 12:00:00.000: [List<TodosDetails>], 2020-06-23 12:00:00.000: [List<TodosDetails>]}
  }

  /// this is for data used in the pie chart dataMap, should look like this:
  // {Flutter: 5.0, React: 3.0, Xamarin: 2.0, Ionic: 2.0}
  ///this will be directly used for pie data
  static Map<String, double> getDataMapGroupByDate(
      DateTime calendarDate, List<TodoDuration> entries) {
    ///returns List<DailyTodosDetails> groupByDate
    final _groupByDate = DailyTodosDetails._groupByDate(calendarDate, entries);
    Map<String, double> _dataMapGroupByDate = {};
    _groupByDate.forEach((dailyTodosDetails) {
      /// List<TodoDetails>
      for (TodoDetails todoDetails in dailyTodosDetails.todosDetails) {
        _dataMapGroupByDate[todoDetails.title] = todoDetails.durationNumber;
      }
    });
    return _dataMapGroupByDate;
  }

  /// for charts_flutter
  /// Not same as DailyTodosDetails._groupByDate(date, entries)
  static List<TodoDetails> getPieDataGroupByData(
      DateTime date, List<TodoDuration> entries) {
    final _selectedDayEntries =
        DailyTodosDetails._groupByDate(date, entries); //List<DailyTodosDetails>
    final List<TodoDetails> pieDataSelected = [];
    _selectedDayEntries.forEach((dailyTodosDetails) {
      for (TodoDetails todoDuration in dailyTodosDetails.todosDetails) {
        pieDataSelected.add(TodoDetails(
          title: todoDuration.title,
          durationNumber: todoDuration.durationNumber,
        ));
      }
    });
    return pieDataSelected;
  }
}
