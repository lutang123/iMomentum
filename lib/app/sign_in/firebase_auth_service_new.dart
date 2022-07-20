// import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
import 'package:iMomentum/app/constants/strings_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signInAnonymously({String name}) async {
    final UserCredential userCredential = await _firebaseAuth.signInAnonymously();

    final User user = userCredential.user; //this is current user

    await user.updateProfile(displayName: name);

    await user.reload();

    return userCredential;
  }

  Future<void> createUserWithEmailAndPassword(String email, String password, String name, BuildContext context) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User user = userCredential.user; //this is current user

      await user.updateProfile(displayName: name);

      await user.reload();
      // print('created new user');
      // print('user: $user');

      ///it seems not update, but we can't remove this otherwise not working.
      // print('user.displayName 1 in register: ${user.displayName}'); //null

      /// then we call currentUser again.
      final User currentUser = _firebaseAuth.currentUser; //this is current user
      // print('currentUser: $currentUser');

      ///not working?
      if (!currentUser.emailVerified) {
        await currentUser.sendEmailVerification();

        ///this didn't show
        // await PlatformAlertDialog(
        //   title: 'Verification link sent',
        //   content: 'Please check your email to verify your account.',
        //   defaultActionText: 'OK',
        // ).show(context);
      }
      // print('email verification link sent');

      // print('user.emailVerified: ${currentUser.emailVerified}'); //false

      // print('user.displayName 2 in register: ${user.displayName}'); //null

      // print('currentUser.displayName in register: ${currentUser.displayName}'); //lulu

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        await PlatformAlertDialog(
          title: 'Registration failed',
          content: 'The password provided is too weak.',
          defaultActionText: StringsSignIn.ok,
        ).show(context);
        // Navigator.pop(context); //this pop to black screen
        print('The password provided is too weak.');
        // return null;
      }
      if (e.code == 'email-already-in-use') {
        await PlatformAlertDialog(
          title: 'Registration failed',
          content: 'The account already exists for that email.',
          defaultActionText: StringsSignIn.ok,
        ).show(context);
        // Navigator.pop(context); //this pop to black screen
        print('The account already exists for that email.');
        // return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password, String name, BuildContext context) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // print('sign in again');
      final User firebaseUser = userCredential.user; //this is current user
      // print('firebaseUser: $firebaseUser');

      ///we can not remove this
      await firebaseUser.updateProfile(displayName: name);
      await firebaseUser.reload();

      // final User user = _firebaseAuth.currentUser; //this is also current user
      // print('user: $user');
      // print('firebaseUser.displayName 1: ${firebaseUser.displayName}'); //null
      // print('user.displayName 1: ${user.displayName}'); //lulu

      ///this two code seems no difference
      // await user.updateProfile(displayName: name);
      // await user.reload();
      // print('firebaseUser.displayName 2: ${firebaseUser.displayName}'); //null
      // print('user.displayName 2: ${user.displayName}'); //lulu

      // if (firebaseUser.emailVerified) {
      return userCredential;
      // }
    } on FirebaseAuthException catch (e) {
      // sign in error:
      if (e.code == 'user-not-found') {
        await PlatformAlertDialog(
          title: 'Sign in failed',
          content: 'No user found for that email.',
          defaultActionText: StringsSignIn.ok,
        ).show(context);
        print('No user found for that email.');
        // return null;
      }
      if (e.code == 'wrong-password') {
        await PlatformAlertDialog(
          title: 'Sign in failed',
          content: 'Wrong password provided for that user.',
          defaultActionText: StringsSignIn.ok,
        ).show(context);
        print('Wrong password provided for that user.');
        // return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User> updateUserName(String name) async {
    final User user = _firebaseAuth.currentUser;
    await user.updateProfile(displayName: name);
    await user.reload();
    return user;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final UserCredential userCredential = await _firebaseAuth.signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential;
      } else {
        throw PlatformException(code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN', message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  // Future<UserCredential> signInWithApple(
  //     {List<Scope> scopes = const []}) async {
  //   // 1. perform the sign-in request
  //   final AuthorizationResult result = await AppleSignIn.performRequests(
  //       [AppleIdRequest(requestedScopes: scopes)]);
  //   // 2. check the result
  //   switch (result.status) {
  //     case AuthorizationStatus.authorized:
  //       final appleIdCredential = result.credential;
  //       final oAuthProvider = OAuthProvider('apple.com'); //providerId:
  //       final credential = oAuthProvider.credential(
  //         idToken: String.fromCharCodes(appleIdCredential.identityToken),
  //         accessToken:
  //             String.fromCharCodes(appleIdCredential.authorizationCode),
  //       );
  //
  //       print('credential in Apple SignIN: $credential');
  //
  //       final UserCredential userCredential =
  //           await _firebaseAuth.signInWithCredential(credential);
  //       final User user = userCredential.user;
  //       print('user.uid: ${user.uid}');
  //       if (scopes.contains(Scope.fullName)) {
  //         var displayName =
  //             '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
  //         await user.updateProfile(displayName: displayName);
  //         print('displayName: $displayName');
  //       }
  //
  //       return userCredential;
  //     case AuthorizationStatus.error:
  //       throw PlatformException(
  //         code: 'ERROR_AUTHORIZATION_DENIED',
  //         message: result.error.toString(),
  //       );
  //     case AuthorizationStatus.cancelled:
  //       throw PlatformException(
  //         code: 'ERROR_ABORTED_BY_USER',
  //         message: 'Sign in aborted by user',
  //       );
  //   }
  //   return null;
  // }

  User get currentUser => _firebaseAuth.currentUser;

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    // final FacebookLogin facebookLogin = FacebookLogin();
    // await facebookLogin.logOut();
    return _firebaseAuth.signOut();
  }

  Future<void> delete() async {
    await FirebaseAuth.instance.currentUser.delete();
  }
}

///no need to convert to AppUser
// User _userFromFirebase(FirebaseUser user) {
//   if (user == null) {
//     return null;
//   }
//   return User(
//     uid: user.uid,
//     email: user.email,
//     displayName: user.displayName,
//     photoURL: user.photoUrl,
//   );
// }

///no need to convert to AppUser
// Stream<AppUser> authStateChanges() {
//   return _firebaseAuth
//       .authStateChanges()
//       .map((user) => AppUser.fromFirebaseUser(user));
// }
// Stream<User> get onAuthStateChanged {
//   return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
// }

///remove facebook

// Future<UserCredential> signInWithFacebook() async {
//   final FacebookLogin facebookLogin = FacebookLogin();
//   // https://github.com/roughike/flutter_facebook_login/issues/210
//   facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
//   final FacebookLoginResult result =
//       await facebookLogin.logIn(<String>['public_profile']);
//   if (result.accessToken != null) {
//     final UserCredential userCredential =
//         await _firebaseAuth.signInWithCredential(
//       FacebookAuthProvider.credential(result.accessToken.token), //accessToken
//     );
//     return userCredential;
//   } else {
//     throw PlatformException(
//         code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
//   }
// }

///remove this sendSignInLinkToEmail
// @override
// Future<void> sendSignInWithEmailLink({
//   @required String email,
//   @required String url,
//   @required bool handleCodeInApp,
//   @required String iOSBundleID,
//   @required String androidPackageName,
//   @required bool androidInstallIfNotAvailable,
//   @required String androidMinimumVersion,
// }) async {
//   return await _firebaseAuth.sendSignInLinkToEmail(
//     email: email,
//     url: url,
//     handleCodeInApp: handleCodeInApp,
//     iOSBundleID: iOSBundleID,
//     androidPackageName: androidPackageName,
//     androidInstallIfNotAvailable: androidInstallIfNotAvailable,
//     androidMinimumVersion: androidMinimumVersion,
//   );
// }

// @override

// Future<User> signInWithEmailLink({String email, String link}) async {
//   final UserCredential userCredential =
//       await _firebaseAuth.signInWithEmailLink(email: email, emailLink: link);
//   return userCredential.user;
// }
//
// Future<bool> isSignInWithEmailLink(String link) async {
//   return _firebaseAuth.isSignInWithEmailLink(link);
// }
