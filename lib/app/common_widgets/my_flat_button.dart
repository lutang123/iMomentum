import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyFlatButton extends StatelessWidget {
  const MyFlatButton({
    @required this.onPressed,
    @required this.text,
    //this is the design that can be best used on image
    this.color = Colors.white,
    this.bkgdColor = Colors.black12,
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
          side: BorderSide(color: color, width: 2.0)),
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
