// import 'package:flutter/foundation.dart';
//
// class ImageModel {
//   ImageModel({@required this.id, this.url});
//   //add final or not?
//   String id;
//   String url;
//
//   factory ImageModel.fromMap(
//       Map<String, dynamic> firebaseMap, String documentId) {
//     if (firebaseMap == null) {
//       return null;
//     }
//     final String url = firebaseMap['url'];
//     if (url == null) {
//       return null;
//     }
//     return ImageModel(
//       id: documentId,
//       url: url,
//     );
//   }
//
//   // Convert a Note object into a Map object used in firebase
//   Map<String, dynamic> toMap() {
//     return {'url': url};
//   }
// }
