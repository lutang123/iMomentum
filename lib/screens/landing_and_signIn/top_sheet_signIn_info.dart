import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/theme.dart';

class TopSheetSignInInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    // bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          Text('Why sign in to use iMomentum?',
              style: TextStyle(
                fontSize: 20,
                color:
                    // _darkTheme ? darkThemeWords :
                    lightThemeWords,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(FontAwesomeIcons.lock,
                color:
                    // _darkTheme ? darkThemeButton :
                    lightThemeButton),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text('Secure all of your data.',
                  style: TextStyle(
                      color:
                          // _darkTheme ? darkThemeWords :
                          lightThemeWords)),
            ),
            subtitle: Text(
                'If you change your device or delete the app, you will not loose your data.',
                style:
                    // _darkTheme ? KSignInButtonOrD :
                    KSignInButtonOrL),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.sync,
                color:
                    // _darkTheme ? darkThemeButton :
                    lightThemeButton),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text('Access your data from multi device',
                  style: TextStyle(
                      color:
                          // _darkTheme ? darkThemeWords :
                          lightThemeWords)),
            ),
            subtitle: Text(
                'iMomentum Web version will be available soon and you will be able to access your account on web browser.',
                style:
                    // _darkTheme ? KSignInButtonOrD :
                    KSignInButtonOrL),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.user,
                color:
                    // _darkTheme ? darkThemeButton :
                    lightThemeButton),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text('Personalize your experience',
                  style: TextStyle(
                      color:
                          // _darkTheme ? darkThemeWords :
                          lightThemeWords)),
            ),
            subtitle: Text(
                'By signing in, you can access your account and update your information.',
                style:
                    // _darkTheme ? KSignInButtonOrD :
                    KSignInButtonOrL),
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style:
                  // _darkTheme ? KPrivacyD :
                  KPrivacyL,
              children: [
                TextSpan(
                  text:
                      'Your privacy is important. iMomentum will not share any of your data with any third party. ',
                ),
                // TextSpan(
                //   text:
                //   ' Learn more about how we‘re protecting your privacy in our',
                // ),
                // TextSpan(
                //   text: ' Terms and Privacy Policy.',
                //   //Todo
                //   recognizer: TapGestureRecognizer()..onTap = null,
                //   style: KPrivacyTap,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//'You can log in with multi device and access the same data. ()
