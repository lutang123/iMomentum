import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClockTitle extends StatelessWidget {
  const ClockTitle({
    this.title,
    this.subtitle,
//    this.widget = Text(''),
    Key key,
  }) : super(key: key);
  final String title;
  final String subtitle;
//  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(title,
            style: TextStyle(
                fontSize: 32,
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
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios, size: 30),
              color: Colors.white,
            )
          ],
        ),
        Text(title,
            style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.varelaRound(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0,
                    color: Colors.white,
                    fontStyle: FontStyle.italic),
              ),
//              IconButton(
//                icon: EvaIcons.i,
//              )
            ],
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
