import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/utils/tooltip_shape_border.dart';

class MyToolTip extends StatelessWidget {
  final Widget child;
  final String message;

  const MyToolTip({Key key, this.child, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: message,
        textStyle: KToolTip,
        preferBelow: false,
        verticalOffset: 0,
        decoration: ShapeDecoration(
          color: Color(0xf0086972).withOpacity(0.9),
          shape: TooltipShapeBorder(arrowArc: 0.5),
          shadows: [
            BoxShadow(
                color: Colors.black26, blurRadius: 4.0, offset: Offset(2, 2))
          ],
        ),
        margin: const EdgeInsets.all(30.0),
        padding: const EdgeInsets.all(8.0),
        child: child);
  }
}
