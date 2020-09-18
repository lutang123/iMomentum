// import 'dart:async';
// import 'package:flare_flutter/flare_actor.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:iMomentum/app/common_widgets/my_container.dart';
// import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
// import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
// import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
// import 'package:iMomentum/app/constants/constants_style.dart';
// import 'package:iMomentum/app/constants/string_sign_in.dart';
// import 'package:iMomentum/app/services/auth.dart';
// import 'package:iMomentum/app/services/AppUser.dart';
// import 'package:iMomentum/app/sign_in/sign_in_manager.dart';
// import 'package:iMomentum/app/sign_in_teddy/teddy_controller.dart';
// import 'package:iMomentum/app/sign_in_teddy/tracking_text_input.dart';
// import 'package:iMomentum/app/utils/pages_routes.dart';
// import 'package:iMomentum/screens/landing_and_signIn/start_screen2.dart';
// import 'package:provider/provider.dart';
// import '../../app/sign_in/email_password/email_password_sign_in_model.dart';
// import '../../app/sign_in/email_sign_in_change_model.dart';
//
// typedef void CaretMoved(Offset globalCaretPosition);
// typedef void TextChanged(String text);
//
// class SignInScreenBuilder extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final AuthService auth = Provider.of<AuthService>(context, listen: false);
//     return ChangeNotifierProvider<ValueNotifier<bool>>(
//         create: (_) => ValueNotifier<bool>(false),
//         child: Consumer<ValueNotifier<bool>>(
//             builder: (_, ValueNotifier<bool> isLoading, __) => Provider<
//                     SignInManager>(
//                 create: (_) => SignInManager(auth: auth, isLoading: isLoading),
//                 child: Consumer<SignInManager>(
//                     builder: (_, SignInManager manager, __) =>
//                         ChangeNotifierProvider<EmailSignInChangeModel>(
//                             create: (_) => EmailSignInChangeModel(auth: auth),
//                             child: Consumer<EmailSignInChangeModel>(
//                                 builder:
//                                     (_, EmailSignInChangeModel model, __) =>
//                                         EmailSignInPage._(
//                                           manager: manager,
//                                           model: model,
//                                           isLoading: isLoading.value,
//                                           // onSignedIn: onSignedIn,
//                                         )))))));
//   }
// }
//
// class EmailSignInPage extends StatefulWidget {
//   const EmailSignInPage._({
//     @required this.model,
//     @required this.manager,
//     // this.onSignedIn,
//     @required this.isLoading,
//   });
//
//   final SignInManager manager;
//   final EmailSignInChangeModel model;
//   // final VoidCallback onSignedIn;
//   final bool isLoading;
//
//   // final EmailSignInChangeModel model;
//   // final SignInManager manager;
//
//   // final AuthBase auth;
//   // final String name;
//
//   // static Widget create(BuildContext context) {
//   //   ///todo
//   //   final AuthService auth = Provider.of<AuthService>(context, listen: false);
//   //   return ChangeNotifierProvider<ValueNotifier<bool>>(
//   //       create: (_) => ValueNotifier<bool>(false),
//   //       child: Consumer<ValueNotifier<bool>>(
//   //           builder: (_, isLoading, __) => Provider<SignInManager>(
//   //                 create: (_) =>
//   //                     SignInManager(auth: auth, isLoading: isLoading),
//   //                 child: Consumer<SignInManager>(
//   //                   builder: (context, manager, _) =>
//   //                       ChangeNotifierProvider<EmailSignInChangeModel>(
//   //                     create: (context) => EmailSignInChangeModel(auth: auth),
//   //                     child: Consumer<EmailSignInChangeModel>(
//   //                       builder: (context, model, _) => EmailSignInPage(
//   //                         model: model,
//   //                         // manager: manager,
//   //                         isLoading: isLoading.value,
//   //                         // name: userName,
//   //                       ),
//   //                     ),
//   //                   ),
//   //                 ),
//   //               )));
//   //   // return ChangeNotifierProvider<EmailSignInChangeModel>(
//   //   //   create: (context) => EmailSignInChangeModel(auth: auth),
//   //   //   child: Consumer<EmailSignInChangeModel>(
//   //   //     builder: (context, model, _) => EmailSignInPage(
//   //   //       model: model,
//   //   //       // name: name,
//   //   //     ),
//   //   //   ),
//   //   // );
//   // }
//
//   @override
//   _EmailSignInPageState createState() => _EmailSignInPageState();
// }
//
// class _EmailSignInPageState extends State<EmailSignInPage> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   TeddyController _teddyController;
//   String _email = '';
//   String _password = '';
//   String _password2 = '';
//   bool _isLoading = false;
//   bool _isObscured = true;
//
//   final FocusNode _emailFocusNode = FocusNode();
//
//   final FocusNode _passwordFocusNode = FocusNode();
//
//   final FocusNode _passwordFocusNode2 = FocusNode();
//
//   EmailSignInChangeModel get model => widget.model;
//   SignInManager get manager => widget.manager;
//
//   @override
//   initState() {
//     _teddyController = TeddyController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _emailFocusNode.dispose();
//     _passwordFocusNode.dispose();
//     _passwordFocusNode2.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/landscape.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             constraints: BoxConstraints.expand()),
//         DefaultTabController(
//           length: 2,
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             key: _scaffoldKey,
//             appBar: AppBar(
//               leading: IconButton(
//                   icon: Icon(Icons.arrow_back_ios, color: Colors.white),
//                   onPressed: () => Navigator.of(context).pushReplacement(
//                         PageRoutes.fade(() => StartScreen2()),
//                       )),
//               // title: Text(model.primaryButtonText, style: KAppBarTitle),
//               backgroundColor: Colors.transparent,
//               elevation: 0.0,
//               actions: [
//                 ///Todo
//                 IconButton(
//                     icon:
//                         Icon(Icons.info_outline, color: Colors.white, size: 30),
//                     onPressed: null),
//               ],
//               bottom: PreferredSize(
//                 preferredSize: Size.fromHeight(50),
//                 child: TabBar(
//                   labelStyle: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600),
//                   indicatorColor: Colors.white,
//                   tabs: [
//                     ///when use text, instead of child, the text color is white when in light theme
//                     Tab(
//                       child: Text('Create an account',
//                           style: TextStyle(color: Colors.white)),
//                     ),
//                     Tab(
//                       child: Text('Sign In',
//                           style: TextStyle(color: Colors.white)),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             body: Column(
//               children: [
//                 TabBarView(
//                   children: [_tab2(), _tab1()],
//                 ),
//
//                 MySignInContainer(
//                   child: Column(
//                     children: [
//                       Text('Or', style: KSignInButtonOr),
//                       SizedBox(height: 10),
//                       FlatButton.icon(
//                           onPressed: widget.isLoading
//                               ? null
//                               : () => _signInWithGoogle(context),
//                           icon: Icon(FontAwesomeIcons.google),
//                           label: Text(
//                             'Sign In with Google',
//                             style: KSignInButtonText,
//                           )),
//                     ],
//                   ),
//                 ),
//
//                 SizedBox(height: 100),
//                 // ,
//                 // FlatButton.icon(
//                 //     onPressed: () => _signInWithGoogle(context),
//                 //     icon: Icon(FontAwesomeIcons.appleAlt),
//                 //     label: Text('Sign In with Apple')),
//                 // Spacer()
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _tab1() {
//     double height = MediaQuery.of(context).size.height;
//
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Container(
//             height: height * 0.20,
//             child: FlareActor(
//               "assets/Teddy.flr",
//               shouldClip: false,
//               alignment: Alignment.bottomCenter,
//               fit: BoxFit.contain,
//               controller: _teddyController,
//             ),
//           ),
//           MySignInContainer(
//             child: Form(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 // crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   TrackingTextInput(
//                     focusNode: _emailFocusNode,
//                     textInputAction: TextInputAction.next,
//                     onTextChanged: (String email) {
//                       _email = email;
//                       model.updateEmail(email);
//                       print('sign in: $email');
//                     },
//                     onEditingComplete: _emailEditingComplete,
//                     // label: "Email",
//                     // hint: "What's your email address?",
//                     onCaretMoved: (Offset caret) {
//                       _teddyController.lookAt(caret);
//                     },
//                     // icon: Icons.email,
//                     enable: !_isLoading,
//                   ),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Expanded(
//                         child: TrackingTextInput(
//                           focusNode: _passwordFocusNode,
//                           textInputAction: TextInputAction.done,
//                           onTextChanged: (String password) {
//                             _password = password;
//                             model.updatePassword(password);
//                           },
//                           onCaretMoved: (Offset caret) {
//                             _teddyController.coverEyes(caret != null);
//                             _teddyController.lookAt(null);
//                           },
//                           onEditingComplete: _signIn,
//                           // label: "Password",
//                           // hint: "What's your password? ",
//                           isObscured: _isObscured,
//                           // icon: Icons.lock,
//                           enable: !_isLoading,
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(
//                             _isObscured
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                             color: Colors.white38),
//                         onPressed: () {
//                           setState(() {
//                             _isObscured = !_isObscured;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20.0),
//                   _isLoading
//                       ? SpinKitThreeBounce(
//                           color: Colors.white,
//                           size: 25.0,
//                         )
//                       : MyFlatButton(
//                           text: 'Sign In',
//                           onPressed: _signIn,
//                         ),
//                   Row(
//                     children: [
//                       FlatButton(
//                           child: Text('Forgot password.', style: KErrorMessage),
//                           onPressed: _forgotPassword),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _tab2() {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           MySignInContainer(
//             child: Form(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   TrackingTextInput(
//                     focusNode: _emailFocusNode,
//                     textInputAction: TextInputAction.next,
//                     onTextChanged: (String email) {
//                       _email = email;
//                       model.updateEmail(email);
//                     },
//                     onCaretMoved: (Offset caret) {
//                       _teddyController.lookAt(caret);
//                     },
//                     onEditingComplete: _emailEditingComplete,
//                     // label: "Email",
//                     // hint: "What's your email address?",
//                     // icon: Icons.email,
//                     enable: !_isLoading,
//                   ),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Expanded(
//                         child: TrackingTextInput(
//                           focusNode: _passwordFocusNode,
//                           textInputAction: TextInputAction.next,
//                           onTextChanged: (String password) {
//                             _password = password;
//                             model.updatePassword(password);
//                           },
//                           onCaretMoved: (Offset caret) {
//                             _teddyController.coverEyes(caret != null);
//                             _teddyController.lookAt(null);
//                           },
//                           onEditingComplete: _passwordEditingComplete,
//                           // label: "Password",
//                           // hint: "Create a strong password. ",
//                           isObscured: _isObscured,
//                           // icon: Icons.lock,
//                           enable: !_isLoading,
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(
//                             _isObscured
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                             color: Colors.white38),
//                         onPressed: () {
//                           setState(() {
//                             _isObscured = !_isObscured;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Expanded(
//                         child: TrackingTextInput(
//                           focusNode: _passwordFocusNode2,
//                           textInputAction: TextInputAction.done,
//                           onTextChanged: (String password) {
//                             _password2 = password;
//                             model.updatePassword(password);
//                           },
//                           onCaretMoved: (Offset caret) {
//                             _teddyController.coverEyes(caret != null);
//                             _teddyController.lookAt(null);
//                           },
//                           onEditingComplete: _register,
//                           // label: "Password",
//                           // hint: "Confirm your password. ",
//                           isObscured: _isObscured,
//                           // icon: Icons.lock,
//                           enable: !_isLoading,
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(
//                             _isObscured
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                             color: Colors.white38),
//                         onPressed: () {
//                           setState(() {
//                             _isObscured = !_isObscured;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20.0),
//                   _isLoading
//                       ? SpinKitThreeBounce(
//                           color: Colors.white,
//                           size: 25.0,
//                         )
//                       : MyFlatButton(
//                           text: 'Create an account',
//                           onPressed: _register,
//                         ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _signInWithGoogle(BuildContext context) async {
//     try {
//       await manager.signInWithGoogle();
//     } on PlatformException catch (e) {
//       if (e.code != 'ERROR_ABORTED_BY_USER') {
//         _showSignInError(context, e);
//       }
//     }
//   }
//
//   // Future<void> _signInWithGoogle(BuildContext context) async {
//   //   try {
//   //     final AuthService auth = Provider.of<AuthService>(context, listen: false);
//   //     await auth.signInWithGoogle();
//   //   } on PlatformException catch (e) {
//   //     if (e.code != 'ERROR_ABORTED_BY_USER') {
//   //       _showSignInError(context, e);
//   //     }
//   //   }
//   // }
//
//   void _showSignInError(BuildContext context, PlatformException exception) {
//     PlatformExceptionAlertDialog(
//       title: 'Sign in failed',
//       exception: exception,
//     ).show(context);
//   }
//
//   void _emailEditingComplete() {
//     final newFocus =
//         _isEmailValid(_email) // model.emailValidator.isValid(model.email)
//             ? _passwordFocusNode
//             : _emailFocusNode;
//     FocusScope.of(context).requestFocus(newFocus);
//   } //_passwordEditingComplete
//
//   void _passwordEditingComplete() {
//     final newFocus =
//         _isPasswordValid(_password) // model.emailValidator.isValid(model.email)
//             ? _passwordFocusNode2
//             : _passwordFocusNode;
//     FocusScope.of(context).requestFocus(newFocus);
//   }
//
//   //Helper Methods
//   /// Method to validate email id returns true if email is valid
//   bool _isEmailValid(String email) {
//     Pattern pattern =
//         r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//     RegExp regex = RegExp(pattern);
//     if (regex.hasMatch(email))
//       return true;
//     else
//       _teddyController.play('fail');
//     _showSnackBar('Please Enter Valid Email Address.');
//     return false;
//   }
//
//   ///Todo: how to validate a strong password
//   bool _isPasswordValid(String password) {
//     if (password.length > 7)
//       return true;
//     else
//       _teddyController.play('fail');
//     _showSnackBar('Password must be at least 8 characters.');
//     return false;
//   }
//
//   Future<void> _signIn() async {
//     try {
//       if (_email.isEmpty && _password.isEmpty) {
//         _teddyController.play('fail');
//         _showSnackBar('Please Enter Valid Information');
//       } else {
//         if (_isEmailValid(_email)) {
//           _teddyController.play('happy');
//           await model.signIn();
//         } else {
//           _teddyController.play('fail');
//           _showSnackBar('Please Enter Valid Email Address');
//         }
//       }
//     } on PlatformException catch (_) {
//       _teddyController.play('fail');
//       _showSnackBar('Sign in failed');
//       _isLoading = false;
//       setState(() {});
//     }
//   }
//
//   Future<void> _register() async {
//     try {
//       if (_email.isEmpty && _password.isEmpty) {
//         _showSnackBar('Please Enter Valid Information');
//         _teddyController.play('fail');
//       } else {
//         if (_isEmailValid(_email)) {
//           _isLoading = true;
//           setState(() {});
//           // model.updateName(widget.name);
//           await model.register();
//           _teddyController.play('happy');
//         } else {
//           _teddyController.play('fail');
//           _showSnackBar('Please Enter Valid Email Address');
//         }
//       }
//     } on PlatformException catch (_) {
//       _teddyController.play('fail');
//       _showSnackBar('Register failed');
//       _isLoading = false;
//       setState(() {});
//     }
//   }
//
//   Future<void> _forgotPassword() async {
//     try {
//       // auth.sendPasswordResetEmail(email);
//       await model.forgotPassword();
//       // await PlatformAlertDialog(
//       //   title: Strings.resetLinkSentTitle,
//       //   content: Strings.resetLinkSentMessage,
//       //   defaultActionText: Strings.ok,
//       // ).show(context);
//       _teddyController.play('happy');
//     } on PlatformException catch (_) {
//       _showSnackBar(Strings.passwordResetFailed);
//       _teddyController.play('fail');
//       _isLoading = false;
//       setState(() {});
//     }
//   }
//
//   // Todo: implement after sign in success
//   ///  Sign in successful
//   void _signInSuccess() async {
//     await Future.delayed(Duration(seconds: 1));
//     Navigator.of(context).pop();
//   }
//
//   // Todo: implement after sign in fails
//   /// Sign in Fails
//   void _signInFailed() {
//     _showSnackBar('Your email or password is incorrect');
//     _isLoading = false;
//     setState(() {});
//   }
//
//   void _showSnackBar(String title) => _scaffoldKey.currentState.showSnackBar(
//         SnackBar(
//           content: Text(title, textAlign: TextAlign.center),
//         ),
//       );
// }
