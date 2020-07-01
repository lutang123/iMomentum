import 'package:flutter/material.dart';

class MySnackBar extends StatelessWidget {
  const MySnackBar(
      {Key key, @required this.text, this.actionText = '', this.onTap})
      : super(key: key);
  final String text;
  final String
      actionText; //'actionText' is final and was given a value when it was declared, so it can't be set to a new value, so we assign default value to this constructor
  final VoidCallback onTap;

  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black54,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(actionText,
                style: TextStyle(fontSize: 20, color: Colors.white)),
          )
        ],
      ),
    );
  }
}
