import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/custom_raised_button.dart';

//extend just to get all the property that parents have, so that we don't need
// to create this again, but we can add new feature, like car to electric car.
// this way, we don't need to use build method and shorten the code
class SignInButton extends CustomRaisedButton {
  SignInButton({
    Key key,
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
          //inherited
          key: key,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15.0),
          ),
          color: color,
          onPressed: onPressed,
        );
}

//CustomRaisedButton({
//    Key key,
//    this.child,
//    this.color,
//    this.borderRadius: 2.0,
//    this.height: 50.0,
//    this.onPressed,
//  }) : assert(borderRadius != null), super(key: key);
