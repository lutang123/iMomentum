import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Used to create user-dependent objects that need to be accessible by all widgets.
/// This widgets should live above the [MaterialApp].
/// See [AuthWidget], a descendant widget that consumes the snapshot generated by this builder.
class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({
    Key key,
    @required this.builder,
    this.userProvidersBuilder,
  }) : super(key: key);

  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;
  final List<SingleChildWidget> Function(BuildContext, User)
      userProvidersBuilder;

  @override
  Widget build(BuildContext context) {
    // final FirebaseAuthService authService =
    //     Provider.of<FirebaseAuthService>(context, listen: false);
    //Changed to use FirebaseAuth directly
    // final firebaseAuth = Provider.of<FirebaseAuth>(context, listen: false);
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final User user = snapshot.data;
        if (user != null) {
          return MultiProvider(
            providers: userProvidersBuilder != null
                ? userProvidersBuilder(context, user)
                : [],
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}

///previous with AppUser and Service
// return StreamBuilder<AppUser>(
//   stream: authService.authStateChanges(),
//   builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
//     final AppUser user = snapshot.data;
//     if (user != null) {
//       return MultiProvider(
//         // providers: [
//         // Provider<AppUser>.value(value: user),
//         // // NOTE: Any other user-bound providers here can be added here
//         // Provider<Database>(
//         //     create: (_) => FirestoreDatabase(uid: user.uid)),
//         // ],
//         providers: userProvidersBuilder != null
//             ? userProvidersBuilder(context, user)
//             : [],
//         child: builder(context, snapshot), //TabPage
//       );
//     }
//     return builder(context, snapshot); //SignInPageBuilder();
//   },
// );
