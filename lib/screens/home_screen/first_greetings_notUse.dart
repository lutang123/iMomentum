/// can't share _nameVisible in two class

// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:iMomentum/app/common_widgets/my_text_field.dart';
// import 'package:iMomentum/app/constants/constants_style.dart';
// import 'package:iMomentum/app/constants/theme.dart';
// import 'package:iMomentum/app/models/data/mantras_list.dart';
// import 'package:iMomentum/app/sign_in/firebase_auth_service_new.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:provider/provider.dart';
//
// class FirstGreeting extends StatefulWidget {
//   // static bool nameVisible = true;
//   @override
//   _FirstGreetingState createState() => _FirstGreetingState();
// }
//
// class _FirstGreetingState extends State<FirstGreeting> {
//   bool nameVisible = true;
//   // @override
//   // void initState() {
//   //   nameVisible = widget.nameVisible;
//   //   super.initState();
//   // }
//
//   // static bool nameVisible = true;
//
//   Visibility name(String userName) {
//     return Visibility(
//       visible: nameVisible,
//       child: GestureDetector(
//         onTap: _onTapName,
//         child: AutoSizeText(
//           ', $userName',
//           style: KHomeGreeting,
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//     );
//   }
//
//   Visibility nameTextField() {
//     return Visibility(
//       visible: !nameVisible,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           HomeTextField(
//             onSubmitted: _editName,
//             width: 200,
//             max: 20,
//             autofocus: true,
//           ),
//           InkWell(
//               onTap: _onTapName,
//               child: Icon(Icons.clear, color: darkThemeHint2))
//         ],
//       ),
//     );
//   }
//
//   void _onTapName() {
//     setState(() {
//       nameVisible = !nameVisible;
//     });
//   }
//
//   void _editName(String value) async {
//     final FirebaseAuthService auth =
//         Provider.of<FirebaseAuthService>(context, listen: false);
//     //from ProgressDialog plugin
//     final ProgressDialog pr = ProgressDialog(
//       context,
//       type: ProgressDialogType.Normal,
//       // textDirection: TextDirection.rtl,
//       isDismissible: true,
//     );
//     pr.style(
//       message: 'Please wait',
//       borderRadius: 20.0,
//       backgroundColor: darkThemeNoPhotoColor,
//       elevation: 10.0,
//       insetAnimCurve: Curves.easeInOut,
//       progress: 0.0,
//       progressWidgetAlignment: Alignment.center,
//       maxProgress: 100.0,
//       progressTextStyle: TextStyle(
//           color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
//       messageTextStyle: TextStyle(
//           color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600),
//     );
//
//     await pr.show();
//
//     await auth.updateUserName(value);
//
//     ///because it takes a while to update name
//     await pr.hide();
//
//     setState(() {
//       nameVisible = !nameVisible;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final User user = FirebaseAuth.instance.currentUser;
//
//     // user.reload();
//     // String userName;
//     if (user.displayName != null && user.displayName.isNotEmpty) {
//       // user.displayName.contains(' ')
//       //     ? userName = user.displayName
//       //         .substring(0, user.displayName.indexOf(' '))
//       //         .firstCaps
//       //     :
//
//       final userName = user.displayName;
//
//       if (userName.length < 6) {
//         return Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ///AutoSizeText not useful here
//                 Text('${FirstGreetings().showGreetings()}',
//                     style: KHomeGreeting),
//                 name(userName),
//               ],
//             ),
//             nameTextField()
//           ],
//         );
//       } else if (userName.length > 6) {
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('${FirstGreetings().showGreetings()}',
//                 style: KHomeGreeting, textAlign: TextAlign.center),
//             Visibility(
//               visible: nameVisible,
//               child: GestureDetector(
//                 onTap: _onTapName,
//                 child: AutoSizeText(
//                   '$userName',
//                   style: KHomeGreeting,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ),
//             nameTextField()
//           ],
//         );
//       }
//     }
//
//     // if (user.displayName == null || user.displayName.isEmpty)
//
//     return Text('${FirstGreetings().showGreetings()}', style: KHomeGreeting);
//   }
// }
