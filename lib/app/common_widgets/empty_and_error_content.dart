import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

//folderScreen, NotesInFolder and NotesSearch
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
          color: _darkTheme ? darkThemeDrawer : lightThemeDrawer,
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

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    Key key,
    this.title = 'Something went wrong',
    this.message = 'Can\'t load items right now, please try again later',
  }) : super(key: key);
  final String title;
  final String message;

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(height: 10),
              Text(
                message,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
