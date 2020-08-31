import 'dart:ui';

import 'package:meta/meta.dart';

class Todo {
  Todo({
    @required this.id,
    @required this.title,
    this.comment,
    this.date,
    this.isDone,
    this.category,
    this.hasReminder,
    this.reminderDate,
  });
  final String id;
  final String title;
  final String comment;
  final DateTime date;
  bool isDone;
  int category;
  bool hasReminder; // we can not make this final
  DateTime reminderDate;

// add factory keyword when implementing a constructor that doesn't always
// create a new instance of its class
// in our case, if the data us null, we return null rather than an object
  factory Todo.fromMap(Map<String, dynamic> firebaseMap, String documentId) {
    if (firebaseMap == null) {
      return null;
    }
    final String title = firebaseMap['title'];
    if (title == null) {
      return null;
    }

    return Todo(
      id: documentId,
      title: title,
      comment: firebaseMap['comment'],
      date: DateTime.fromMillisecondsSinceEpoch(firebaseMap['date']),
      isDone: firebaseMap['is_done'],
      category: firebaseMap['category'],
      hasReminder: firebaseMap['has_reminder'],
      reminderDate: firebaseMap['has_reminder'] == null ||
              firebaseMap['has_reminder'] == false
          ? null

          /// TodoList Streambuildergot error saying trying to call * 1000 after adding reminder, but adding *1000 is wrong
          : DateTime.fromMillisecondsSinceEpoch(firebaseMap['reminder_date']),
    ); //bool
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'comment': comment,
      'date': date.millisecondsSinceEpoch, //convert to int
      'is_done': isDone, //bool
      'category': category,
      'has_reminder': hasReminder,
      'reminder_date': hasReminder == null || hasReminder == false
          ? null
          : reminderDate.millisecondsSinceEpoch, // int
    };
  }

  @override
  int get hashCode => hashValues(id, title);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Todo otherJob = other;
    return id == otherJob.id && title == otherJob.title;
//        ratePerHour == otherJob.ratePerHour;
  }

  @override
  String toString() => 'id: $id, title: $title';
}
