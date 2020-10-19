import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/my_round_button.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
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
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SizedBox.expand(
          child: OnlyThinRing(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            firstRow(),
            //add SizedBox to make the layout consistent.
            SizedBox(
              height: 25,
              child: Center(
                child: Text(text2, //can be '' or 'Take a break'
                    style: KTimerBeginSubtitle),
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
    );
  }

  Row firstRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Opacity(
          //just to take the space.
          opacity: 0.0,
          child: IconButton(
            icon: Icon(Icons.edit),
            onPressed: null,
          ),
        ),
        SizedBox(width: 3),
        Text(text1, style: KTimer),
        SizedBox(width: 3),
        IconButton(
          icon: Icon(FontAwesomeIcons.ellipsisH,
              color: Colors.white.withOpacity(0.9)),
          onPressed: onPressedEdit,
        )
      ],
    );
  }
}
