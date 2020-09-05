import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/screens/landing_and_signIn/sign_in_screen_new.dart';
import 'package:iMomentum/app/utils/pages_routes.dart';

class StartScreen extends StatelessWidget {
  void _onPressed(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      PageRoutes.fade(() => SignInScreen.create(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ocean1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Welcome to iMomentum",
                style: KLandingTitle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "xxxxxx",
                style: KLandingSubtitle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "xxxxxx",
                style: KLandingSubtitle,
              ),
            ),
            SizedBox(height: 10),
            MyFlatButton(
              text: 'Start Now',
              color: Colors.white,
              onPressed: () => _onPressed(context),
            ),
          ],
        )),
      ),
    );
  }
}
