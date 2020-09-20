// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:iMomentum/app/common_widgets/my_container.dart';
// import 'package:iMomentum/app/constants/constants_style.dart';
// import 'package:iMomentum/app/services/database.dart';
// import 'package:iMomentum/screens/landing_and_signIn/start_screen1.dart';
// import 'package:iMomentum/screens/tab_and_navigation/tab_page.dart';
// import 'package:provider/provider.dart';
//
// class LandingPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         print('snapshot.connectionState: ${snapshot.connectionState}');
//         if (snapshot.connectionState == ConnectionState.active) {
//           final User user = snapshot.data;
//           if (user != null) {
//             return MultiProvider(
//               providers: [
//                 Provider<Database>(
//                   create: (_) => FirestoreDatabase(uid: user.uid),
//                 ),
//               ],
//               // userProvidersBuilder != null
//               //     ? userProvidersBuilder(context, user)
//               //     : [],
//               child: TabPage(),
//             );
//           }
//           //user is null
//           else {
//             return StartScreen();
//           }
//         }
//
//         if (snapshot.hasError) {
//           print("error in userSnapshot.error: ${snapshot.error.toString()}");
//           return Scaffold(
//             body: Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(ImageUrl.startImage),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               constraints: BoxConstraints.expand(),
//               child: Center(
//                   child: MySignInContainer(
//                       child: Text(
//                 'Operation failed, please try again.',
//                 style: TextStyle(color: Colors.white),
//               ))),
//             ),
//           );
//         } else {
//           return Scaffold(
//             body: Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(ImageUrl.startImage),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               constraints: BoxConstraints.expand(),
//               child: Center(
//                 child: SpinKitDoubleBounce(
//                   color: Colors.white,
//                   size: 100.0,
//                 ),
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
// }
