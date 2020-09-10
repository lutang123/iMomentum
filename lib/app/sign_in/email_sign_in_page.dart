import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/services/auth.dart';
import 'package:iMomentum/app/sign_in_teddy/input_helper.dart';
import 'package:iMomentum/app/sign_in_teddy/teddy_controller.dart';
import 'package:iMomentum/app/sign_in_teddy/tracking_text_input.dart';
import 'package:provider/provider.dart';
import 'email_sign_in_change_model.dart';

typedef void CaretMoved(Offset globalCaretPosition);
typedef void TextChanged(String text);

class EmailSignInPage extends StatefulWidget {
  EmailSignInPage({@required this.model, this.auth, this.name});
  final EmailSignInChangeModel model;
  final AuthBase auth;
  final String name;

  static Widget create(BuildContext context, AuthBase auth, String name) {
    ///todo
    // final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (context) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, _) =>
            EmailSignInPage(model: model, auth: auth, name: name),
      ),
    );
  }

  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final GlobalKey _fieldKey = GlobalKey();

  TeddyController _teddyController;
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _isObscured = true;

  // final TextEditingController _nameController = TextEditingController();

  final TextEditingController textController = TextEditingController();

  // final TextEditingController _passwordController = TextEditingController();

  // final FocusNode _nameFocusNode = FocusNode();

  final FocusNode _emailFocusNode = FocusNode();

  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

  // Timer _debounceTimer;

  @override
  initState() {
    // textController.addListener(() {
    //   // We debounce the listener as sometimes the caret position is updated after the listener
    //   // this assures us we get an accurate caret position.
    //   if (_debounceTimer?.isActive ?? false) _debounceTimer.cancel();
    //   _debounceTimer = Timer(const Duration(milliseconds: 100), () {
    //     if (_fieldKey.currentContext != null) {
    //       // Find the render editable in the field.
    //       final RenderObject fieldBox =
    //           _fieldKey.currentContext.findRenderObject();
    //       Offset caretPosition = getCaretPosition(fieldBox);
    //
    //       if (_onCaretMoved != null) {
    //         _onCaretMoved(caretPosition);
    //       }
    //     }
    //   });
    //   if (_onTextChanged != null) {
    //     _onTextChanged(textController.text);
    //   }
    // });

    _teddyController = TeddyController();

    super.initState();
  }

  @override
  void dispose() {
    // _nameController.dispose();
    textController.dispose();
    // _passwordController.dispose();
    // _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   _teddyController = TeddyController();
  //   super.initState();
  // }

  ///on password
  void _onCaretMoved(Offset caret) {
    _teddyController.coverEyes(caret != null);
    _teddyController.lookAt(null);
  }

  void _onTextChanged(String password) {
    _password = password;
    model.updatePassword(password);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/forest2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: height * 0.25,
                  child: FlareActor(
                    "assets/Teddy.flr",
                    shouldClip: false,
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.contain,
                    controller: _teddyController,
                  ),
                ),
//                 Card(
// //            child: EmailSignInFormStateful(),
//                   child: EmailSignInFormChangeNotifier.create(context),
//                 ),
                Container(
                  height: height * 0.45,
                  margin: const EdgeInsets.symmetric(horizontal: 15.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TrackingTextInput(
                          textController: textController,
                          // key: _fieldKey,
                          focusNode: _emailFocusNode,
                          onTextChanged: (String email) {
                            _email = email;
                            model.updateEmail(email);
                          },
                          onEditingComplete: () => _emailEditingComplete(),
                          label: "Email",
                          hint: "What's your email address?",
                          onCaretMoved: (Offset caret) {
                            _teddyController.lookAt(caret);
                          },
                          icon: Icons.email,
                          enable: !_isLoading,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: TrackingTextInput(
                                textController: textController,
                                // key: _fieldKey,
                                focusNode: _passwordFocusNode,
                                onTextChanged: _onTextChanged,
                                onEditingComplete: _submit,
                                label: "Password",
                                hint: "Create a strong password",
                                isObscured: _isObscured,
                                onCaretMoved: _onCaretMoved,

                                // onTextChanged: (String value) {
                                //   _teddyController.setPassword(value);
                                // },

                                icon: Icons.lock,
                                enable: !_isLoading,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                  _isObscured
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black45),
                              onPressed: () {
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        RaisedButton(
                          child: _isLoading
                              ? SpinKitThreeBounce(
                                  color: Colors.white,
                                  size: 25.0,
                                )
                              : Text(
                                  model.primaryButtonText,
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                          highlightElevation: 0.0,
                          onPressed: model.canSubmit ? _submit : null,
                        ),
                        SizedBox(height: 8.0),
                        FlatButton(
                          child: Text(
                            model.secondaryButtonText,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: !model.isLoading ? _toggleFormType : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //make keyboard go to next field only when the email field is valid
  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
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
      return false;
  }

  Future<void> _submit() async {
    if (_email.isEmpty && _password.isEmpty) {
      _showSnackBar('Please Enter Valid Information');
      _teddyController.play('fail');
    } else {
      if (_isEmailValid(_email)) {
        _isLoading = true;
        setState(() {});
        bool signInSuccess = await _teddyController.checkEmailPassword(
          email: _email,
          password: _password,
        );
        if (signInSuccess)
          _signInSuccess();
        else
          _signInFailed();
      } else {
        _teddyController.play('fail');
        _showSnackBar('Please Enter Valid Email Address');
      }
    }

    try {
      model.updateName(widget.name);
      await model.submit();
      _teddyController.play('happy');
    } on PlatformException catch (e) {
      _teddyController.play('fail');
      _showSnackBar('Sign in failed');
      _isLoading = false;
      setState(() {});
      // PlatformExceptionAlertDialog(
      //   title: 'Sign in failed',
      //   exception: e,
      // ).show(context);
    }
  }

  //toggle form and clear content
  void _toggleFormType() {
    model.toggleFormType();
    textController.clear();
    // _nameController.clear();
    // _emailController.clear();
    // _passwordController.clear();
  }

  // Todo: implement after sign in success
  ///  Sign in successful
  void _signInSuccess() async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(context).pop();
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => Home(),
    //   ),
    // );
  }

  // Todo: implement after sign in fails
  /// Sign in Fails
  void _signInFailed() {
    _showSnackBar('Your email or password is incorrect');
    _isLoading = false;
    setState(() {});
  }

  void _showSnackBar(String title) => _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(title, textAlign: TextAlign.center),
        ),
      );
}
