import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClockTitle extends StatelessWidget {
  const ClockTitle({
    this.title,
    this.subtitle,
    Key key,
  }) : super(key: key);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(title,
            style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.varelaRound(
              fontWeight: FontWeight.w600,
              fontSize: 20.0,
              color: Colors.white,
              fontStyle: FontStyle.italic),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class MantraTopBar extends StatelessWidget {
  const MantraTopBar({
    this.title,
    this.subtitle,
    Key key,
  }) : super(key: key);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(title,
            style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.varelaRound(
                fontWeight: FontWeight.w600,
                fontSize: 17.0,
                color: Colors.white,
                fontStyle: FontStyle.italic),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
