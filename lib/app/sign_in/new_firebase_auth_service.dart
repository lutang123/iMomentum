import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signInAnonymously() async {
    final UserCredential userCredential =
        await _firebaseAuth.signInAnonymously();
    return userCredential;
  }

  // ignore: missing_return
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(EmailAuthProvider.credential(
        email: email,
        password: password,
      ));

      // //Todo: Update the username
      final User firebaseUser = userCredential.user; //this is current user
      // print('firebaseUser: $firebaseUser');

      ///we can not remove this
      await firebaseUser.updateProfile(displayName: name);
      await firebaseUser.reload();

      final User user = _firebaseAuth.currentUser; //this is also current user
      // print('user: $user');
      print('firebaseUser.displayName 1: ${firebaseUser.displayName}'); //null
      print('user.displayName 1: ${user.displayName}'); //lulu

      ///this two code seems no difference
      // await user.updateProfile(displayName: name);
      // await user.reload();
      print('firebaseUser.displayName 2: ${firebaseUser.displayName}'); //null
      print('user.displayName 2: ${user.displayName}'); //lulu

      // if (firebaseUser.emailVerified) {
      return userCredential;
      // }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // ignore: missing_return
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User firebaseUser = userCredential.user; //this is current user

      await firebaseUser.updateProfile(displayName: name);
      await firebaseUser.reload();

      final User user = _firebaseAuth.currentUser; //this is current user
      ///not working
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }

      print('user.emailVerified: ${user.emailVerified}');

      // print('user: $user');
      print('user.displayName in register: ${user.displayName}'); //null
      print(
          'firebaseUser.displayName in register: ${firebaseUser.displayName}'); //lulu
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //todo
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
    }

    // print('firebaseUser: $firebaseUser');
    // flutter: firebaseUser: User(displayName: null, email: sunny@sunny.com, emailVerified: false, isAnonymous: false, metadata: UserMetadata(creationTime: 2020-09-17 11:08:16.751, lastSignInTime: 2020-09-17 11:08:16.751), phoneNumber: null, photoURL: null, providerData, [UserInfo(displayName: null, email: sunny@sunny.com, phoneNumber: null, photoURL: null, providerId: password, uid: sunny@sunny.com)], refreshToken: , tenantId: null, uid: E9rGdN1qnlbFdf90R3jRmIVkaXr1)
    /// Then it print from Home Screen
    // flutter: null AppUser user.displayName in home screen
    // flutter: response.statusCode in quote: 200
    // flutter: null AppUser user.displayName in home screen
    // flutter: null AppUser user.displayName in home screen

    // _firebaseAuth.authStateChanges().listen((User user) {
    //   if (user != null) {
    //     print(user.uid);
    //     print('user.displayName authStateChanges : ${user.displayName}');
    //     firebaseUser.updateProfile(displayName: name);
    //   }
    // });

    // bool flag = user.emailVerified;

//
// // Get the code from the email:
//     String code = 'xxxxxxx';
//
//     try {
//       await auth.checkActionCode(code);
//       await auth.applyActionCode(code);
//
//       // If successful, reload the user:
//       auth.currentUser.reload();
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'invalid-action-code') {
//         print('The code is invalid.');
//       }
//     }
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
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final UserCredential userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential;
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  Future<UserCredential> signInWithApple(
      {List<Scope> scopes = const []}) async {
    final AuthorizationResult result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com'); //providerId:
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );

        print('credential in Apple SignIN: $credential');

        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = userCredential.user;
        if (scopes.contains(Scope.fullName)) {
          var displayName =
              '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
          await firebaseUser.updateProfile(displayName: displayName);
        }
        return userCredential;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );
      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
    }
    return null;
  }

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
