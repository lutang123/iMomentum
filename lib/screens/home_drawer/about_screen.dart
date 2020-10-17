import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/my_stack_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';

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
          child: ContactUs(
            cardColor: Colors.white60,
            companyColor: Colors.white,
            taglineColor: Colors.black87,
            textColor: Colors.black87,
            logo: AssetImage('assets/logo.png'),
            email: 'lutang908@gmail.com',
            companyName: 'iMomentum',
            // phoneNumber: '+01 604 500 8822',
            website: 'https://iMomentum.ca',
            facebookHandle: 'https://www.facebook.com/lu.tang.1422',
            githubUserName: 'lutang123',
            linkedinURL: 'https://www.linkedin.com/in/lutang123/',
            // tagLine: 'Flutter Developer',
            twitterHandle: 'FlutterLulu',
            instagram: 'travelling_girl_lulu',
          ),
        ),
        // bottomNavigationBar: ContactUsBottomAppBar(
        //   companyName: 'iMomentum',
        //   textColor: Colors.white,
        //   backgroundColor: Colors.teal.shade300,
        //   email: 'adoshi26.ad@gmail.com',
        // ),
      ),
    );
  }
}
