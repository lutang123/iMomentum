// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:iMomentum/app/services/auth_service.dart';
// import 'package:iMomentum/screens/landing_and_signIn/sign_in_page_old.dart';
// import 'package:iMomentum/app/services/database.dart';
// import 'package:iMomentum/app/tab_and_navigation/tab_page.dart';
// import 'package:iMomentum/screens/landing_and_signIn/start_screen2.dart';
// import 'package:provider/provider.dart';
//
// class LandingPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final AuthService auth = Provider.of<AuthService>(context, listen: false);
//     return StreamBuilder<User>(
//         stream: auth.onAuthStateChanged,
//         builder: (context, snapshot) {
//           print(
//               'snapshot.connectionState in landing page: ${snapshot.connectionState}');
//           if (snapshot.connectionState == ConnectionState.active) {
//             User user = snapshot.data;
//             //here we check user and go to either SignInPage or TabPage
//             if (user == null) {
//               // return SignInPageBuilder();
//               return SignInScreen.create(context);
//               // return StartScreen();
//             }
//             return Provider<User>.value(
//               value: user,
//               child: Provider<Database>(
//                 create: (_) => FirestoreDatabase(uid: user.uid),
//                 //and this TabPage has provided FirestoreDatabase with user.uid
//                 child: TabPage(),
//               ),
//             );
//           } else {
//             //this is the case when snapshot.connectionState == ConnectionState.waiting or others
//             return Scaffold(
//               body: Container(
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage('assets/images/landscape.jpg'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 constraints: BoxConstraints.expand(),
//                 child: Center(
//                   child: SpinKitDoubleBounce(
//                     color: Colors.white,
//                     size: 100.0,
//                   ),
//                 ),
//               ),
//             );
//           }
//         });
//   }
// }
