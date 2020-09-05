import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

class EmptyContent extends StatelessWidget {
  final String text;

  const EmptyContent({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Center(
        child: Container(
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: _darkTheme ? darkThemeDrawer : lightThemeAppBar,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          text,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
    ));
  }
}
