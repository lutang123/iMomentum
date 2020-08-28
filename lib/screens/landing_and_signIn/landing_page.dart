import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iMomentum/screens/landing_and_signIn/sign_in_page.dart';
import 'package:iMomentum/app/services/auth.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/tab_and_navigation/tab_page.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            //here we check user and go to either SignInPage or TabPage
            if (user == null) {
              return SignInPage.create(context);
            }
            return Provider<User>.value(
              value: user,
              child: Provider<Database>(
                create: (_) => FirestoreDatabase(uid: user.uid),
                //and this TabPage has provided FirestoreDatabase with user.uid
                child: TabPage(),
              ),
            );
          } else {
            //this is the case when snapshot.connectionState != ConnectionState.active
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/ocean1.jpg'),
                    fit: BoxFit.cover,
//            colorFilter: ColorFilter.mode(
//                Colors.white.withOpacity(0.8), BlendMode.dstATop),
                  ),
                ),
                constraints: BoxConstraints.expand(),
                child: Center(
                  child: SpinKitDoubleBounce(
                    color: Colors.white,
                    size: 100.0,
                  ),
                ),
              ),
            );
          }
        });
  }
}
