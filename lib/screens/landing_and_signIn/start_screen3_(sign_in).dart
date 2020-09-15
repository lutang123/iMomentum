import 'dart:async';
import 'package:apple_sign_in/apple_sign_in_button.dart';
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
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/constants/strings.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/sign_in/apple_sign_in_available.dart';
import 'package:iMomentum/app/sign_in/auth_service.dart';
import 'package:iMomentum/app/sign_in/sign_in_manager.dart';
import 'package:iMomentum/app/sign_in_teddy/teddy_controller.dart';
import 'package:iMomentum/app/sign_in_teddy/tracking_text_input.dart';
import 'package:iMomentum/app/utils/pages_routes.dart';
import 'package:iMomentum/app/utils/tooltip_shape_border.dart';
import 'package:iMomentum/app/utils/top_sheet.dart';
import 'package:iMomentum/screens/landing_and_signIn/start_screen2.dart';
import 'package:iMomentum/screens/landing_and_signIn/top_sheet_info_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/sign_in/email_password/email_password_sign_in_model.dart';
import 'package:iMomentum/app/utils/cap_string.dart';

typedef void CaretMoved(Offset globalCaretPosition);
typedef void TextChanged(String text);

class StartScreen3 extends StatelessWidget {
  final String name;
  const StartScreen3({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);

    return ChangeNotifierProvider<ValueNotifier<bool>>(
        create: (_) => ValueNotifier<bool>(false),
        child: Consumer<ValueNotifier<bool>>(
            builder: (_, ValueNotifier<bool> isLoading, __) => Provider<
                    SignInManager>(
                create: (_) => SignInManager(auth: auth, isLoading: isLoading),
                child: Consumer<SignInManager>(
                    builder: (_, SignInManager manager, __) =>
                        ChangeNotifierProvider<EmailPasswordSignInModel>(
                            create: (_) => EmailPasswordSignInModel(
                                auth: auth, name: name),
                            child: Consumer<EmailPasswordSignInModel>(
                                builder: (_, EmailPasswordSignInModel model,
                                        __) =>
                                    EmailSignInScreenNew._(
                                      manager: manager,
                                      model: model, //only model is for email
                                      isLoading: isLoading.value,
                                      userName: name,
                                      // onSignedIn: onSignedIn,
                                    )))))));
  }
}

class EmailSignInScreenNew extends StatefulWidget {
  const EmailSignInScreenNew._({
    @required this.model,
    @required this.manager,
    // this.onSignedIn,
    @required this.isLoading,
    this.userName,
    // this.user,
  });

  final SignInManager manager;
  final EmailPasswordSignInModel model;
  // final VoidCallback onSignedIn;
  final bool isLoading;
  final String userName;
  // final User user;

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

  EmailPasswordSignInModel get model => widget.model;
  SignInManager get manager => widget.manager;

  String userNameFinal;

  @override
  void initState() {
    userNameFinal = widget.userName;
    _teddyController = TeddyController();
    // _updateUserName(userNameFinal);
    super.initState();
  }

