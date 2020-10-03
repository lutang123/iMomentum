import 'package:flutter/material.dart';

class MyTopSizedBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(height: height > 700 ? 30 : 20);
  }
}

class MyHomeMiddleSpaceSizedBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(height: height > 700 ? 60 : 40);
  }
}
