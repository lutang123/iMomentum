import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/image_path.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

import 'build_photo_view.dart';
import 'container_linear_gradient.dart';

class MyStackScreen extends StatefulWidget {
  final Widget child;

  const MyStackScreen({Key key, this.child}) : super(key: key);

  @override
  _MyStackScreenState createState() => _MyStackScreenState();
}

class _MyStackScreenState extends State<MyStackScreen> {
  int counter = 0;

  void _onDoubleTap() {
    setState(() {
      ImagePath.randomImageUrl = '${ImagePath.randomImageUrlFirstPart}$counter';
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final randomNotifier = Provider.of<RandomNotifier>(context, listen: false);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context, listen: false);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        BuildPhotoView(
          imageUrl:
              _randomOn ? ImagePath.randomImageUrl : imageNotifier.getImage(),
        ),
        ContainerLinearGradient(),
        GestureDetector(onDoubleTap: _onDoubleTap, child: widget.child),
      ],
    );
  }
}
