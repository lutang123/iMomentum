import 'dart:async';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/strings_sign_in.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/sign_in/apple_sign_in_available.dart';
import 'package:iMomentum/app/sign_in/new_firebase_auth_service.dart';
import 'package:iMomentum/app/sign_in/sign_in_view_model.dart';
import 'package:iMomentum/app/sign_in/sign_in_teddy/teddy_controller.dart';
import 'package:iMomentum/app/sign_in/sign_in_teddy/tracking_text_input.dart';
import 'package:iMomentum/app/utils/pages_routes.dart';
import 'package:iMomentum/app/utils/tooltip_shape_border.dart';
import 'package:iMomentum/app/utils/top_sheet.dart';
import 'package:iMomentum/screens/landing_and_signIn/start_screen2.dart';
import 'package:iMomentum/screens/landing_and_signIn/top_sheet_signIn_info.dart';
import 'package:provider/provider.dart';
import '../../app/sign_in/email_password_sign_in_model.dart';
import 'package:iMomentum/app/utils/extension_firstCaps.dart';
import 'package:iMomentum/app/constants/theme.dart';

typedef void CaretMoved(Offset globalCaretPosition);
typedef void TextChanged(String text);

class StartScreen3 extends StatelessWidget {
  final String name;
  const StartScreen3({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService firebaseAuthService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    return ChangeNotifierProvider<SignInViewModel>(
        create: (_) =>
            SignInViewModel(firebaseAuthService: firebaseAuthService),
        child: Consumer<SignInViewModel>(
            builder: (_, viewModel, __) =>
                ChangeNotifierProvider<EmailPasswordSignInModel>(
                    create: (_) => EmailPasswordSignInModel(
                        firebaseAuthService: firebaseAuthService, name: name),
                    child: Consumer<EmailPasswordSignInModel>(
                        builder: (_, EmailPasswordSignInModel model, __) =>
                            EmailSignInScreenNew._(
                              viewModel: viewModel,
                              userName: name,
                              model: model,
                            )))));
  }
}

class EmailSignInScreenNew extends StatefulWidget {
  const EmailSignInScreenNew._({
    Key key,
    this.viewModel,
    this.userName,
    this.model,
  }) : super(key: key);

  final SignInViewModel viewModel;
  final String userName;
  final EmailPasswordSignInModel model;

  @override
  _EmailSignInScreenNewState createState() => _EmailSignInScreenNewState();
}

class _EmailSignInScreenNewState extends State<EmailSignInScreenNew> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TeddyController _teddyController;
  String _email = '';
  String _password = '';
  bool _isObscured = true;

  final FocusScopeNode _node = FocusScopeNode();

  SignInViewModel get viewModel => widget.viewModel;

  EmailPasswordSignInModel get model => widget.model;

  String userNameFinal;

  @override
  void initState() {
    userNameFinal = widget.userName;

    ///this is wrong too.
    // model.updateName(userNameFinal);
    _teddyController = TeddyController();

    ///wrong
    // _updateUserName(userNameFinal);
    super.initState();
  }

