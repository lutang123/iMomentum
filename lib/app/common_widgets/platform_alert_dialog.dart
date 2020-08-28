import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iMomentum/app/common_widgets/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
  PlatformAlertDialog({
    @required this.title,
    @required this.content,
    this.cancelActionText,
    @required this.defaultActionText,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  final String title;
  final String content;
  final String cancelActionText;
  final String defaultActionText;

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xf01b262c), // //
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Text(
                  title,
//            style: Theme.of(context).textTheme.headline6,
                ),
                content: Text(content),
                actions: _buildActions(context),
              );
            },
          )
        : await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xf01b262c), // //
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Text(
                  title,
//            style: Theme.of(context).textTheme.headline6,
                ),
                content: Text(content),
                actions: _buildActions(context),
              );
            },
          );

    ///previous version, the two seems the same
//    return Platform.isIOS
//        ?
//        await showCupertinoDialog<bool>(
//            context: context,
//            builder: (context) => this,
//          )

//        : await showDialog<bool>(
//            context: context,
//            barrierDismissible: false,
//            builder: (context) => this,
//          );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
//      backgroundColor: Colors.purpleAccent, // //
//      shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(title),
      content: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(content),
      ),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(
        FlatButton(
          child: Text(cancelActionText),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      );
    }
    actions.add(
      FlatButton(
        child: Text(defaultActionText),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    );
    return actions;
  }
}

//class PlatformAlertDialogAction extends PlatformWidget {
//  PlatformAlertDialogAction({this.child, this.onPressed});
//  final Widget child;
//  final VoidCallback onPressed;
//
//  @override
//  Widget buildCupertinoWidget(BuildContext context) {
//    return CupertinoDialogAction(
//      child: child,
//      onPressed: onPressed,
//    );
//  }
//
//  @override
//  Widget buildMaterialWidget(BuildContext context) {
//    return FlatButton(
//      child: child,
//      onPressed: onPressed,
//    );
//  }
//}
