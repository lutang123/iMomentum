import 'package:flutter/foundation.dart';

class MantraModel {
  MantraModel({
    @required this.id,
    @required this.title,
    this.date,
  });
  //add final or not?
  String id;
  String title;
  DateTime date;

  factory MantraModel.fromMap(
      Map<String, dynamic> firebaseMap, String documentId) {
    if (firebaseMap == null) {
      return null;
    }
    final String title = firebaseMap['title'];
    if (title == null) {
      return null;
    }
    return MantraModel(
      id: documentId,
      title: title,
      date: DateTime.fromMillisecondsSinceEpoch(firebaseMap['date']),
    );
  }

  // Convert a Note object into a Map object used in firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title, 'date': date.millisecondsSinceEpoch, //convert to int
    };
  }
}
