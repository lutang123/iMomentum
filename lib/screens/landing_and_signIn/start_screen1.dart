import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/my_text_field.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/image_path.dart';
import 'package:iMomentum/app/utils/app_localizations.dart';
import 'package:iMomentum/screens/landing_and_signIn/start_screen2.dart';
import 'package:iMomentum/app/utils/pages_routes.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Widget getQuestion() {
    return TypewriterAnimatedTextKit(
      isRepeatingAnimation: false,
      //todo : localization not working
      text: [AppLocalizations.of(context).translate('askName')],
      textAlign: TextAlign.center,
      textStyle: KHomeQuestion,
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagePath.startImage),
              fit: BoxFit.cover,
            ),
          ),
          constraints: BoxConstraints.expand(),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(15.0), child: getQuestion()),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                    key: _formKey,
                    child: HomeTextField(onSubmitted: _onSubmitted, max: 15)),
              ),
            ],
          )),
        ),
      ),
    );
  }

  //added this but still can't validate when input is over mas length
  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    //validate
    if (form.validate()) {
      //save
      form.save();
      return true;
    }
    return false;
  }

  void _onSubmitted(newText) async {
    if (_validateAndSaveForm()) {
      FocusScope.of(context).unfocus();
      Navigator.of(context).pushReplacement(
        PageRoutes.fade(() => StartScreen2(name: newText)),
      );
    }
  }
}
