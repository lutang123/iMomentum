import 'package:flutter/material.dart';

class CustomizedContainer extends StatelessWidget {
  CustomizedContainer({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 8.0, right: 8),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: child,
    );
  }
}

class CustomizedBottomSheet extends StatelessWidget {
  CustomizedBottomSheet({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      height: (size.height / 2.5),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
//        margin: EdgeInsets.only(left: 15.0, right: 15),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: child,
      ),
    );
  }
}
