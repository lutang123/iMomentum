import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/my_text_field.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/services/auth.dart';
import 'package:iMomentum/screens/landing_and_signIn/sign_in_screen.dart';
import 'package:iMomentum/screens/landing_and_signIn/sign_in_screen_old.dart';
import 'package:iMomentum/app/utils/pages_routes.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Widget getQuestion() {
    return TypewriterAnimatedTextKit(
      isRepeatingAnimation: false,
      text: ["Hello, what's your name?"],
      textAlign: TextAlign.center,
      textStyle: KHomeQuestion,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/landscape.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(15.0), child: getQuestion()),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: HomeTextField(onSubmitted: _onSubmitted),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: Text(
            //     "xxxxxx",
            //     style: KLandingSubtitle,
            //   ),
            // ),
            // SizedBox(height: 10),
            // MyFlatButton(
            //   text: 'Start Now',
            //   color: Colors.white,
            //   onPressed: () => _onPressed(context),
            // ),
          ],
        )),
      ),
    );
  }

  void _onSubmitted(newText) async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    if (newText.isNotEmpty) {
      FocusScope.of(context).unfocus();
      Navigator.of(context).pushReplacement(
        PageRoutes.fade(() => SignInScreen.create(context, newText, auth)),
      );
    }
  }
}
