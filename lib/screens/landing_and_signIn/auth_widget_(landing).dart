import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/sign_in/auth_service.dart';
import 'package:iMomentum/app/tab_and_navigation/tab_page.dart';
import 'package:iMomentum/screens/landing_and_signIn/not_in_use/sign_in_page_old.dart';
import 'package:iMomentum/screens/landing_and_signIn/start_screen.dart';
import 'package:iMomentum/screens/landing_and_signIn/start_screen2.dart';

/// Builds the signed-in or non signed-in UI, depending on the user snapshot.
/// This widget should be below the [MaterialApp].
/// An [AuthWidgetBuilder] ancestor is required for this widget to work.
/// Note: this class used to be called [LandingPage].
class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? TabPage() : StartScreen();
      // : SignInPageBuilder();
    } else {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageUrl.startImage),
              fit: BoxFit.cover,
            ),
          ),
          constraints: BoxConstraints.expand(),
          child: Center(
            child: SpinKitDoubleBounce(
              color: Colors.white,
              size: 100.0,
            ),
          ),
        ),
      );
    }
  }
}
