import 'package:flutter/material.dart';

class ContainerLinearGradient extends StatelessWidget {
  const ContainerLinearGradient({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black12, //we can not add with opacity
            Colors.black26,
          ],
          stops: [0.5, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.repeated,
        ),
      ),
    );
  }
}
