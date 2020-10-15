import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/constants/theme.dart';

class MyFlatButton extends StatelessWidget {
  const MyFlatButton({
    @required this.onPressed,
    @required this.text,
    //this is the design that can be best used on image
    this.color = Colors.white,
    this.bkgdColor = Colors.transparent,
  });

  final VoidCallback onPressed;
  final String text;
  final Color color;
  final Color bkgdColor;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(68.0),
          side: BorderSide(color: color, width: 1.5)),
      color: bkgdColor,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: GoogleFonts.varelaRound(
              color: color, fontWeight: FontWeight.w600, fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class MyFlatIconButton extends StatelessWidget {
  const MyFlatIconButton({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.onPressed,
    @required this.isDarkTheme,
    this.color = Colors.transparent,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final bool isDarkTheme;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton.icon(
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
                color: isDarkTheme ? darkThemeHint : lightThemeHint,
                width: 1.0)),
        icon:
            Icon(icon, color: isDarkTheme ? darkThemeButton : lightThemeButton),
        onPressed: onPressed,
        label: Text(
          text,
          style:
              TextStyle(color: isDarkTheme ? darkThemeWords : lightThemeWords),
        ),
      ),
    );
  }
}
