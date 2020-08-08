import 'package:flutter/foundation.dart';
import 'package:iMomentum/app/models/duration_model.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:rxdart/rxdart.dart';

class TodoDuration {
  TodoDuration(this.duration, this.todo);

  final DurationModel duration;
  final Todo todo;
}

class CalendarBloc {
  CalendarBloc({@required this.database});
  final Database database;

  /// combine List<TodoModel>, List<DurationModel> into List<TodoDuration>
  /// this is the one will use in StreamBuilder for pie_chart
  // Observable isn't available in RxDart 2.4, need update, changed to Rx
  Stream<List<TodoDuration>> get allTodoDurationStream => Rx.combineLatest2(
        database.durationsStream(),
        database.todosStream(),
        _entriesTodosCombiner,
      );

  static List<TodoDuration> _entriesTodosCombiner(
      List<DurationModel> durations, List<Todo> todos) {
    return durations.map((duration) {
      final todo = todos.firstWhere((todo) => todo.id == duration.todoId);
      return TodoDuration(duration, todo);
    }).toList();
  }

//  /// Output stream, we do not use these
//  Stream get entriesStream => allTodoDurationStream.map(_createModels);
//  static _createModels(List<TodoDuration> entries) {
//    //without this line, when there's no content, it will show an error message
//    if (entries.isEmpty) {
//      return [];
//    }
//  }
}
