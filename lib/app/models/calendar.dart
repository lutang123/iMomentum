//import 'dart:ui';
//
//import 'package:iMomentum/app/models/todo.dart';
//import 'package:meta/meta.dart';
//
//class Calendar {
//  Calendar({@required this.id, @required this.calendarEventMap});
//  final String id;
//  final Map<DateTime, List<TodoModel>> calendarEventMap;
//
//  factory Calendar.fromMap(
//      Map<String, dynamic> firebaseMap, String documentId) {
//    if (firebaseMap == null) {
//      return null;
//    }
//    final String title = firebaseMap['title'];
//    if (title == null) {
//      return null;
//    }
////    return Calendar(
////        id: documentId,
////        title: title,
////        date: DateTime.fromMillisecondsSinceEpoch(firebaseMap['date']),
////        isDone: firebaseMap['is_done']); //bool
//  }
//
//  // decode Date Time Helper Method
//  Map<DateTime, dynamic> fromMap(Map<String, dynamic> map) {
//    Map<DateTime, dynamic> newMap = {};
//    map.forEach((key, value) {
//      newMap[DateTime.parse(key)] = map[key];
//    });
//    return newMap;
//  }
//
//  // Encode Date Time Helper Method
//  Map<String, List<TodoModel>> toMap(
//      Map<DateTime, List<TodoModel>> calendarEventMap) {
//    Map<String, List<TodoModel>> newMap = {};
//    calendarEventMap.forEach((key, value) {
//      newMap[key.toString()] = calendarEventMap[key];
//    });
//    return newMap;
//  }
//
////// add factory keyword when implementing a constructor that doesn't always
////// create a new instance of its class
////  //in our case, if the data us null, we return null rather than an object
////
////
////  Map<String, dynamic> toMap() {
////    return {
////      'title': title,
//////      "date": date, //Timestamp
////      'date': date.millisecondsSinceEpoch, //convert to int
////      'is_done': isDone, //bool
////    };
////  }
//
////  @override
////  int get hashCode => hashValues(id, title);
////
////  @override
////  bool operator ==(other) {
////    if (identical(this, other)) return true;
////    if (runtimeType != other.runtimeType) return false;
////    final Calendar otherJob = other;
////    return id == otherJob.id && title == otherJob.title;
//////        ratePerHour == otherJob.ratePerHour;
////  }
////
////  @override
////  String toString() => 'id: $id, title: $title';
//}
