import 'package:flutter/foundation.dart';
import 'package:iMomentum/app/constants/strings.dart';
import 'package:iMomentum/app/sign_in/auth_service.dart';
import 'package:iMomentum/app/sign_in/validator.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel({
    @required this.auth,
    this.name = '',
    this.email = '',
    this.password = '',
    // this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });
  final AuthService auth;
  String name;
  String email;
  String password;
  // EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> signIn() async {
    try {
      if (emailSubmitValidator.isValid(email) &&
          passwordSignInSubmitValidator.isValid(password))
        updateWith(submitted: true, isLoading: true);
      await auth.signInWithEmailAndPassword(email, password, name);
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> register() async {
    try {
      if (emailSubmitValidator.isValid(email) &&
          passwordRegisterSubmitValidator.isValid(password))
        updateWith(submitted: true, isLoading: true);
      await auth.createUserWithEmailAndPassword(email, password, name);
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> forgotPassword() async {
    try {
      // if (emailSubmitValidator.isValid(email))
      // updateWith(submitted: true, isLoading: true);
      await auth.sendPasswordResetEmail(email);
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get passwordLabelTextRegister => Strings.password8CharactersLabel;

  String get passwordLabelTextSignIn => Strings.passwordLabel;

  String get nameErrorText {
    bool showErrorText = submitted && !nameValidator.isValid(name);
    return showErrorText ? invalidNameErrorText : null;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailSubmitValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  String get passwordErrorText {
    bool showErrorText =
        submitted && !passwordSignInSubmitValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  void updateName(String name) => updateWith(name: name);

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String name,
    String email,
    String password,
    // EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.name = name ?? this.name;
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    // this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  @override
  String toString() {
    return 'email: $email, password: $password, isLoading: $isLoading, submitted: $submitted';
  }
}
