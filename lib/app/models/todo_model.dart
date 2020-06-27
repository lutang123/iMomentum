import 'dart:ui';

import 'package:meta/meta.dart';

class TodoModel {
  TodoModel({@required this.id, @required this.title, this.date, this.isDone});
  final String id;
  final String title;
  final DateTime date;
  bool isDone;

//  final int ratePerHour;

// add factory keyword when implementing a constructor that doesn't always
// create a new instance of its class
  //in our case, if the data us null, we return null rather than an object
  factory TodoModel.fromMap(
      Map<String, dynamic> firebaseMap, String documentId) {
    if (firebaseMap == null) {
      return null;
    }
    final String title = firebaseMap['title'];
    if (title == null) {
      return null;
    }
    return TodoModel(
        id: documentId,
        title: title,
        date: DateTime.fromMillisecondsSinceEpoch(firebaseMap['date']),
        isDone: firebaseMap['is_done']); //bool
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
//      "date": date, //Timestamp
      'date': date.millisecondsSinceEpoch, //convert to int
      'is_done': isDone, //bool
    };
  }

  @override
  int get hashCode => hashValues(id, title);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final TodoModel otherJob = other;
    return id == otherJob.id && title == otherJob.title;
//        ratePerHour == otherJob.ratePerHour;
  }

  @override
  String toString() => 'id: $id, title: $title';
}
