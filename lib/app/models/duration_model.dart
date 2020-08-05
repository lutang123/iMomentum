import 'package:flutter/foundation.dart';

class DurationModel {
  DurationModel({
    @required this.id,
    @required this.todoId,
    this.duration,
  });

  String id;
  String todoId;
//  Duration duration; ///this will not work in Firebase
  int duration;

  ///duration is already converted inMinutes when saving the data
  double get durationInMin => double.parse(duration.toString());
//  int get number => duration ~/ 25;

  factory DurationModel.fromMap(Map<dynamic, dynamic> firebaseMap, String id) {
    return DurationModel(
      id: id,
      todoId: firebaseMap['todoId'],
      //when we save data, we have converted to minutes
      duration: firebaseMap['duration'], //Duration
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'todoId': todoId,
      'duration': duration, //this convert to int
    };
  }
}
