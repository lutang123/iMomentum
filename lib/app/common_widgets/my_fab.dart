import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

class MyFAB extends StatelessWidget {
  const MyFAB({Key key, @required this.onPressed, this.heroTag})
      : super(key: key);

  final VoidCallback onPressed;
  final Object heroTag;
  // final Widget child;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return FloatingActionButton(
      elevation: 0.0,
      heroTag: heroTag,
      onPressed: onPressed,
      shape: CircleBorder(
          side: BorderSide(
              color: _darkTheme ? darkThemeButton : lightThemeButton,
              width: 2.0)),
      child: Icon(Icons.add,
          size: 30, color: _darkTheme ? darkThemeButton : lightThemeButton),
      // child: child,
      backgroundColor: _darkTheme ? Colors.transparent : Colors.white24,
    );
  }
}
