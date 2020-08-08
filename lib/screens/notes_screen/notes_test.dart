import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import '../../app/constants/constants.dart';

class NotesTest extends StatelessWidget {
// ...

// mailto:smith@example.com?subject=Example+Subject+%26+Symbols+are+allowed%21
//  launch(_emailLaunchUri.toString());

//  Future<void> _launchWebsite() async {
//    const url = 'https://google.com';
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      print('Could not launch $url');
//    }
//  }

  @override
  Widget build(BuildContext context) {
    final randomNotifier = Provider.of<RandomNotifier>(context);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        BuildPhotoView(
          imageUrl:
              _randomOn ? ImageUrl.randomImageUrl : imageNotifier.getImage(),
        ),
        ContainerLinearGradient(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.clear, size: 30),
              color: Colors.white,
            ),
          ),
          body: Center(
            child: Container(
//              padding: EdgeInsets.all(5.0),
                child: Image.asset(
//                'assets/images/images_notes/ic_${note.color}.png',
              'assets/images/images_notes/ic_4278228616.png',

//                height: 150,
//                width: 150,
//              fit: BoxFit.fitHeight,
            )),
          ),
        ),
      ],
    );
  }
}
