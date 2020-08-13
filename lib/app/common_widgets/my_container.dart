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

class SmallContainer extends StatelessWidget {
  SmallContainer({this.text, this.bkgdColor = Colors.black38});
  final String text;
  final Color bkgdColor;

  ////                              Container(
  ////                                decoration: BoxDecoration(
  ////                                  shape: BoxShape.circle,
  ////                                  border: Border.all(
  ////                                      color: Colors.white70, width: 1),
  ////                                ),
  ////                                child: IconButton(
  ////                                    icon: Icon(EvaIcons.moreHorizotnalOutline),
  ////                                    onPressed: null),
  ////                              ),

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: bkgdColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        border: Border.all(color: Colors.white54, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child:
            Text(text, style: TextStyle(color: Colors.white70, fontSize: 10)),
      ),
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
