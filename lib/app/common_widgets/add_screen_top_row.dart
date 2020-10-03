import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

// TodoScreen, quote and Mantra,, reminder
class AddScreenTopRow extends StatelessWidget {
  final String title;

  const AddScreenTopRow({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Opacity(
            opacity: 0.0,
            child: IconButton(onPressed: null, icon: Icon(Icons.clear)),
          ),
          Spacer(),
          Text(title,
              style: TextStyle(
                fontSize: 23,
                color: _darkTheme ? darkThemeWords : lightThemeWords,
                fontWeight: FontWeight.w600,
              )),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.clear),
                color: _darkTheme ? darkThemeHint : lightThemeHint),
          ),
        ],
      ),
    );
  }
}
