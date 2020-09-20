import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

class TodoScreenEmptyOrError extends StatelessWidget {
  final String text1;
  final String tips;
  final String textTap;
  // final String text2;
  final Function onTap;

  const TodoScreenEmptyOrError({
    Key key,
    this.text1,
    this.textTap = '',
    this.tips,
    // this.text2 = '',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              text1,
              style: Theme.of(context).textTheme.subtitle2, // 17
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                    color: _darkTheme
                        ? Colors.white.withOpacity(0.85)
                        : Colors.black54,
                    fontStyle: FontStyle.italic,
                    fontSize: 16),
                children: [
                  TextSpan(
                    text: tips,
                  ),
                  TextSpan(
                    text: textTap,
                    recognizer: TapGestureRecognizer()..onTap = onTap,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: _darkTheme
                            ? Colors.white.withOpacity(0.85)
                            : Colors.black54,
                        fontStyle: FontStyle.italic,
                        fontSize: 16),
                  ),
                  // TextSpan(text: text2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
