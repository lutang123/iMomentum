import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton({@required this.icon, @required this.onPressed, this.color});

  final IconData icon;
  final Function onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Colors.transparent,
      elevation: 0.0,
      child: Icon(
        icon,
        color: color,
      ),
      onPressed: onPressed,
      constraints: BoxConstraints.tightFor(
        width: 55.0,
        height: 55.0,
      ),
      shape: CircleBorder(side: BorderSide(color: color, width: 2.0)),
//      fillColor: Color(0xFF4C4F5E),
    );
  }
}

class RoundSmallIconButton extends StatelessWidget {
  RoundSmallIconButton(
      {@required this.icon,
      @required this.onPressed,
      this.color = Colors.white});

  final IconData icon;
  final Function onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Colors.transparent,
      elevation: 0.0,
      child: Icon(
        icon,
        color: color,
        size: 22,
      ),
      onPressed: onPressed,
      constraints: BoxConstraints.tightFor(
        width: 32.0,
        height: 32.0,
      ),
      shape: CircleBorder(side: BorderSide(color: color, width: 1.0)),
//      fillColor: Color(0xFF4C4F5E),
    );
  }
}

class RoundTextButton extends StatelessWidget {
  RoundTextButton({
    @required this.text,
    @required this.onPressed,
    this.circleColor,
    this.textColor,
    this.fillColor,
  });

  final String text;
  final Function onPressed;
  final Color circleColor;
  final Color textColor;
  final fillColor;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: fillColor,
      elevation: 0.0,
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      onPressed: onPressed,
      constraints: BoxConstraints.tightFor(
        width: 57.0,
        height: 57.0,
      ),
      shape: CircleBorder(side: BorderSide(color: circleColor, width: 2.0)),
//      fillColor: Color(0xFF4C4F5E),
    );
  }
}