  ///this is wrong too
  // void _updateUserName(String name) {
  //   final AuthService auth = Provider.of<AuthService>(context, listen: false);
  //   //The method 'updateProfile' was called on null.
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
      child: TopSheetInfo(),
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
                image: AssetImage(ImageUrl.startImage),
                fit: BoxFit.cover,
              ),
            ),
            constraints: BoxConstraints.expand()),
        Scaffold(
            backgroundColor: Colors.transparent,
            key: _scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.of(context).pushReplacement(
                        PageRoutes.fade(
                            () => StartScreen2(name: userNameFinal)),
                      )),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions: [
                IconButton(
                    icon:
                        Icon(Icons.info_outline, color: Colors.white, size: 30),
                    onPressed: _showTopSheet),
              ],
            ),
            body: Opacity(opacity: _signInOpacity, child: _buildContent())),
      ],
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
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
        ],
      ),
    );
  }

  Widget _firstPart() {
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: ShapeDecoration(
            color: Colors.black12,
            shape: TooltipShapeBorder(arrowArc: 0.5),
            shadows: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 4.0, offset: Offset(2, 2))
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
                  color: Colors.white,
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
                // SizedBox(height: 5),
                _buildEmailField(),
                if (model.formType !=
                    EmailPasswordSignInFormType.forgotPassword) ...<Widget>[
                  SizedBox(height: 5.0),
                  _buildPasswordField(),
                ],
                SizedBox(height: 20.0),
                model.isLoading
                    ? SpinKitThreeBounce(
                        color: Colors.white,
                        size: 25.0,
                      )
                    : MyFlatButton(
                        text: model.primaryButtonText,
                        onPressed: () => _submit(context),
                      ),
                Row(
                  children: [
                    FlatButton(
                      key: Key('secondary-button'),
                      child:
                          Text(model.secondaryButtonText, style: KErrorMessage),
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
                        child: Text(Strings.forgotPasswordQuestion,
                            style: KErrorMessage),
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

    return Column(
      children: [
        SizedBox(height: 30),
        MySignInContainer(
          child: Column(
            children: [
              Text('Or ', style: KSignInButtonOr),
              SizedBox(height: 10),
              FlatButton.icon(
                  onPressed: widget.isLoading ? null : _signInWithGoogle,
                  icon: Icon(FontAwesomeIcons.google, color: Colors.white),
                  label: Text(
                    'Sign In with Google',
                    style: KSignInButtonText,
                  )),
              SizedBox(height: 5),
              if (appleSignInAvailable.isAvailable) ...[
                FlatButton.icon(
                    onPressed: widget.isLoading ? null : _signInWithApple,
                    icon: Icon(FontAwesomeIcons.apple, color: Colors.white),
                    label: Text(
                      'Sign In with Apple',
                      style: KSignInButtonText,
                    )),
                // AppleSignInButton(
                //   //TODO: add key when supported
                //   style: ButtonStyle.black,
                //   type: ButtonType.signIn,
                //   onPressed: widget.isLoading ? null : _signInWithApple,
                // ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
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
        labelText: Strings.emailLabel,
        labelStyle: TextStyle(fontSize: 16.0, color: Colors.white70),
        hintText: Strings.emailHint,
        hintStyle: TextStyle(fontSize: 16.0, color: Colors.white60),
        errorText: model.emailErrorText,
        enabled: !model.isLoading,
        prefixIcon: Icon(Icons.email, color: Colors.white70),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: TrackingTextInput(
            onTextChanged: (String password) {
              _password = password;
              model.updatePassword(password);

              ///todo, name still not update!
              model.updateName(userNameFinal);
            },
            onEditingComplete: () => _passwordEditingComplete(context),
            onCaretMoved: (Offset caret) {
              _teddyController.coverEyes(caret != null);
              _teddyController.lookAt(null);
            },
            isObscured: _isObscured,
            inputDecoration: InputDecoration(
              labelText: Strings.passwordLabel,
              labelStyle: TextStyle(fontSize: 16.0, color: Colors.white70),
              hintText: model.passwordLabelText,
              hintStyle: TextStyle(fontSize: 16.0, color: Colors.white60),
              errorText: model.passwordErrorText,
              enabled: !model.isLoading,
              prefixIcon: Icon(Icons.lock, color: Colors.white70),
            ),
          ),
        ),
        IconButton(
          icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off,
              color: Colors.white60),
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
      if (_email.isEmpty || _password.isEmpty) {
        _teddyController.play('fail');
        _showSnackBar('Please Enter Valid Information');
      }

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
        print('$userNameFinal in startScreen3');

        ///this got error too
        // final userNameNotifier =
        //     Provider.of<UserNameNotifier>(context, listen: false);
        // userNameNotifier.setUserName(userNameFinal);
        // var prefs = await SharedPreferences.getInstance();
        // prefs.setString('userName', userNameFinal);

        ///this is all wrong; no access to User
        // final User user = Provider.of<User>(context, listen: false);
        // widget.user.displayName = userNameFinal;

        _teddyController.play('success');

        if (model.formType == EmailPasswordSignInFormType.forgotPassword) {
          await PlatformAlertDialog(
            title: Strings.resetLinkSentTitle,
            content: Strings.resetLinkSentMessage,
            defaultActionText: Strings.ok,
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
        _teddyController.play('fail');
      }
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
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError2(e);
      }
    }
  }

  Future<void> _signInWithApple() async {
    try {
      await manager.signInWithApple();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError2(e);
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

  Future<void> _showSignInError2(PlatformException exception) async {
    await PlatformExceptionAlertDialog(
      title: Strings.signInFailed,
      exception: exception,
    ).show(context);
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
