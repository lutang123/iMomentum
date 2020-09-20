// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:iMomentum/app/sign_in/AppUser.dart';
// import 'package:iMomentum/app/sign_in/firebase_auth_service.dart';
// import 'package:meta/meta.dart';
//
// class SignInManager {
//   SignInManager({@required this.auth, @required this.isLoading});
//   final FirebaseAuthService auth;
//   final ValueNotifier<bool> isLoading;
//
//   Future<AppUser> _signIn(Future<AppUser> Function() signInMethod) async {
//     try {
//       isLoading.value = true;
//       return await signInMethod();
//     } catch (e) {
//       isLoading.value = false;
//       rethrow;
//     }
//   }
//
//   Future<AppUser> signInAnonymously() async {
//     return await _signIn(auth.signInAnonymously);
//   }
//
//   Future<void> signInWithGoogle() async {
//     return await _signIn(auth.signInWithGoogle);
//   }
//
//   Future<void> signInWithFacebook() async {
//     return await _signIn(auth.signInWithFacebook);
//   }
//
//   Future<void> signInWithApple() async {
//     return await _signIn(auth.signInWithApple);
//   }
// }