  ///this is wrong too
  // void _updateUserName(String name) {
  //   final AuthService auth = Provider.of<AuthService>(context, listen: false);
  // //The method 'updateProfile' was called on null.
  //   auth.updateUserName(name);
  //   print('StartScreen3 init: ${auth.updateUserName(name)}');
  // }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  double _signInOpacity = 1.0;
  void _showTopSheet() {
    setState(() {
      _signInOpacity = 0.0;
    });
    TopSheet.show(
      context: context,
      child: TopSheetSignInInfo(),
      direction: TopSheetDirection.TOP,
    ).then((value) => setState(() {
          _signInOpacity = 1.0;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageUrl.signInImage),
                fit: BoxFit.cover,
              ),
            ),
            constraints: BoxConstraints.expand()),
        Scaffold(
            backgroundColor: Colors.transparent,
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.of(context).pushReplacement(
                        PageRoutes.fade(
                            () => StartScreen2(name: userNameFinal)),
                      )),
              elevation: 0.0,
              actions: [
                // IconButton(
                //     icon:
                //         Icon(Icons.info_outline, color: Colors.white, size: 30),
                //     onPressed: _showTopSheet),
                FlatButton.icon(
                    label: Text(
                      'Why sign in?',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontStyle: FontStyle.italic),
                    ),
                    icon: Icon(Icons.info_outline,
                        color: Colors.white.withOpacity(0.8)),
                    onPressed: _showTopSheet),
              ],
            ),
            body: Opacity(opacity: _signInOpacity, child: _buildContent())),
      ],
    );
  }

  Widget _buildContent() {
    if (model.isLoading) {
      return Center(
          child: SpinKitDoubleBounce(
        color: Colors.white,
        size: 50.0,
      ));
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          _firstPart(),
          _secondPart(),
          _thirdPart(),
        ],
      ),
    );
  }

  Widget _firstPart() {
    double height = MediaQuery.of(context).size.height;
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: ShapeDecoration(
            color: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
            shape: TooltipShapeBorder(arrowArc: 0.5),
            shadows: [
              BoxShadow(
                  color: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
                  blurRadius: 4.0,
                  offset: Offset(2, 2))
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'Hi, ${userNameFinal.firstCaps}, '
                'I am Teddy. I am here to sign in with you.',
                style: GoogleFonts.getFont(
                  'Architects Daughter',
                  fontSize: 17,
                  color: _darkTheme ? darkThemeWords : lightThemeWords,
                  fontWeight: FontWeight.w400,
                )),
          ),
        ),
        Container(
          height: height * 0.15,
          child: FlareActor(
            "assets/Teddy.flr",
            shouldClip: false,
            alignment: Alignment.bottomCenter,
            fit: BoxFit.contain,
            controller: _teddyController,
          ),
        ),
        MySignInContainer(
          child: FocusScope(
            node: _node,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildEmailField(),
                if (model.formType !=
                    EmailPasswordSignInFormType.forgotPassword) ...<Widget>[
                  SizedBox(height: 5.0),
                  _buildPasswordField(),
                ],
                SizedBox(height: 20.0),
                model.isLoading
                    ? SpinKitThreeBounce(
                        color: _darkTheme ? darkThemeButton : lightThemeButton,
                        size: 25.0,
                      )
                    : MyFlatButton(
                        text: model.primaryButtonText,
                        onPressed: () => _submit(context),
                        color: _darkTheme ? darkThemeButton : lightThemeButton,
                        bkgdColor:
                            _darkTheme ? darkThemeAppBar : lightThemeAppBar,
                      ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    FlatButton(
                      key: Key('secondary-button'),
                      child: Text(model.secondaryButtonText,
                          style: _darkTheme
                              ? KSignInSecondButtonD
                              : KSignInSecondButtonL),
                      onPressed: model.isLoading
                          ? null
                          : () =>
                              _updateFormType(model.secondaryActionFormType),
                    ),
                  ],
                ),
                if (model.formType == EmailPasswordSignInFormType.signIn)
                  Row(
                    children: [
                      FlatButton(
                        key: Key('tertiary-button'),
                        child: Text(StringsSignIn.forgotPasswordQuestion,
                            style: _darkTheme
                                ? KSignInSecondButtonD
                                : KSignInSecondButtonL),
                        onPressed: model.isLoading
                            ? null
                            : () => _updateFormType(
                                EmailPasswordSignInFormType.forgotPassword),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _secondPart() {
    final appleSignInAvailable = Provider.of<AppleSignInAvailable>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Column(
      children: [
        SizedBox(height: 20),
        MySignInContainer(
          child: Column(
            children: [
              Text('Or Sign In with',
                  style: _darkTheme ? KSignInButtonOrD : KSignInButtonOrL),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton.icon(
                      onPressed: model.isLoading ? null : _signInWithGoogle,
                      icon: Icon(
                        FontAwesomeIcons.google,
                        color: _darkTheme ? darkThemeButton : lightThemeButton,
                      ),
                      label: Text('Google',
                          style: _darkTheme
                              ? KSignInButtonTextD
                              : KSignInButtonTextL)),
                  if (appleSignInAvailable.isAvailable) ...[
                    FlatButton.icon(
                        onPressed: model.isLoading ? null : _signInWithApple,
                        icon: Icon(
                          FontAwesomeIcons.apple,
                          color:
                              _darkTheme ? darkThemeButton : lightThemeButton,
                        ),
                        label: Text(
                          'Apple',
                          style: _darkTheme
                              ? KSignInButtonTextD
                              : KSignInButtonTextL,
                        )),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _thirdPart() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Column(
      children: [
        SizedBox(height: 20),
        MySignInContainer(
          child: Column(
            children: [
              Text('Or ',
                  style: _darkTheme ? KSignInButtonOrD : KSignInButtonOrL),
              FlatButton(
                  onPressed: model.isLoading ? null : _showAlert,
                  child: Text(
                    'Just explore',
                    style: _darkTheme ? KSignInButtonTextD : KSignInButtonTextL,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return TrackingTextInput(
      onTextChanged: (String email) {
        _email = email;
        model.updateEmail(email);
      },
      onEditingComplete: _emailEditingComplete,
      onCaretMoved: (Offset caret) {
        _teddyController.lookAt(caret);
      },
      inputDecoration: InputDecoration(
        labelText: StringsSignIn.emailLabel,
        labelStyle: TextStyle(
            fontSize: 16.0,
            color: _darkTheme ? darkThemeHint2 : lightThemeHint2),
        hintText: StringsSignIn.emailHint,
        hintStyle: TextStyle(
            fontSize: 16.0, color: _darkTheme ? darkThemeHint : lightThemeHint),
        errorText: model.emailErrorText,
        enabled: !model.isLoading,
        prefixIcon: Icon(Icons.email,
            color: _darkTheme
                ? darkThemeButton.withOpacity(0.7)
                : lightThemeButton.withOpacity(0.7)),
      ),
    );
  }

  Widget _buildPasswordField() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: TrackingTextInput(
            onTextChanged: (String password) {
              _password = password;
              model.updatePassword(password);
            },
            onEditingComplete: () => _passwordEditingComplete(context),
            onCaretMoved: (Offset caret) {
              _teddyController.coverEyes(caret != null);
              _teddyController.lookAt(null);
            },
            isObscured: _isObscured,
            inputDecoration: InputDecoration(
              labelText: StringsSignIn.passwordLabel,
              labelStyle: TextStyle(
                  fontSize: 16.0,
                  color: _darkTheme ? darkThemeHint2 : lightThemeHint2),
              hintText: model.passwordLabelText,
              hintStyle: TextStyle(
                  fontSize: 16.0,
                  color: _darkTheme ? darkThemeHint : lightThemeHint),
              errorText: model.passwordErrorText,
              enabled: !model.isLoading,
              prefixIcon: Icon(Icons.lock,
                  color: _darkTheme
                      ? darkThemeButton.withOpacity(0.7)
                      : lightThemeButton.withOpacity(0.7)),
            ),
          ),
        ),
        IconButton(
          icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off,
              color: _darkTheme
                  ? darkThemeButton.withOpacity(0.7)
                  : lightThemeButton.withOpacity(0.7)),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),
      ],
    );
  }

  void _showSignInError(
      EmailPasswordSignInModel model, PlatformException exception) {
    _teddyController.play('fail');
    PlatformExceptionAlertDialog(
      title: model.errorAlertTitle,
      exception: exception,
    ).show(context);
    _teddyController.play('fail');
  }

  Future<void> _submit(BuildContext context) async {
    // FocusScope.of(context).unfocus();
    try {
      // if (_email.isEmpty || _password.isEmpty) {
      //   _teddyController.play('fail');
      //   _showSnackBar('Please Enter Valid Information');
      // }

      if (!_isEmailValid(_email)) {
        _teddyController.play('fail');
        _showSnackBar('Please Enter Valid Information');
      } //(!_isPasswordValid(_password))

      if (!_isPasswordValid(_password)) {
        _teddyController.play('fail');
        _showSnackBar('Please Enter Valid Information');
      }

      final bool success = await model.submit();

      if (success == false) {
        _teddyController.play('fail');
      }

      if (success) {
        ///todo, name not update! do not add here
        // model.updateName(userNameFinal);
        // final FirebaseAuthService auth =
        // Provider.of<FirebaseAuthService>(context, listen: false);

        // final User user =
        //     FirebaseAuth.instance.currentUser; //this is current user
        //
        // await user.updateProfile(displayName: userNameFinal);
        // await user.reload();
        //
        // print('user.displayName in startScreen3 _submit: ${user.displayName}');

        ///this got error too
        // final userNameNotifier =
        //     Provider.of<UserNameNotifier>(context, listen: false);
        // userNameNotifier.setUserName(userNameFinal);
        // var prefs = await SharedPreferences.getInstance();
        // prefs.setString('userName', userNameFinal);

        ///this is all wrong; no access to User
        // final AppUser user = Provider.of<AppUser>(context,
        //     listen: false); //
        // user.displayName = userNameFinal;

        _teddyController.play('success');

        if (model.formType == EmailPasswordSignInFormType.forgotPassword) {
          await PlatformAlertDialog(
            title: StringsSignIn.resetLinkSentTitle,
            content: StringsSignIn.resetLinkSentMessage,
            defaultActionText: StringsSignIn.ok,
          ).show(context);
          _teddyController.play('success');
          _updateFormType(EmailPasswordSignInFormType.signIn);
        } else {
          // _teddyController.play('fail');
          ///todo
          // if (widget.onSignedIn != null) {
          //   widget.onSignedIn();
          // }
          ///do not add this
          // Navigator.of(context).pop();
        }
      } else {
        // if fail
        _teddyController.play('fail');
      }

      // } on FirebaseAuthException catch (e) {
      //   if (e.code == 'weak-password') {
      //     print('The password provided is too weak.');
      //   } else if (e.code == 'email-already-in-use') {
      //     print('The account already exists for that email.');
      //   }
      // } catch (e) {
      //   print(e.toString());
      // }

    } on PlatformException catch (e) {
      _teddyController.play('fail');
      _showSignInError(model, e);
    }
  }

  void _emailEditingComplete() {
    if (_email.isEmpty) {
      _teddyController.play('fail');
      _showSnackBar('Please Enter Valid Information');
    }
    if (!_isEmailValid(_email)) {
      _teddyController.play('fail');
      _showSnackBar('Please Enter Valid Information');
    }
    if (model.canSubmitEmail) {
      _teddyController.play('success');
      // delay
      Future.delayed(const Duration(milliseconds: 500));
      _node.nextFocus();
    } else {
      _teddyController.play('fail');
    }
  }

  void _passwordEditingComplete(BuildContext context) {
    // FocusScope.of(context).unfocus();
    if (_password.isEmpty) {
      _teddyController.play('fail');
      _showSnackBar('Please Enter Valid Information');
    }
    if (!_isPasswordValid(_password)) {
      _teddyController.play('fail');
      _showSnackBar('Please Enter Valid Information');
    }

    if (!model.canSubmitEmail) {
      _teddyController.play('fail');
      // delay
      Future.delayed(const Duration(milliseconds: 500));
      _node.previousFocus();
      return;
    }
    _submit(context);
  }

  void _updateFormType(EmailPasswordSignInFormType formType) {
    model.updateFormType(formType);
  }

  Future<void> _signInWithGoogle() async {
    try {
      _teddyController.play('success');
      await viewModel.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError2(context, e);
      }
    }
  }

  Future<void> _signInWithApple() async {
    try {
      await viewModel.signInWithApple();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError2(context, e);
      }
    }
  }

  // Future<void> _signInAnonymously() async {
  //   try {
  //     await manager.signInAnonymously();
  //   } on PlatformException catch (e) {
  //     _showSignInError2(e);
  //   }
  // }

  Future<void> _showAlert() async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Just explore',
      content:
          'You can use iMomentum without sign in, but if you sign out, delete the app or change device, you can not access your account. You will also lose the benefit of syncing your data across multi platform, including iMomentum web version.',
      cancelActionText: 'Cancel',
      defaultActionText: 'Continue',
    ).show(context);
    if (didRequestSignOut == true) {
      _signInAnonymously();
    }

    // await showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return StatefulBuilder(builder: (context, setState) {
    //       return AlertDialog(
    //         contentPadding: EdgeInsets.only(top: 10.0),
    //         backgroundColor: Color(0xf01b262c),
    //         shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.all(Radius.circular(20.0))),
    //         title: Column(
    //           children: <Widget>[
    //             Text("Just explore",
    //                 style: TextStyle(
    //                   fontSize: 20,
    //                   color: Colors.white,
    //                 )),
    //             SizedBox(height: 15),
    //             Text(
    //               'You can use iMomentum without sign in, but if you sign out, delete the app or change device, you can not access your account. You will also lose the benefit of syncing your data across multi platform, including iMomentum web version.',
    //               style: TextStyle(
    //                   fontSize: 16,
    //                   color: Colors.white,
    //                   fontStyle: FontStyle.italic),
    //             )
    //           ],
    //         ),
    //         content: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 15),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             mainAxisSize: MainAxisSize.min,
    //             children: <Widget>[
    //               Padding(
    //                 padding: const EdgeInsets.all(10.0),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     FlatButton(
    //                         child: Text(
    //                           'Cancel',
    //                           style: TextStyle(
    //                               fontSize: 18, color: Colors.lightBlue),
    //                         ),
    //                         onPressed: () => Navigator.of(context).pop()),
    //                     FlatButton(
    //                         child: Text(
    //                           'Stay signed out',
    //                           style: TextStyle(fontSize: 18, color: Colors.red),
    //                         ),
    //                         onPressed: _signInAnonymously),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     });
    //   },
    // );
  }

  Future<void> _signInAnonymously() async {
    try {
      await viewModel.signInAnonymously();
    } catch (e) {
      await _showSignInError2(context, e);
    }
  }

  // Future<void> _showSignInError2(PlatformException exception) async {
  //   await PlatformExceptionAlertDialog(
  //     title: Strings.signInFailed,
  //     exception: exception,
  //   ).show(context);
  // }

  Future<void> _showSignInError2(
      BuildContext context, dynamic exception) async {
    await showExceptionAlertDialog(
      context: context,
      title: StringsSignIn.signInFailed,
      exception: exception,
    );
  }

  //Helper Methods
  /// Method to validate email id returns true if email is valid
  bool _isEmailValid(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (regex.hasMatch(email))
      return true;
    else
      _teddyController.play('fail');
    _showSnackBar('Please Enter Valid Email Address.');
    return false;
  }

  ///Todo: how to validate a strong password
  bool _isPasswordValid(String password) {
    if (password.length > 7)
      return true;
    else
      _teddyController.play('fail');
    _showSnackBar('Password must be at least 8 characters.');
    return false;
  }

  ///  Sign in successful
  // void _signInSuccess() async {
  //   await Future.delayed(Duration(seconds: 1));
  //   Navigator.of(context).pop();
  // }

  // Todo: implement after sign in fails
  /// Sign in Fails

  void _showSnackBar(String title) => _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(title, textAlign: TextAlign.center),
        ),
      );
}
