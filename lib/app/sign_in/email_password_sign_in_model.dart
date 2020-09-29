import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:iMomentum/app/constants/strings_sign_in.dart';
import 'firebase_auth_service_new.dart';
import 'validator.dart';

enum EmailPasswordSignInFormType { signIn, register, forgotPassword }

class EmailAndPasswordValidators {
  final TextInputFormatter emailInputFormatter =
      ValidatorInputFormatter(editingValidator: EmailEditingRegexValidator());
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator =
      MinLengthStringValidator(8);
  final StringValidator passwordSignInSubmitValidator =
      NonEmptyStringValidator();
}

class EmailPasswordSignInModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailPasswordSignInModel({
    @required this.firebaseAuthService,
    @required this.name,
    this.email = '',
    this.password = '',
    this.formType = EmailPasswordSignInFormType.register,
    // this.isLoading = false,
    // this.submitted = false,
  });

  final FirebaseAuthService firebaseAuthService;
  String name;
  String email;
  String password;
  EmailPasswordSignInFormType formType;
  // bool isLoading;
  // bool submitted;

  Future<bool> submit(BuildContext context) async {
    try {
      // updateWith(submitted: true);
      // if (!canSubmit) {
      //   return false;
      // }
      // updateWith(isLoading: true);
      switch (formType) {
        case EmailPasswordSignInFormType.register:
          await firebaseAuthService.createUserWithEmailAndPassword(
              email, password, name, context);
          break;

        case EmailPasswordSignInFormType.signIn:
          await firebaseAuthService.signInWithEmailAndPassword(
              email, password, name, context);
          break;

        case EmailPasswordSignInFormType.forgotPassword:
          await firebaseAuthService.sendPasswordResetEmail(email);
          // updateWith(isLoading: false);
          break;
      }
      return true;
    } catch (e) {
      // updateWith(isLoading: false);
      rethrow;
    }
  }

  // void updateName(String name) => updateWith(name: name);

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateFormType(EmailPasswordSignInFormType formType) {
    updateWith(
      email: '',
      password: '',
      formType: formType,
      // isLoading: false,
      // submitted: false,
    );
  }

  void updateWith({
    // String name, //we don't change name here
    String email,
    String password,
    EmailPasswordSignInFormType formType,
    // bool isLoading,
    // bool submitted,
  }) {
    // this.name = name ?? this.name;
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    // this.isLoading = isLoading ?? this.isLoading;
    // this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  String get passwordLabelText {
    if (formType == EmailPasswordSignInFormType.register) {
      return StringsSignIn.password8CharactersLabel;
    }
    return StringsSignIn.passwordHint;
  }

  // Getters
  String get primaryButtonText {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: StringsSignIn.createAnAccount,
      EmailPasswordSignInFormType.signIn: StringsSignIn.signIn,
      EmailPasswordSignInFormType.forgotPassword: StringsSignIn.sendResetLink,
    }[formType];
  }

  String get secondaryButtonText {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: StringsSignIn.haveAnAccount,
      EmailPasswordSignInFormType.signIn: StringsSignIn.needAnAccount,
      EmailPasswordSignInFormType.forgotPassword: StringsSignIn.backToSignIn,
    }[formType];
  }

  EmailPasswordSignInFormType get secondaryActionFormType {
    return <EmailPasswordSignInFormType, EmailPasswordSignInFormType>{
      EmailPasswordSignInFormType.register: EmailPasswordSignInFormType.signIn,
      EmailPasswordSignInFormType.signIn: EmailPasswordSignInFormType.register,
      EmailPasswordSignInFormType.forgotPassword:
          EmailPasswordSignInFormType.signIn,
    }[formType];
  }

  String get errorAlertTitle {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: StringsSignIn.registrationFailed,
      EmailPasswordSignInFormType.signIn: StringsSignIn.signInFailed,
      EmailPasswordSignInFormType.forgotPassword:
          StringsSignIn.passwordResetFailed,
    }[formType];
  }

  String get title {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: StringsSignIn.register,
      EmailPasswordSignInFormType.signIn: StringsSignIn.signIn,
      EmailPasswordSignInFormType.forgotPassword: StringsSignIn.forgotPassword,
    }[formType];
  }

  bool get canSubmitEmail {
    return emailSubmitValidator.isValid(email);
  }

  bool get canSubmitPassword {
    if (formType == EmailPasswordSignInFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  bool get canSubmit {
    final bool canSubmitFields =
        formType == EmailPasswordSignInFormType.forgotPassword
            ? canSubmitEmail
            : canSubmitEmail && canSubmitPassword;
    return canSubmitFields;
    // && !isLoading;
  }

  String get emailErrorText {
    final bool showErrorText =
        // submitted &&
        !canSubmitEmail;
    final String errorText = email.isEmpty
        ? StringsSignIn.invalidEmailEmpty
        : StringsSignIn.invalidEmailErrorText;
    return showErrorText ? errorText : null;
  }

  String get passwordErrorText {
    final bool showErrorText =
        // submitted &&
        !canSubmitPassword;
    final String errorText = password.isEmpty
        ? StringsSignIn.invalidPasswordEmpty
        : StringsSignIn.invalidPasswordTooShort;
    return showErrorText ? errorText : null;
  }

  @override
  String toString() {
    return 'email: $email, password: $password, formType: $formType, '
        // 'isLoading: $isLoading, submitted: $submitted'
        ;
  }
}
