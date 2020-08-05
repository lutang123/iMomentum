import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyFlatButton extends StatelessWidget {
  const MyFlatButton(
      {@required this.onPressed,
      @required this.text,
      this.color = Colors.white,
      this.backgroundColor = Colors.black12});

  final VoidCallback onPressed;
  final String text;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(68.0),
          side: BorderSide(color: color, width: 2.0)),
      color: backgroundColor,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          text,
          style: GoogleFonts.varelaRound(
              color: color, fontWeight: FontWeight.w600, fontSize: 20.0),
        ),
      ),
    );
  }
}
