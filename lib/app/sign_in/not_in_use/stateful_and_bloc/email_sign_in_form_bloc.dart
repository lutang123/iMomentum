// import 'package:flutter/material.dart';
// import 'package:iMomentum/app/common_widgets/form_submit_button.dart';
// import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
// import 'package:iMomentum/app/services/auth.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/services.dart';
// import '../validators.dart';
// import 'email_sign_in_model.dart';
//
// class EmailSignInFormBloc extends StatefulWidget
//     with EmailAndPasswordValidators {
//   EmailSignInFormBloc({this.onSignedIn});
//   final VoidCallback onSignedIn;
//   @override
//   _EmailSignInFormBlocState createState() => _EmailSignInFormBlocState();
// }
//
// class _EmailSignInFormBlocState extends State<EmailSignInFormBloc> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final FocusNode _nameFocusNode = FocusNode();
//   final FocusNode _emailFocusNode = FocusNode();
//   final FocusNode _passwordFocusNode = FocusNode();
//
//   //same as having a variable and then assign value?
//   String get _name => _nameController.text;
//   String get _email => _emailController.text;
//   String get _password => _passwordController.text;
//   EmailSignInFormType _formType = EmailSignInFormType.signIn;
//   bool _submitted = false;
//   bool _isLoading = false;
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _nameFocusNode.dispose();
//     _emailFocusNode.dispose();
//     _passwordFocusNode.dispose();
//     super.dispose();
//   }
//
//   Future<void> _submit() async {
//     setState(() {
//       _submitted = true;
//       _isLoading = true;
//     });
//     try {
//       ///todo
//       final auth = Provider.of<AuthBase>(context, listen: false);
//       if (_formType == EmailSignInFormType.signIn) {
//         await auth.signInWithEmailAndPassword(_name, _email, _password);
//       } else {
//         await auth.createUserWithEmailAndPassword(_name, _email, _password);
//       }
//       if (widget.onSignedIn != null) {
//         widget.onSignedIn();
//       }
//     } on PlatformException catch (e) {
//       PlatformExceptionAlertDialog(
//         title: 'Sign in failed',
//         exception: e,
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _nameEditingComplete() {
//     final newFocus =
//         widget.nameValidator.isValid(_name) ? _emailFocusNode : _nameFocusNode;
//     FocusScope.of(context).requestFocus(newFocus);
//   }
//
//   void _emailEditingComplete() {
//     final newFocus = widget.emailValidator.isValid(_email)
//         ? _passwordFocusNode
//         : _emailFocusNode;
//     FocusScope.of(context).requestFocus(newFocus);
//   }
//
//   void _toggleFormType() {
//     setState(() {
//       _submitted = false;
//       _formType = _formType == EmailSignInFormType.signIn
//           ? EmailSignInFormType.register
//           : EmailSignInFormType.signIn;
//     });
//     _emailController.clear();
//     _passwordController.clear();
//   }
//
//   List<Widget> _buildChildren() {
//     final primaryText = _formType == EmailSignInFormType.signIn
//         ? 'Sign in'
//         : 'Create an account';
//     final secondaryText = _formType == EmailSignInFormType.signIn
//         ? 'Need an account? Register'
//         : 'Have an account? Sign in';
//
//     bool submitEnabled = widget.emailValidator.isValid(_email) &&
//         widget.passwordValidator.isValid(_password) &&
//         !_isLoading;
//
//     return [
//       _buildNameTextField(),
//       SizedBox(height: 8.0),
//       _buildEmailTextField(),
//       SizedBox(height: 8.0),
//       _buildPasswordTextField(),
//       SizedBox(height: 8.0),
//       FormSubmitButton(
//         text: primaryText,
//         onPressed: submitEnabled ? _submit : null,
//       ),
//       SizedBox(height: 8.0),
//       FlatButton(
//         child: Text(secondaryText),
//         onPressed: !_isLoading ? _toggleFormType : null,
//       ),
//     ];
//   }
//
//   TextField _buildNameTextField() {
//     bool showErrorText = _submitted && !widget.nameValidator.isValid(_name);
//     return TextField(
//       key: Key('name'),
//       controller: _nameController,
//       focusNode: _nameFocusNode,
//       decoration: InputDecoration(
//         labelText: 'Name',
//         hintText: 'XXX',
//         errorText: showErrorText ? widget.invalidEmailErrorText : null,
//         enabled: _isLoading == false,
//       ),
//       autocorrect: false,
//       keyboardType: TextInputType.text,
//       textInputAction: TextInputAction.next,
//       onChanged: (name) => _updateState(),
//       onEditingComplete: _nameEditingComplete,
//     );
//   }
//
//   TextField _buildEmailTextField() {
//     bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
//     return TextField(
//       key: Key('email'),
//       controller: _emailController,
//       focusNode: _emailFocusNode,
//       decoration: InputDecoration(
//         labelText: 'Email',
//         hintText: 'test@test.com',
//         errorText: showErrorText ? widget.invalidEmailErrorText : null,
//         enabled: _isLoading == false,
//       ),
//       autocorrect: false,
//       keyboardType: TextInputType.emailAddress,
//       textInputAction: TextInputAction.next,
//       onChanged: (email) => _updateState(),
//       onEditingComplete: _emailEditingComplete,
//     );
//   }
//
//   TextField _buildPasswordTextField() {
//     bool showErrorText =
//         _submitted && !widget.passwordValidator.isValid(_password);
//     return TextField(
//       key: Key('password'),
//       controller: _passwordController,
//       focusNode: _passwordFocusNode,
//       decoration: InputDecoration(
//         labelText: 'Password',
//         errorText: showErrorText ? widget.invalidPasswordErrorText : null,
//         enabled: _isLoading == false,
//       ),
//       obscureText: true,
//       textInputAction: TextInputAction.done,
//       onChanged: (password) => _updateState(),
//       onEditingComplete: _submit,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisSize: MainAxisSize.min,
//         children: _buildChildren(),
//       ),
//     );
//   }
//
//   void _updateState() {
//     setState(() {});
//   }
// }
//
// //import 'package:flutter/material.dart';
// //import 'package:timetracker/common_widgets/form_submit_button.dart';
// //
// //enum EmailSignInType { signIn, register }
// //
// //class EmailSignInForm extends StatefulWidget {
// //  //if we set up two variable like email and password and later assign value
// //  // to it, then it must be a stateful widget, because stateless widget needs
// //  //all variable to be final and initialized and we can not assign a new value to it.
// //  // so it has to be a stateful widget
// //  @override
// //  _EmailSignInFormState createState() => _EmailSignInFormState();
// //}
// //
// //class _EmailSignInFormState extends State<EmailSignInForm> {
// //  final TextEditingController _emailController = TextEditingController();
// //  final TextEditingController _passwordController = TextEditingController();
// //
// //  EmailSignInType _formType = EmailSignInType.signIn;
// //
// //  void _submit() {}
// //
// //  void _toggleFormType() {
// //    setState(() {
// //      _formType = _formType == EmailSignInType.signIn
// //          ? EmailSignInType.register
// //          : EmailSignInType.signIn;
// //    });
// //    _emailController.clear();
// //    _passwordController.clear();
// //  }
// //
// //  List<Widget> _buildChildren() {
// //    final primaryText =
// //        _formType == EmailSignInType.signIn ? 'Sign In' : 'Create an account';
// //
// //    final secondaryText = _formType == EmailSignInType.signIn
// //        ? 'Need an account? Register'
// //        : 'Have an account? Sign in';
// //
// //    return [
// //      TextField(
// //        controller: _emailController,
// //        keyboardType: TextInputType.emailAddress,
// //        decoration:
// //            InputDecoration(labelText: 'Email', hintText: 'test@test.com'),
// //      ),
// //      SizedBox(height: 8),
// //      TextField(
// //        controller: _passwordController,
// //        obscureText: true,
// //        decoration: InputDecoration(labelText: 'password'),
// //      ),
// //      SizedBox(height: 8),
// //      FormSubmitButton(
// //        text: primaryText,
// //        onPressed: _submit,
// //      ),
// //      SizedBox(height: 8),
// //      FlatButton(
// //        child: Text(secondaryText),
// //        onPressed: _toggleFormType,
// //      )
// //    ];
// //  }
// //
// //  @override
// //  Widget build(BuildContext context) {
// //    return Padding(
// //      padding: const EdgeInsets.all(16.0),
// //      child: Column(
// //        crossAxisAlignment: CrossAxisAlignment.stretch,
// //        mainAxisSize: MainAxisSize.min,
// //        children: _buildChildren(),
// //      ),
// //    );
// //  }
// //}
