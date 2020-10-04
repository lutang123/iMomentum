import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/constants/theme.dart';

class MantraTopTitle extends StatelessWidget {
  const MantraTopTitle({
    @required this.title,
    @required this.subtitle,
    this.onPressed,
    @required this.darkTheme,
    Key key,
  }) : super(key: key);
  final String title;
  final String subtitle;
  final Function onPressed;
  final bool darkTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios, size: 30),
              color: darkTheme ? darkThemeButton : lightThemeButton,
            ),
            FlatButton(
              child: Text(
                'Show Tips',
                style: TextStyle(
                    fontSize: 15,
                    color: darkTheme
                        ? darkThemeButton.withOpacity(0.9)
                        : lightThemeButton.withOpacity(0.9)),
              ),
              onPressed: onPressed,
            ),
          ],
        ),
        Text(title,
            style: TextStyle(
                fontSize: 30,
                color: darkTheme ? darkThemeWords : lightThemeWords,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 15),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.varelaRound(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: darkTheme ? darkThemeWords : lightThemeWords,
              fontStyle: FontStyle.italic),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
