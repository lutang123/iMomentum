import 'package:flutter/foundation.dart';

class Note {
  Note({
    @required this.id,
    @required this.folderId,
    @required this.title,
    this.description,
    this.date,
    this.color,
    this.isArchived,
  });
  //add final or not?
  String id;
  String folderId;
  String title;
  String description;
  DateTime date;
  int color;
  bool isArchived;

  factory Note.fromMap(Map<String, dynamic> firebaseMap, String documentId) {
    if (firebaseMap == null) {
      return null;
    }
    final String title = firebaseMap['title'];
    if (title == null) {
      return null;
    }
    return Note(
      id: documentId,
      folderId: firebaseMap['folderId'],
      title: title,
      description: firebaseMap['description'],
      date: DateTime.fromMillisecondsSinceEpoch(
          firebaseMap['date']), //convert to DateTime
      color: firebaseMap['color'],
      isArchived: firebaseMap['is_archived'],
    );
  }

  // Convert a Note object into a Map object used in firebase
  Map<String, dynamic> toMap() {
    return {
      'folderId': folderId,
      'title': title,
      'description': description,
      'date': date.millisecondsSinceEpoch, //convert to int
      'color': color,
      'is_archived': isArchived //int
    };
  }
}
