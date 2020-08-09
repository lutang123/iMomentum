import 'package:flutter/foundation.dart';

class Folder {
  Folder({
    @required this.id,
    @required this.title,
  });
  //add final or not?
  String id;
  String title;

  factory Folder.fromMap(Map<String, dynamic> firebaseMap, String documentId) {
    if (firebaseMap == null) {
      return null;
    }
    final String title = firebaseMap['title'];
    if (title == null) {
      return null;
    }
    return Folder(
      id: documentId,
      title: title,
    );
  }

  // Convert a Note object into a Map object used in firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
    };
  }
}
