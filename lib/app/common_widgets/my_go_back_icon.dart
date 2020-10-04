import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';

class MyGoBackIcon extends StatelessWidget {
  const MyGoBackIcon({
    Key key,
    @required bool darkTheme,
  })  : _darkTheme = darkTheme,
        super(key: key);

  final bool _darkTheme;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Icons.arrow_back_ios,
        size: 30,
        color: _darkTheme ? darkThemeButton : lightThemeButton,
      ),
    );
  }
}
