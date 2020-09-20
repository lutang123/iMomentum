import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

class SettingSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final Function onChanged;
  final double size;
  // final String subtitle;
  // final bool isThreeLine;

  const SettingSwitch({
    Key key,
    this.icon,
    this.title,
    this.value,
    this.onChanged,
    this.size = 25,
    // this.subtitle = '',
    // this.isThreeLine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    return ListTile(
      leading: Icon(
        icon,
        size: size,
        color: _darkTheme ? darkThemeButton : lightThemeButton,
      ),
      title: Text(title,
          style: TextStyle(
              fontSize: 15,
              color: _darkTheme ? darkThemeWords : lightThemeWords)),
      // subtitle: Text(subtitle), //not looking good
      // isThreeLine: isThreeLine, //must remove this at the same time
      trailing: Transform.scale(
        scale: 0.9,
        child: CupertinoSwitch(
          activeColor:
              _darkTheme ? switchActiveColorUseInDark : switchActiveColorLight,
          trackColor: Colors.grey,
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class SettingSwitchNoIcon extends StatelessWidget {
  final String title;
  final bool value;
  final Function onChanged;

  const SettingSwitchNoIcon({Key key, this.title, this.value, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    return ListTile(
      title: Text(title,
          style: TextStyle(
              fontSize: 15,
              color: _darkTheme ? darkThemeWords : lightThemeWords)),
      trailing: Transform.scale(
        scale: 0.9,
        child: CupertinoSwitch(
          activeColor:
              _darkTheme ? switchActiveColorUseInDark : switchActiveColorLight,
          trackColor: Colors.grey,
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
