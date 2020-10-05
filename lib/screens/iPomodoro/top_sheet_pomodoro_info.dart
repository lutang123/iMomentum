import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/my_strings.dart';

class TopSheetPomodoroInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Text(Strings.whySignInTitle,
                  style: KWhySignUpTitle, textAlign: TextAlign.center),
              SizedBox(height: 10),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: RichText(
                  text: TextSpan(
                    style: KPrivacyL,
                    children: [
                      TextSpan(text: Strings.privacy),
                      TextSpan(
                        text: Strings.privacyTap,
                        recognizer: TapGestureRecognizer()..onTap = null,
                        style: KPrivacyTapL,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
