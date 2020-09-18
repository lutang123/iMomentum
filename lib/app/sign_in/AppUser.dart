import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

// @immutable
class AppUser {
  AppUser({
    @required this.uid,
    this.email,
    this.photoURL,
    this.displayName,
  }) : assert(uid != null, 'User can only be created with a non-null uid');

  final String uid;
  final String email;
  final String photoURL;
  String displayName;

  factory AppUser.fromFirebaseUser(User user) {
    if (user == null) {
      return null;
    }
    return AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
    );
  }

  @override
  String toString() =>
      'uid: $uid, email: $email, photoUrl: $photoURL, displayName: $displayName';
}
