import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:iMomentum/app/sign_in/firebase_auth_service_new.dart';

class SignInViewModel with ChangeNotifier {
  SignInViewModel(
      {
      // @required this.auth,
      @required this.firebaseAuthService});
  // final FirebaseAuth auth;
  final FirebaseAuthService firebaseAuthService;
  // bool isLoading = false;

  Future<void> _signIn(Future<UserCredential> Function() signInMethod) async {
    try {
      // isLoading = true;
      notifyListeners();
      await signInMethod();
    } catch (e) {
      // isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signInAnonymously() async {
    await _signIn(firebaseAuthService.signInAnonymously);
  }

  Future<void> signInWithGoogle() async {
    try {
      // isLoading = true;
      notifyListeners();
      await _signIn(firebaseAuthService.signInWithGoogle);
    } catch (e) {
      // isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signInWithApple() async {
    return await _signIn(firebaseAuthService.signInWithApple);
  }
}
