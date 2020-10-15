import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

//folderScreen, moveFolder, NotesInFolder and NotesSearch, and staggeredView,
class EmptyOrError extends StatelessWidget {
  final String text;
  final String error;
  final String textTap;
  final Function onTap;
  final Color color;

  const EmptyOrError({
    Key key,
    this.text = '',
    this.error = '', //textError,
    this.textTap = '', //textErrorOnTap 'Or contact us'
    this.onTap,
    this.color = Colors.transparent,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Center(
        child: Container(
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //main message
            text.isNotEmpty
                ? Text(
                    text,
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: _darkTheme ? Colors.white70 : Colors.black45,
                            fontStyle: FontStyle.italic,
                            fontSize: 16),
                        children: [
                          //we can show tips
                          TextSpan(
                            text: error,
                          ),
                          //this is for tap
                          TextSpan(
                            text: textTap, // contact us
                            recognizer: TapGestureRecognizer()..onTap = onTap,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: _darkTheme
                                    ? Colors.white70
                                    : Colors.black45,
                                fontStyle: FontStyle.italic,
                                fontSize: 16),
                          ),
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
