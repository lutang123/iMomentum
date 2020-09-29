import 'dart:async';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/my_strings.dart';
import 'package:iMomentum/app/constants/strings_sign_in.dart';
import 'package:iMomentum/app/sign_in/apple_sign_in_available.dart';
import 'package:iMomentum/app/sign_in/firebase_auth_service_new.dart';
import 'package:iMomentum/app/sign_in/not_in_use/sign_in_view_model.dart';
import 'package:iMomentum/app/sign_in/sign_in_teddy/teddy_controller.dart';
import 'package:iMomentum/app/sign_in/sign_in_teddy/tracking_text_input.dart';
import 'package:iMomentum/app/utils/pages_routes.dart';
import 'package:iMomentum/app/utils/tooltip_shape_border.dart';
import 'package:iMomentum/app/utils/top_sheet.dart';
import 'package:iMomentum/screens/landing_and_signIn/start_screen2.dart';
import 'package:iMomentum/screens/landing_and_signIn/top_sheet_signIn_info.dart';
import 'package:iMomentum/screens/landing_and_signIn/top_sheet_sign_in_light.dart';
import 'package:progress_dialog/progress_dialog.dart';
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
                            KeyboardDismissOnTap(
                              child: KeyboardVisibilityProvider(
                                child: EmailSignInScreenNew._(
                                  // viewModel: viewModel,
                                  userName: name,
                                  model: model,
                                ),
                              ),
                            )))));
  }
}

class EmailSignInScreenNew extends StatefulWidget {
  const EmailSignInScreenNew._({
    Key key,
    // this.viewModel,
    this.userName,
    this.model,
  }) : super(key: key);

  // final SignInViewModel viewModel;
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
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  // SignInViewModel get viewModel => widget.viewModel;

  EmailPasswordSignInModel get model => widget.model;

  String userNameFinal;

  @override
  void initState() {
    userNameFinal = widget.userName;
    _teddyController = TeddyController();
    super.initState();
  }

  ///this is wrong (updateUserName)
  // void _updateUserName(String name) {
  //   final AuthService auth = Provider.of<AuthService>(context, listen: false);
  // //The method 'updateProfile' was called on null.
  //   auth.updateUserName(name);
  //   print('StartScreen3 init: ${auth.updateUserName(name)}');
  // }

