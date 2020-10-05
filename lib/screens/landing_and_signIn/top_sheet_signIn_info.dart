import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/my_strings.dart';
import 'package:iMomentum/app/constants/theme.dart';

class TopSheetSignInInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///https://stackoverflow.com/questions/60256951/flutter-handler-null-is-not-true
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
              MyListTileWithSubtitle(
                title: Strings.signInReason1,
                subtitle: Strings.signInReason1detail,
                leadingIcon: FontAwesomeIcons.lock,
              ),
              MyListTileWithSubtitle(
                title: Strings.signInReason2,
                subtitle: Strings.signInReason2detail,
                leadingIcon: FontAwesomeIcons.sync,
              ),
              // MyListTileWithSubtitle(
              //   title: Strings.signInReason3,
              //   subtitle: Strings.signInReason3detail,
              //   leadingIcon: FontAwesomeIcons.user,
              // ),

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

class MyListTileWithSubtitle extends StatelessWidget {
  const MyListTileWithSubtitle({
    @required this.title,
    this.subtitle,
    this.leadingIcon,
    Key key,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final IconData leadingIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leadingIcon, //FontAwesomeIcons.user,
          color: lightThemeButton),
      title: Text(title, // Strings.signInReason3,
          style: KSignUpReason),
      subtitle: Text(subtitle, //Strings.signInReason3detail,
          style: KSignUpOr),
    );
  }
}
