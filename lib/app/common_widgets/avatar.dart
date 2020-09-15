import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key key, this.photoUrl, @required this.radius})
      : super(key: key);
  final String photoUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _darkTheme ? Colors.black38 : Colors.white60,
          width: 1.0,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: _darkTheme ? Colors.black12 : Colors.white38,
        backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
        child: photoUrl == null
            ? Icon(FontAwesomeIcons.userAlt,
                size: radius,
                color: _darkTheme ? darkThemeButton : lightThemeButton)
            : null,
      ),
    );
  }
}
