import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_stack_screen.dart';
import 'package:iMomentum/app/constants/image_path.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:flutter/cupertino.dart';
import '../../app/constants/constants_style.dart';

class AboutScreen extends StatelessWidget {
  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'sabrina.tanglu@gmail.com',
      queryParameters: {'subject': 'Example Subject & Symbols are allowed!'});

// ...

// mailto:smith@example.com?subject=Example+Subject+%26+Symbols+are+allowed%21
//  launch(_emailLaunchUri.toString());

  Future<void> _launchEmailClient() async {
    var url = _emailLaunchUri.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyStackScreen(
      child: Scaffold(
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
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "xxxxxx",
                style: KIntro,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "xxxxxx",
                style: KIntro,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
//                MyFlatButton(
//                  text: 'Our Website',
//                  color: Colors.white,
//                  onPressed: () async => _launchWebsite(),
//                ),
                MyFlatButton(
                  text: 'Email Us',
                  color: Colors.white,
                  onPressed: () async => _launchEmailClient(),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
