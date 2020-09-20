import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:iMomentum/app/sign_in/new_firebase_auth_service.dart';

class SignInViewModel with ChangeNotifier {
  SignInViewModel({
    // @required this.auth,
    this.firebaseAuthService});
  // final FirebaseAuth auth;
  final FirebaseAuthService firebaseAuthService;
  bool isLoading = false;

  Future<void> _signIn(Future<UserCredential> Function() signInMethod) async {
    try {
      isLoading = true;
      notifyListeners();
      await signInMethod();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signInAnonymously() async {
    await _signIn(firebaseAuthService.signInAnonymously);
  }

  Future<void> signInWithGoogle() async {
    return await _signIn(firebaseAuthService.signInWithGoogle);
  }

  // Future<void> signInWithFacebook() async {
  //   return await _signIn(firebaseAuthService.signInWithFacebook);
  // }

  Future<void> signInWithApple() async {
    return await _signIn(firebaseAuthService.signInWithApple);
  }
}
