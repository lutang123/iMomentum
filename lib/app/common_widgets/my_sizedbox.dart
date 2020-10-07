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

    return SizedBox(height: height > 700 ? 30 : 15);
  }
}

class MyHomeMiddleSpaceSizedBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(height: height > 700 ? 60 : 30);
  }
}

class PomodoroTopSizedBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(height: height > 700 ? 10 : 0);
  }
}

class PomodoroMiddleSizedBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double sizedBoxHeight;
    if (height >= 850) {
      sizedBoxHeight = 30;
    } else if ((height < 850) && (height > 700)) {
      sizedBoxHeight = 20;
    } else if (height < 700) {
      sizedBoxHeight = 10;
    }
    return SizedBox(height: sizedBoxHeight);
  }
}

class PomodoroBottomSizedBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double sizedBoxHeight;
    if (height >= 850) {
      sizedBoxHeight = 60;
    } else if ((height < 850) && (height > 700)) {
      sizedBoxHeight = 20;
    } else if (height < 700) {
      sizedBoxHeight = 5;
    }
    return SizedBox(height: sizedBoxHeight);
  }
}
