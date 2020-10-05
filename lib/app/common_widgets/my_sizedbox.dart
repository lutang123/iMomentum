import 'package:flutter/material.dart';

// print('height: $height'); //
// iPhone large: height: 896,
// Android: height: 683.4285714285714;
// iPhone small: height: 667.0
// print('width: $width');
// width: 414, 411.42857142857144, 375.0

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
