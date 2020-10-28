import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/my_stack_screen.dart';
import 'package:flutter/cupertino.dart';

import 'contact_us.dart';

class AboutScreen extends StatelessWidget {
  // final Uri _emailLaunchUri = Uri(
  //     scheme: 'mailto',
  //     path: 'sabrina.tanglu@gmail.com',
  //     queryParameters: {'subject': 'Example Subject & Symbols are allowed!'});

// ...

// mailto:smith@example.com?subject=Example+Subject+%26+Symbols+are+allowed%21
//  launch(_emailLaunchUri.toString());

  // Future<void> _launchEmailClient() async {
  //   var url = _emailLaunchUri.toString();
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     print('Could not launch $url');
  //   }
  // }

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
            // tagLine: "The One-stop Productivity App",
            taglineColor: Colors.white,
            textColor: Colors.black87,
            logo: AssetImage('assets/icon/icon.png'),
            // email: 'lutang908@gmail.com',
            companyName: 'iMomentum',
            // phoneNumber: '+01 604 500 8822',
            website: 'https://iMomentum.ca',
            twitterHandle: 'iMomentumApp',
            facebookHandle: 'IMomentumApp-110094130895280/',
            instagram: 'imomentum_app/',
            githubUserName: 'lutang123',
            linkedinURL: 'https://www.linkedin.com/in/lutang123/',
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
