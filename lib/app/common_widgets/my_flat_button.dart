import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/constants/theme.dart';

class MyFlatButton extends StatelessWidget {
  const MyFlatButton(
      {@required this.onPressed, @required this.text, this.color});

  final VoidCallback onPressed;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(68.0),
      ),
      color: color,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          text,
          style: GoogleFonts.varelaRound(
            color: fgDark,
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
