import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/constants/theme.dart';

class MantraTopTitle extends StatelessWidget {
  const MantraTopTitle({
    @required this.title,
    @required this.subtitle,
    this.onPressed,
    @required this.darkTheme,
    this.flatButtonText = 'Show Tips',
    this.titleSize = 30,
    this.subtitleSize = 18,
    Key key,
  }) : super(key: key);
  final String title;
  final String subtitle;
  final Function onPressed;
  final bool darkTheme;
  final String flatButtonText;
  final double titleSize;
  final double subtitleSize;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                flatButtonText,
                style: TextStyle(
                    fontSize: 14,
                    color: darkTheme
                        ? darkThemeButton.withOpacity(0.9)
                        : lightThemeButton.withOpacity(0.9)),
              ),
              onPressed: onPressed,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: titleSize,
                      color: darkTheme ? darkThemeWords : lightThemeWords,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Text(
                subtitle,
                style: GoogleFonts.varelaRound(
                  fontSize: subtitleSize,
                  color: darkTheme
                      ? darkThemeWords.withOpacity(0.9)
                      : lightThemeWords.withOpacity(0.9),
                  // fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
