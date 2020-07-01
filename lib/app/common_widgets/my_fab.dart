import 'package:flutter/material.dart';

class MyFAB extends StatelessWidget {
  const MyFAB({Key key, @required this.onPressed, this.heroTag})
      : super(key: key);

  final VoidCallback onPressed;
  final Object heroTag;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressed,
      tooltip: 'Add Note',
      shape: CircleBorder(side: BorderSide(color: Colors.white, width: 2.0)),
      child: Icon(Icons.add, size: 30, color: Colors.white),
      backgroundColor: Colors.transparent,
    );
  }
}
