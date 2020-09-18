import 'package:flutter/material.dart';
import 'package:iMomentum/app/sign_in/AppUser.dart';
import 'package:iMomentum/app/sign_in/firebase_auth_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Used to create user-dependent objects that need to be accessible by all widgets.
/// This widgets should live above the [MaterialApp].
/// See [AuthWidget], a descendant widget that consumes the snapshot generated by this builder.
class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({
    Key key,
    @required this.builder,

    ///Sep.16
    this.userProvidersBuilder,
  }) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<AppUser>) builder;

  ///Sep.16
  final List<SingleChildWidget> Function(BuildContext, AppUser)
      userProvidersBuilder;

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);

    return StreamBuilder<AppUser>(
      stream: authService.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
        final AppUser user = snapshot.data;
        if (user != null) {
          return MultiProvider(
            // providers: [
            // Provider<AppUser>.value(value: user),
            // // NOTE: Any other user-bound providers here can be added here
            // Provider<Database>(
            //     create: (_) => FirestoreDatabase(uid: user.uid)),
            // ],
            providers: userProvidersBuilder != null
                ? userProvidersBuilder(context, user)
                : [],
            child: builder(context, snapshot), //TabPage
          );
        }
        return builder(context, snapshot); //SignInPageBuilder();
      },
    );
  }
}
