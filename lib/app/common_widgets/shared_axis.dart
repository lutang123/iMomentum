import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

//https://medium.com/flutter-nyc/a-deep-dive-into-the-flutter-animations-package-3e26b10c43c1

class SharedAxisPageRoute extends PageRouteBuilder {
  SharedAxisPageRoute({
    Widget page,
    SharedAxisTransitionType transitionType,
    int milliseconds = 400,
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> primaryAnimation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> primaryAnimation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SharedAxisTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: transitionType,
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: milliseconds),
        );
}
