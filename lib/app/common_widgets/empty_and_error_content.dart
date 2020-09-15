import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

//folderScreen, NotesInFolder and NotesSearch, and other
class EmptyOrError extends StatelessWidget {
  final String text;
  final String tips;
  final String textTap;
  final String text2;
  final Function onTap;

  const EmptyOrError({
    Key key,
    this.text = '',
    this.tips = '', //textError,
    this.textTap = '', //textErrorOnTap 'Or contact us'
    /// //Todo contact us
    this.onTap,
    this.text2 = '',
  }) : super(key: key);
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
        child: Column(
          children: [
            //main message
            text.isEmpty
                ? Container()
                : Text(
                    text,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
            (text.isEmpty || tips.isEmpty) ? Container() : SizedBox(height: 20),
            tips.isEmpty
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: _darkTheme ? Colors.white60 : Colors.black45,
                            fontStyle: FontStyle.italic,
                            fontSize: 16),
                        children: [
                          //we can show tips
                          TextSpan(
                            text: tips,
                          ),
                          //this is for tap
                          TextSpan(
                            text: textTap,
                            recognizer: TapGestureRecognizer()..onTap = onTap,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: _darkTheme
                                    ? Colors.white60
                                    : Colors.black45,
                                fontStyle: FontStyle.italic,
                                fontSize: 16),
                          ),
                          TextSpan(text: text2),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    ));
  }
}
