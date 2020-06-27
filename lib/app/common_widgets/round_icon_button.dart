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
        width: 56.0,
        height: 56.0,
      ),
      shape: CircleBorder(side: BorderSide(color: color, width: 2.0)),
//      fillColor: Color(0xFF4C4F5E),
    );
  }
}
