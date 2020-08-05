import 'package:flutter/foundation.dart';

class QuoteModel {
  QuoteModel({
    @required this.id,
    @required this.title,
    this.author,
    this.date,
  });
  //add final or not?
  String id;
  String title;
  String author;
  DateTime date;

  factory QuoteModel.fromMap(
      Map<String, dynamic> firebaseMap, String documentId) {
    if (firebaseMap == null) {
      return null;
    }
    final String title = firebaseMap['title'];
    if (title == null) {
      return null;
    }
    final String author = firebaseMap['author'];

    return QuoteModel(
      id: documentId,
      title: title,
      author: author,
      date: DateTime.fromMillisecondsSinceEpoch(firebaseMap['date']),
    );
  }

  // Convert a Note object into a Map object used in firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title, 'author': author,
      'date': date.millisecondsSinceEpoch, //convert to int
    };
  }
}
