import 'package:flutter/material.dart';

class CustomizedContainer extends StatelessWidget {
  CustomizedContainer({this.child, this.color});
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 8.0, right: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: child,
    );
  }
}

class CustomizedContainerNew extends StatelessWidget {
  CustomizedContainerNew({this.child, this.color});
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 8.0, right: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: child,
    );
  }
}

//Try using the property borderRadius from BoxDecoration
//

//Container(
//decoration: BoxDecoration(
//border: Border.all(
//color: Colors.red[500],
//),
//borderRadius: BorderRadius.all(Radius.circular(20))
//),
//child: ...
//)

class SmallContainer extends StatelessWidget {
  SmallContainer({this.text, this.bkgdColor = Colors.black38});
  final String text;
  final Color bkgdColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: bkgdColor,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        border: Border.all(color: Colors.white54, width: 1),
      ),
      child: Text(text, style: TextStyle(color: Colors.white54, fontSize: 10)),
    );
  }
}

class CustomizedBottomSheet extends StatelessWidget {
  CustomizedBottomSheet({this.child, this.color});
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: EdgeInsets.only(left: 8.0, right: 8),
        decoration: BoxDecoration(
          color: color,
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
