import 'dart:async';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/image_path.dart';
import 'package:iMomentum/app/constants/my_strings.dart';
import 'package:iMomentum/app/constants/strings_sign_in.dart';
import 'package:iMomentum/app/sign_in/firebase_auth_service_new.dart';
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
    return
        // ChangeNotifierProvider<SignInViewModel>(
        //   create: (_) =>
        //       SignInViewModel(firebaseAuthService: firebaseAuthService),
        //   child: Consumer<SignInViewModel>(
        //       builder: (_, viewModel, __) =>
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
                    )));
    // ));
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
  String fileName;

  @override
  void initState() {
    userNameFinal = widget.userName;
    _teddyController = TeddyController();
    fileName = "assets/Teddy.flr";
    super.initState();
  }

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
                image: AssetImage(ImagePath.signInImage),
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
                IconButton(
                    // label: Text(
                    //   Strings.whySignIn,
                    //   style: KTopFlatButtonText,
                    // ),
                    icon: Icon(Icons.info_outline, color: topFlatButton),
                    onPressed: _showTopSheet),
              ],
            ),
            body: Opacity(
              opacity: _signInOpacity,
              child: _buildContent(),
            )),
      ],
    );
  }

  Widget _buildContent() {
    ///if alert dialog happens when during sign in, model.isLoading will be true and screen keeps spinning
    // if (model.isLoading) {
    //   return Center(
    //       child: SpinKitDoubleBounce(
    //   ));
    // }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _firstPart(),
            _secondPart(),
          ],
        ),
      ),
    );
  }

  Widget _firstPart() {
    double height = MediaQuery.of(context).size.height;
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    return Column(
      children: [
        teddyGreetingContainer(isKeyboardVisible),
        teddyContainer(height),
        mySignInContainer(),
      ],
    );
  }

  Visibility teddyGreetingContainer(bool isKeyboardVisible) {
    return Visibility(
      visible: isKeyboardVisible ? false : true,
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: 15.0), //same as sign in container
        decoration: shapeDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              '${Strings.hi} ${userNameFinal.firstCaps}, '
              '${Strings.teddy}',
              style: teddyStyle()),
        ),
      ),
    );
  }

  ShapeDecoration shapeDecoration() {
    return ShapeDecoration(
      color: lightThemeAppBar,
      shape: TooltipShapeBorder(arrowArc: 0.5),
      shadows: [
        BoxShadow(
            color: lightThemeAppBar, blurRadius: 4.0, offset: Offset(2, 2))
      ],
    );
  }

  Container teddyContainer(double height) {
    return Container(
      height: height * 0.14,
      child: FlareActor(
        fileName,
        shouldClip: false,
        alignment: Alignment.bottomCenter,
        fit: BoxFit.contain,
        controller: _teddyController,
      ),
    );
  }

  MySignInContainer mySignInContainer() {
    return MySignInContainer(
      child: FocusScope(
        node: _node,
        child: Column(
          children: <Widget>[
            _buildEmailField(),
            if (model.formType !=
                EmailPasswordSignInFormType.forgotPassword) ...<Widget>[
              _buildPasswordField(),
            ],
            SizedBox(height: 10.0),
            MyFlatButton(
              text: model.primaryButtonText,
              onPressed: () => _submit(context),
              color: lightThemeButton,
              // bkgdColor: lightThemeAppBar,
            ),
            Row(
              children: [
                Flexible(
                  child:
                      // FlatButton(
                      //   key: Key('secondary-button'),
                      //   child:

                      InkWell(
                    onTap: () => _updateFormType(model.secondaryActionFormType),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(model.secondaryButtonText,
                          style: KSignInSecondButton),
                    ),
                  ),
                  //   onPressed: () =>
                  //       _updateFormType(model.secondaryActionFormType),
                  // ),
                ),
              ],
            ),
            if (model.formType == EmailPasswordSignInFormType.signIn)
              Row(
                children: [
                  Flexible(
                    child:
                        // FlatButton(
                        //   key: Key('tertiary-button'),
                        //   child:
                        InkWell(
                      onTap: () => _updateFormType(
                          EmailPasswordSignInFormType.forgotPassword),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(StringsSignIn.forgotPasswordQuestion,
                            style: KSignInSecondButton),
                      ),
                    ),

                    //   onPressed: () => _updateFormType(
                    //       EmailPasswordSignInFormType.forgotPassword),
                    // ),
                  ),
                ],
              ),
            // if (model.formType !=
            //     EmailPasswordSignInFormType.forgotPassword) ...<Widget>[
            //   // _termPolicy(),
            // ],
          ],
        ),
      ),
    );
  }

  Widget _secondPart() {
    // final appleSignInAvailable = Provider.of<AppleSignInAvailable>(context);
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        sizedBox(height),
        // Platform.isIOS
        //     ? Container()
        //     : mySignInContainerSocial(
        //         'Sign up with Google', _signInWithGoogle, height),
        // if (appleSignInAvailable.isAvailable) ...[
        //   mySignInContainerSocial(
        //       'Sign up with Apple', _signInWithApple, height)
        // ],
        mySignInContainerJustExplore(),
      ],
    );
  }

  Column mySignInContainerSocial(text, onTap, height) {
    return Column(
      children: [
        MySignInContainer(
          child: InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: KSignInButton,
                )
              ],
            ),
          ),
        ),
        sizedBox(height),
      ],
    );
  }

  SizedBox sizedBox(double height) => SizedBox(height: height > 700 ? 25 : 15);

  MySignInContainer mySignInContainerJustExplore() {
    return MySignInContainer(
      child: InkWell(
        onTap: _showAlert,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Or stay signed out: ', style: KSignUpOr),
            SizedBox(width: 3),
            Text(
              'Just Explore',
              style: KSignInButton,
            ),
          ],
        ),
      ),
    );
  }

  ///this one no padding
  Widget rowFlatButtonIcon(icon, text, onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // s
          Text(text, style: KSignInButton)
        ],
      ),
    );
  }

  UnderlineInputBorder underlineInputBorder() {
    return UnderlineInputBorder(
        borderSide: BorderSide(color: lightThemeDivider));
  }

  TextStyle teddyStyle() {
    return GoogleFonts.getFont(
      'Architects Daughter',
      fontSize: 14,
      color: lightThemeWords,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle textStyleHintAndLabel() =>
      TextStyle(fontSize: 16.0, color: lightThemeHint);

  Widget _buildEmailField() {
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
        labelStyle: textStyleHintAndLabel(),
        hintText: StringsSignIn.emailHint,
        hintStyle: textStyleHintAndLabel(),

        ///we can not have this otherwise it always show empty error before user input
        // errorText: model.emailErrorText,
        // enabled: !model.isLoading,
        prefixIcon: Icon(Icons.email, color: lightThemeButton.withOpacity(0.7)),
        focusedBorder: underlineInputBorder(),
        enabledBorder: underlineInputBorder(),
      ),
    );
  }

  Widget _buildPasswordField() {
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
              labelStyle: textStyleHintAndLabel(),
              hintText: model.passwordLabelText,
              hintStyle: textStyleHintAndLabel(),
              prefixIcon:
                  Icon(Icons.lock, color: lightThemeButton.withOpacity(0.7)),
              focusedBorder: underlineInputBorder(),
              enabledBorder: underlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off,
              color: lightThemeButton.withOpacity(0.7)),
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
    if (!_isEmailValid(_email)) {
      _teddyController.play('fail');
    }
    if (model.canSubmitEmail) {
      _teddyController.play('success');
      Future.delayed(const Duration(milliseconds: 200));
      _node.nextFocus();
    } else {
      _teddyController.play('fail');
    }
  }

  void _passwordEditingComplete(BuildContext context) {
    if (_password.isEmpty) {
      _teddyController.play('fail');
    }
    if (!_isPasswordValid(_password)) {
      _teddyController.play('fail');
    }
    if (model.canSubmitEmail) {
      _teddyController.play('success');
      Future.delayed(const Duration(milliseconds: 200));
      _submit(context);
    } else {
      _teddyController.play('fail');
      _node.previousFocus();
      return;
    }
  }

  void _updateFormType(EmailPasswordSignInFormType formType) {
    model.updateFormType(formType);
    emailTextController.clear();
    passwordTextController.clear();
  }

  Future<void> _submit(BuildContext context) async {
    // FocusScope.of(context).unfocus(); //no need
    try {
      if (!_isEmailValid(_email)) {
        _teddyController.play('fail');
      }

      if (!_isPasswordValid(_password)) {
        _teddyController.play('fail');
      }

      ///from ProgressDialog plugin
      final ProgressDialog pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: true,
      );
      progressDialogStyle(pr);
      await pr.show();
      final bool success = await model.submit(context);
      await pr.hide();
      if (success) {
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
      final ProgressDialog pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: true,
      );
      progressDialogStyle(pr);
      await pr.show();
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

  // Future<void> _signInWithApple() async {
  //   final FirebaseAuthService firebaseAuthService =
  //       Provider.of<FirebaseAuthService>(context, listen: false);
  //   try {
  //     _teddyController.play('success');
  //     final ProgressDialog pr = ProgressDialog(
  //       context,
  //       type: ProgressDialogType.Normal,
  //       isDismissible: true,
  //     );
  //     progressDialogStyle(pr);
  //     await pr.show();
  //     // await firebaseAuthService.signInWithApple();
  //     await pr.hide();
  //   } on PlatformException catch (e) {
  //     _teddyController.play('fail'); // added
  //     if (e.code != 'ERROR_ABORTED_BY_USER') {
  //       _showSignInError(context, e);
  //     }
  //     _showSignInError(context, e); // added
  //   }
  // }

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
      final ProgressDialog pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: true,
      );
      progressDialogStyle(pr);
      await pr.show();
      await firebaseAuthService.signInAnonymously(name: userNameFinal);
      await pr.hide();
    } catch (e) {
      _teddyController.play('fail');
      _showSignInError(context,
          e); // must have this because sometime if sign in and out too much times, it will have error too.
    }
  }

  void progressDialogStyle(ProgressDialog pr) {
    return pr.style(
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
  }

  /// notes on previous SignInError
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
          content: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: lightThemeNoPhotoColor,
        ),
      );
}
