import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'AppUser.dart';

class FirebaseAuthService
// implements AuthService
{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

  // @override
  Stream<AppUser> authStateChanges() {
    return _firebaseAuth
        .authStateChanges()
        .map((user) => AppUser.fromFirebaseUser(user));
  }
  // Stream<User> get onAuthStateChanged {
  //   return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  // }

  // @override
  Future<AppUser> signInAnonymously() async {
    final UserCredential userCredential =
        await _firebaseAuth.signInAnonymously();
    return AppUser.fromFirebaseUser(userCredential.user);
  }

  // @override
  Future<AppUser> signInWithEmailAndPassword(
      String email, String password, String name) async {
    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(EmailAuthProvider.credential(
      email: email,
      password: password,
    ));

    // //Todo: Update the username
    final User firebaseUser = userCredential.user; //this is current user
    // print('firebaseUser: $firebaseUser');

    await firebaseUser.updateProfile(displayName: name);
    await firebaseUser.reload();
    final User user = _firebaseAuth.currentUser; //this is current user
    // print('user: $user');
    print('firebaseUser.displayName: ${firebaseUser.displayName}'); //null
    // await user.updateProfile(displayName: name);
    // await user.reload();
    print('user.displayName: ${user.displayName}'); //lulu

    _firebaseAuth.authStateChanges().listen((User user) {
      if (user != null) {
        print('user.uid: ${user.uid}');

        print(
            'user.displayName authStateChanges 1 : ${user.displayName}'); //lulu
        firebaseUser.updateProfile(displayName: name);

        print(
            'user.displayName authStateChanges 2 : ${user.displayName}'); //lulu

      }
    });
    // if (firebaseUser.emailVerified) {
    return AppUser.fromFirebaseUser(user);
    // }
  }

  Future<AppUser> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    final User firebaseUser = userCredential.user; //this is current user

    // print('firebaseUser: $firebaseUser');
    // flutter: firebaseUser: User(displayName: null, email: sunny@sunny.com, emailVerified: false, isAnonymous: false, metadata: UserMetadata(creationTime: 2020-09-17 11:08:16.751, lastSignInTime: 2020-09-17 11:08:16.751), phoneNumber: null, photoURL: null, providerData, [UserInfo(displayName: null, email: sunny@sunny.com, phoneNumber: null, photoURL: null, providerId: password, uid: sunny@sunny.com)], refreshToken: , tenantId: null, uid: E9rGdN1qnlbFdf90R3jRmIVkaXr1)
    /// Then it print from Home Screen
    // flutter: null AppUser user.displayName in home screen
    // flutter: response.statusCode in quote: 200
    // flutter: null AppUser user.displayName in home screen
    // flutter: null AppUser user.displayName in home screen

    await firebaseUser.updateProfile(displayName: name);
    await firebaseUser.reload();
    final User user = _firebaseAuth.currentUser; //this is current user
    // print('user: $user');
    print('user.displayName in register: ${user.displayName}'); //null
    print(
        'firebaseUser.displayName in register: ${firebaseUser.displayName}'); //lulu

    ///not working
    try {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
        return AppUser.fromFirebaseUser(firebaseUser);
      }
    } catch (e) {
      print("An error occured while trying to send email verification");
      print(e.message);
    }
    _firebaseAuth.authStateChanges().listen((User user) {
      if (user != null) {
        print(user.uid);
        print('user.displayName authStateChanges : ${user.displayName}');
        firebaseUser.updateProfile(displayName: name);
      }
    });

    bool flag = user.emailVerified;

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

    // final reference = FirebaseFirestore.instance.doc(path);
    // await reference.set(data, SetOptions(merge: merge));
    ///try this
    // FirebaseFirestore.instance.collection('users').doc().set({
    //   'name': name,
    //   'uid': firebaseUser.uid,
    //   'email': firebaseUser.email,
    //   'photoUrl': firebaseUser.photoURL, // will always be null
    // });
  }

  ///Todo
  Future<AppUser> updateUserName(String name) async {
    final User user = _firebaseAuth.currentUser; //this is current user

    await user.updateProfile(displayName: name);

    // ///added this, still no change
    // await user.reload();

    return AppUser.fromFirebaseUser(user);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // @override
  Future<AppUser> signInWithEmailLink({String email, String link}) async {
    final UserCredential userCredential =
        await _firebaseAuth.signInWithEmailLink(email: email, emailLink: link);
    return AppUser.fromFirebaseUser(userCredential.user);
  }

  // @override
  Future<bool> isSignInWithEmailLink(String link) async {
    return _firebaseAuth.isSignInWithEmailLink(link);
  }

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
  Future<AppUser> signInWithGoogle() async {
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
        return AppUser.fromFirebaseUser(userCredential.user);
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

  // @override
  Future<AppUser> signInWithFacebook() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    // https://github.com/roughike/flutter_facebook_login/issues/210
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final FacebookLoginResult result =
        await facebookLogin.logIn(<String>['public_profile']);
    if (result.accessToken != null) {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.credential(result.accessToken.token), //accessToken
      );
      return AppUser.fromFirebaseUser(userCredential.user);
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  // @override
  Future<AppUser> signInWithApple({List<Scope> scopes = const []}) async {
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
          // final updateUser = UserUpdateInfo();
          var displayName =
              '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
          await firebaseUser.updateProfile(displayName: displayName);
        }
        return AppUser.fromFirebaseUser(userCredential.user);
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

  // @override
  AppUser get currentUser =>
      AppUser.fromFirebaseUser(_firebaseAuth.currentUser);

  // Future<AppUser> currentUser() async {
  //   final User user =  _firebaseAuth.currentUser;
  //   return AppUser.fromFirebaseUser(user);
  // }

  //
  // @override
  // Future<AppUser> currentUser() async {
  //   final FirebaseUser user = await _firebaseAuth.currentUser();
  //   return _userFromFirebase(user);
  // }

  // @override
  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final FacebookLogin facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    return _firebaseAuth.signOut();
  }
  //
  // @override
  // void dispose() {}
}