  @override
  void dispose() {
    _node.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  double _signInOpacity = 1.0;
  void _showTopSheet() {
    setState(() {
      _signInOpacity = 0.0;
    });
    TopSheetLight.show(
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
    ///if alert dialog happens when during sign in, model.isLoading will be true and screen keeps spinning
    // if (model.isLoading) {
    //   return Center(
    //       child: SpinKitDoubleBounce(
    //     color: Colors.white,
    //     size: 50.0,
    //   ));
    // }
    return SingleChildScrollView(
      child: Column(
        children: [
          _firstPart(),
          _secondPart(),
          // _thirdPart(),
        ],
      ),
    );
  }

  Widget _firstPart() {
    double height = MediaQuery.of(context).size.height;
    // final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    // bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    return Column(
      children: [
        Visibility(
          visible: isKeyboardVisible ? false : true,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: ShapeDecoration(
              color:
                  // _darkTheme ? darkThemeAppBar :
                  lightThemeAppBar,
              shape: TooltipShapeBorder(arrowArc: 0.5),
              shadows: [
                BoxShadow(
                    color:
                        // _darkTheme ? darkThemeAppBar :
                        lightThemeAppBar,
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
                    fontSize: 14,
                    color:
                        // _darkTheme ? darkThemeWords :
                        lightThemeWords,
                    fontWeight: FontWeight.w400,
                  )),
            ),
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
              children: <Widget>[
                _buildEmailField(),
                if (model.formType !=
                    EmailPasswordSignInFormType.forgotPassword) ...<Widget>[
                  SizedBox(height: 5.0),
                  _buildPasswordField(),
                ],
                SizedBox(height: 15.0),
                // model.isLoading
                // ? SpinKitThreeBounce(
                //     color: _darkTheme ? darkThemeButton : lightThemeButton,
                //     size: 25.0,
                //   )
                // :
                MyFlatButton(
                  text: model.primaryButtonText,
                  onPressed: () => _submit(context),
                  color:
                      // _darkTheme ? darkThemeButton :
                      lightThemeButton,
                  bkgdColor:
                      // _darkTheme ? darkThemeAppBar :
                      lightThemeAppBar,
                ),
                Row(
                  children: [
                    FlatButton(
                      key: Key('secondary-button'),
                      child: Text(model.secondaryButtonText,
                          style:
                              // _darkTheme
                              //     ? KSignInSecondButtonD
                              //     :
                              KSignInSecondButtonL),
                      onPressed:
                          // model.isLoading
                          //     ? null
                          //     :
                          () => _updateFormType(model.secondaryActionFormType),
                    ),
                  ],
                ),
                if (model.formType == EmailPasswordSignInFormType.signIn)
                  Row(
                    children: [
                      FlatButton(
                        key: Key('tertiary-button'),
                        child: Text(StringsSignIn.forgotPasswordQuestion,
                            style:
                                // _darkTheme
                                //     ? KSignInSecondButtonD
                                //     :
                                KSignInSecondButtonL),
                        onPressed:
                            // model.isLoading
                            //     ? null
                            //     :
                            () => _updateFormType(
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
    // final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    // bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Column(
      children: [
        SizedBox(height: 20),
        (appleSignInAvailable.isAvailable)
            ? Column(
                children: [
                  MySignInContainer(
                    child: Column(
                      children: [
                        Text('Or Sign In with: ',
                            style:
                                // _darkTheme
                                //     ? KSignInButtonOrD
                                //     :
                                KSignInButtonOrL),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton.icon(
                                onPressed:
                                    // model.isLoading ? null :
                                    _signInWithGoogle,
                                icon: Icon(
                                  FontAwesomeIcons.google,
                                  color:
                                      // _darkTheme
                                      //     ? darkThemeButton
                                      //     :
                                      lightThemeButton,
                                ),
                                label: Text('Google',
                                    style:
                                        // _darkTheme
                                        //     ? KSignInButtonTextD
                                        //     :
                                        KSignInButtonTextL)),
                            if (appleSignInAvailable.isAvailable) ...[
                              FlatButton.icon(
                                  onPressed:
                                      // model.isLoading ? null :
                                      _signInWithApple,
                                  icon: Icon(
                                    FontAwesomeIcons.apple,
                                    color:
                                        // _darkTheme
                                        //     ? darkThemeButton
                                        //     :
                                        lightThemeButton,
                                  ),
                                  label: Text(
                                    'Apple',
                                    style:
                                        // _darkTheme
                                        //     ? KSignInButtonTextD
                                        //     :
                                        KSignInButtonTextL,
                                  )),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  MySignInContainer(
                    child: Column(
                      children: [
                        Text(
                          'Or Stay signed out',
                          style: TextStyle(
                              fontSize: 14,
                              color:
                                  // _darkTheme
                                  //     ? Colors.white.withOpacity(0.8)
                                  //     :
                                  Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic),
                        ),
                        FlatButton(
                            onPressed:
                                // model.isLoading ? null :
                                _showAlert,
                            child: Text(
                              'Just explore',
                              style:
                                  // _darkTheme
                                  //     ? KSignInButtonTextD
                                  //     :
                                  KSignInButtonTextL,
                            )),
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MySignInContainer(
                    child: Column(
                      children: [
                        Text('Or Sign In with: ',
                            style:
                                // _darkTheme
                                //     ? KSignInButtonOrD
                                //     :
                                KSignInButtonOrL),
                        FlatButton.icon(
                            onPressed:
                                // model.isLoading ? null :
                                _signInWithGoogle,
                            icon: Icon(
                              FontAwesomeIcons.google,
                              color:
                                  // _darkTheme
                                  //     ? darkThemeButton
                                  //     :
                                  lightThemeButton,
                            ),
                            label: Text('Google',
                                style:
                                    // _darkTheme
                                    //     ? KSignInButtonTextD
                                    //     :
                                    KSignInButtonTextL)),
                      ],
                    ),
                  ),
                  MySignInContainer(
                    child: Column(
                      children: [
                        Text('Or Stay signed out',
                            style:
                                // _darkTheme
                                //     ? KSignInButtonOrD
                                //     :
                                KSignInButtonOrL),
                        FlatButton(
                            onPressed:
                                // model.isLoading ? null :
                                _showAlert,
                            child: Text(
                              'Just explore',
                              style:
                                  // _darkTheme
                                  //     ? KSignInButtonTextD
                                  //     :
                                  KSignInButtonTextL,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildEmailField() {
    // final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    // bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return TrackingTextInput(
      textController: emailTextController,
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
            color:
                // _darkTheme ? darkThemeHint2 :
                lightThemeHint2),
        hintText: StringsSignIn.emailHint,
        hintStyle: TextStyle(
            fontSize: 16.0,
            color:
                // _darkTheme ? darkThemeHint :
                lightThemeHint),
        // errorText: model.emailErrorText,
        // enabled: !model.isLoading,
        prefixIcon: Icon(Icons.email,
            color:
                // _darkTheme
                //     ? darkThemeButton.withOpacity(0.7)
                //     :
                lightThemeButton.withOpacity(0.7)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: lightThemeDivider)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: lightThemeDivider)),
      ),
    );
  }

  Widget _buildPasswordField() {
    // final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    // bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: TrackingTextInput(
            textController: passwordTextController,
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
                  color:
                      // _darkTheme ? darkThemeHint2 :
                      lightThemeHint2),
              hintText: model.passwordLabelText,
              hintStyle: TextStyle(
                  fontSize: 16.0,
                  color:
                      // _darkTheme ? darkThemeHint :
                      lightThemeHint),
              // errorText: model.passwordErrorText,
              // enabled: !model.isLoading,
              prefixIcon: Icon(Icons.lock,
                  color:
                      // _darkTheme
                      //     ? darkThemeButton.withOpacity(0.7)
                      //     :
                      lightThemeButton.withOpacity(0.7)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: lightThemeDivider)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: lightThemeDivider)),
            ),
          ),
        ),
        IconButton(
          icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off,
              color:
                  // _darkTheme
                  //     ? darkThemeButton.withOpacity(0.7)
                  //     :
                  lightThemeButton.withOpacity(0.7)),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),
      ],
    );
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
      // Future.delayed(const Duration(milliseconds: 500));
      _node.nextFocus();
    } else {
      _teddyController.play('fail');
    }
  }

  void _passwordEditingComplete(BuildContext context) {
    // FocusScope.of(context).unfocus(); //no need
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
      // Future.delayed(const Duration(milliseconds: 500));
      _node.previousFocus();
      return;
    }
    _submit(context);
  }

  void _updateFormType(EmailPasswordSignInFormType formType) {
    model.updateFormType(formType);
    emailTextController.clear();
    passwordTextController.clear();
  }

  Future<void> _submit(BuildContext context) async {
    // FocusScope.of(context).unfocus(); //no need
    try {
      if (_email.isEmpty || _password.isEmpty) {
        _teddyController.play('fail');
        _showSnackBar('Please Enter Valid Information');
      }

      if (!_isEmailValid(_email)) {
        _teddyController.play('fail');
        _showSnackBar('Please Enter Valid Information');
      }

      if (!_isPasswordValid(_password)) {
        _teddyController.play('fail');
        _showSnackBar('Please Enter Valid Information');
      }

      ///from ProgressDialog plugin
      final ProgressDialog pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        // textDirection: TextDirection.rtl,
        isDismissible: true,
      );
      pr.style(
        message: 'Please wait',
        borderRadius: 20.0,
        backgroundColor: darkThemeNoPhotoColor,
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        progressWidgetAlignment: Alignment.center,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600),
      );

      await pr.show();

      ///original
      final bool success = await model.submit(context);
      // print('success: $success');
      await pr.hide();

      if (success) {
        print('success');
        _teddyController.play('success');
        if (model.formType == EmailPasswordSignInFormType.forgotPassword) {
          await PlatformAlertDialog(
            title: StringsSignIn.resetLinkSentTitle,
            content: StringsSignIn.resetLinkSentMessage,
            defaultActionText: StringsSignIn.ok,
          ).show(context);
          _teddyController.play('success');
          _updateFormType(EmailPasswordSignInFormType.signIn);
        }

        /// this didn't show, once we hit signIn button, if success, we directly go to home screen
        // if (model.formType == EmailPasswordSignInFormType.register) {
        //   await PlatformAlertDialog(
        //     title: 'Verification link sent',
        //     content: 'Please check your email to verify your account.',
        //     defaultActionText: 'OK',
        //   ).show(context);
        //   print('show verify dialog? ');
        // }

      }
    } catch (e) {
      _teddyController.play('fail');
      _showSignInError(context, e); // changed this as dynamic exception
    }
  }

  Future<void> _signInWithGoogle() async {
    final FirebaseAuthService firebaseAuthService =
        Provider.of<FirebaseAuthService>(context, listen: false);

    try {
      _teddyController.play('success');

      ///from ProgressDialog plugin
      final ProgressDialog pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        // textDirection: TextDirection.rtl,
        isDismissible: true,
      );
      pr.style(
        message: 'Please wait',
        borderRadius: 20.0,
        backgroundColor: darkThemeNoPhotoColor,
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        progressWidgetAlignment: Alignment.center,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600),
      );

      await pr.show();

      // await viewModel.signInWithGoogle();

      await firebaseAuthService.signInWithGoogle();

      await pr.hide();
    } on PlatformException catch (e) {
      _teddyController.play('fail'); // added
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
      _showSignInError(context, e); // added
    }
  }

  Future<void> _signInWithApple() async {
    final FirebaseAuthService firebaseAuthService =
        Provider.of<FirebaseAuthService>(context, listen: false);

    try {
      _teddyController.play('success');

      ///from ProgressDialog plugin
      final ProgressDialog pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        // textDirection: TextDirection.rtl,
        isDismissible: true,
      );
      pr.style(
        message: 'Please wait',
        borderRadius: 20.0,
        backgroundColor: darkThemeNoPhotoColor,
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        progressWidgetAlignment: Alignment.center,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600),
      );

      await pr.show();

      // await viewModel.signInWithApple();
      await firebaseAuthService.signInWithApple();

      await pr.hide();
    } on PlatformException catch (e) {
      _teddyController.play('fail'); // added
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
      _showSignInError(context, e); // added
    }
  }

  Future<void> _showAlert() async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Stay stayed out',
      content: Strings.signInAnonymouslyWarning,
      cancelActionText: 'Cancel',
      defaultActionText: 'Continue',
    ).show(context);
    if (didRequestSignOut == true) {
      _signInAnonymously();
    }
  }

  Future<void> _signInAnonymously() async {
    final FirebaseAuthService firebaseAuthService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    try {
      _teddyController.play('success');

      ///from ProgressDialog plugin
      final ProgressDialog pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        // textDirection: TextDirection.rtl,
        isDismissible: true,
      );
      pr.style(
        message: 'Please wait',
        borderRadius: 20.0,
        backgroundColor: darkThemeNoPhotoColor,
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        progressWidgetAlignment: Alignment.center,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600),
      );

      await pr.show();

      // await viewModel.signInAnonymously();
      await firebaseAuthService.signInAnonymously(name: userNameFinal);

      await pr.hide();
    } catch (e) {
      _teddyController.play('fail');
      _showSignInError(context, e);
    }
  }

  /// notes on previous SignInError
  // void _showSignInError(
  //     EmailPasswordSignInModel model, PlatformException exception) {
  //   _teddyController.play('fail');
  //   PlatformExceptionAlertDialog(
  //     title: model.errorAlertTitle,
  //     exception: exception,
  //   ).show(context);
  // }

  // Future<void> _showSignInError2(PlatformException exception) async {
  //   await PlatformExceptionAlertDialog(
  //     title: Strings.signInFailed,
  //     exception: exception,
  //   ).show(context);
  // }

  Future<void> _showSignInError(BuildContext context, dynamic exception) async {
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
    if (regex.hasMatch(email)) {
      _teddyController.play('success');
      return true;
    } else {
      _teddyController.play('fail');
      _showSnackBar('Please Enter Valid Email Address.');
      return false;
    }
  }

  ///Todo: how to validate a strong password
  bool _isPasswordValid(String password) {
    if (password.length > 7) {
      _teddyController.play('success');
      return true;
    } else {
      _teddyController.play('fail');
      _showSnackBar('Password must be at least 8 characters.');
      return false;
    }
  }

  void _showSnackBar(String title) => _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(title, textAlign: TextAlign.center),
        ),
      );
}
