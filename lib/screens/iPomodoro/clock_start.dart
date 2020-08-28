import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/common_widgets/my_round_button.dart';
import 'only_thin_ring.dart';

class ClockStart extends StatelessWidget {
  const ClockStart(
      {Key key,
      this.text1,
      this.text2,
      this.height,
      this.onPressed,
      this.onPressedEdit})
      : super(key: key);
  final String text1;
  final String text2;
  final double height;
  final Function onPressed;
  final Function onPressedEdit;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 2,
      width: size.height / 2,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox.expand(
            child: OnlyThinRing(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.baseline,
//                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Opacity(
                    opacity: 0.0,
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: null,
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(
                    text1,
                    style: GoogleFonts.varelaRound(
                      fontWeight: FontWeight.w600,
                      fontSize: 55.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 3),
//                  // not looking good
//                  RoundSmallIconButton(
//                    icon: EvaIcons.moreHorizotnalOutline,
//                    onPressed: onPressedEdit,
//                    color: Colors.white70,
//                  )
                  IconButton(
                    icon: Icon(FontAwesomeIcons.ellipsisH,
                        color: Colors.white.withOpacity(0.85)),
                    onPressed: onPressedEdit,
                  )
                ],
              ),
//              SizedBox(height: 10),
              SizedBox(
                height: 20,
                child: Text(
                  text2,
                  style: GoogleFonts.varelaRound(
                    fontWeight: FontWeight.w600,
                    fontSize: 22.0,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: height), //SizedBox(height: 15),
              RoundIconButton(
                icon: FontAwesomeIcons.play,
                onPressed: onPressed,
                color: Colors.white,
              )
            ],
          ),
        ],
      ),
    );
  }
}
