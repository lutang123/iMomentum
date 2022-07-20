import 'package:flutter/material.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/utils/tooltip_shape_border.dart';
import 'package:provider/provider.dart';
import 'package:iMomentum/app/constants/theme.dart';

class MyToolTip extends StatelessWidget {
  final Widget child;
  final String message;

  const MyToolTip({Key key, this.child, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Tooltip(
      message: message,
      textStyle: TextStyle(color: _darkTheme ? darkThemeWords : lightThemeWords),
      preferBelow: false,
      verticalOffset: 0,
      decoration: ShapeDecoration(
        color: _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
        shape: TooltipShapeBorder(arrowArc: 0.5),
        shadows: [BoxShadow(color: Colors.black26, blurRadius: 4.0, offset: Offset(2, 2))],
      ),
      margin: const EdgeInsets.all(30.0),
      padding: const EdgeInsets.all(8.0),
      child: child,
    );
  }
}
