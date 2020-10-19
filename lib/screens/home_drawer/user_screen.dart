import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iMomentum/app/common_widgets/avatar.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_go_back_icon.dart';
import 'package:iMomentum/app/common_widgets/my_stack_screen.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/sign_in/firebase_auth_service_new.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../../app/common_widgets/avatar.dart';
import '../../app/common_widgets/platform_alert_dialog.dart';
import '../../app/constants/theme.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final User user = FirebaseAuth.instance.currentUser;

    return MyStackScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: buildAppBar(_darkTheme),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Spacer(),
            middleContent(user, _darkTheme),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  MyContainerWithDarkMode middleContent(User user, bool _darkTheme) {
    return MyContainerWithDarkMode(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            /// todo: let user add their photo
            Avatar(
              photoUrl: user.photoURL,
              radius: 30,
            ),
            SizedBox(height: 30),
            _buildNameRow(_darkTheme, user),
            SizedBox(height: 20.0),
            _buildEmailRow(_darkTheme, user),
            SizedBox(height: 20.0),
            _buildEmailVerifyRow(_darkTheme, user),
            confirmVerifiedFlatButton(_darkTheme),
          ],
        ),
      ),
    );
  }

  Visibility confirmVerifiedFlatButton(bool _darkTheme) {
    return Visibility(
      visible: _confirmVerifiedVisible,
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _confirmVerified,
                  child: Text('I have verified my email address.',
                      style: TextStyle(
                          color:
                              _darkTheme ? darkThemeButton : lightThemeButton,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline,
                          fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(bool _darkTheme) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
      leading: MyGoBackIcon(darkTheme: _darkTheme),
      actions: [
        _popup(_darkTheme),
      ],
    );
  }

  Row _buildNameRow(bool _darkTheme, User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Row(
            children: [
              Text('Name:',
                  style: TextStyle(
                      color: _darkTheme ? darkThemeWords : lightThemeWords,
                      fontSize: 18.0)),
              SizedBox(width: 20),
              Expanded(
                child: Visibility(
                  visible: _nameVisible,
                  child: Text(
                      user.displayName == null || user.displayName.isEmpty
                          ? 'No added name yet.'
                          : user.displayName,
                      style: textStyleName(_darkTheme)),
                ),
              ),
              Expanded(
                child: Visibility(
                  visible: !_nameVisible,
                  child: SizedBox(
                    width: 150,
                    child: textFormField(_darkTheme),
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            _nameVisible ? EvaIcons.edit2Outline : Icons.clear,
            size: 26,
            color: _darkTheme ? darkThemeButton : lightThemeButton,
          ),
          onPressed: _toggleVisibility,
        )
      ],
    );
  }

  TextFormField textFormField(bool _darkTheme) {
    return TextFormField(
      autofocus: true,
      validator: (value) => value.isNotEmpty ? null : 'Content can\'t be empty',
      onFieldSubmitted: _onSubmittedName,
      keyboardAppearance: _darkTheme ? Brightness.dark : Brightness.light,
      cursorColor: _darkTheme ? darkThemeWords : lightThemeWords,
      maxLength: 15,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: _darkTheme ? darkThemeDivider : lightThemeDivider,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: _darkTheme ? darkThemeDivider : lightThemeDivider,
        )),
      ),
      style: textStyleName(_darkTheme),
    );
  }

  TextStyle textStyleName(bool _darkTheme) {
    return TextStyle(
        color: _darkTheme ? darkThemeWords : lightThemeWords,
        fontSize: 20.0,
        fontWeight: FontWeight.bold);
  }

  Row _buildEmailRow(bool _darkTheme, User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text('Email:',
            style: TextStyle(
                color: _darkTheme ? darkThemeWords : lightThemeWords,
                fontSize: 18.0)),
        SizedBox(width: 20.0),
        Text(
            user.email == null || user.email.isEmpty
                ? 'No registered email.'
                : user.email,
            style: textStyleName(_darkTheme)),
      ],
    );
  }

  Widget _buildEmailVerifyRow(bool _darkTheme, User user) {
    return user.isAnonymous
        ? Container()
        : user.emailVerified
            ? Row(
                children: [
                  Text('✔︎  Email verified',
                      style: TextStyle(
                          color: _darkTheme ? darkThemeWords : lightThemeWords,
                          fontSize: 16,
                          fontStyle: FontStyle.italic)),
                ],
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Text('Email not verified',
                          style: TextStyle(color: Colors.red, fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      InkWell(
                        onTap: _verifyEmail,
                        child: Text('Verify email address',
                            style: TextStyle(
                              color: _darkTheme
                                  ? darkThemeButton
                                  : lightThemeButton,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                            )),
                      )
                    ],
                  )
                ],
              );
  }

  ///notes for pop up to choose from gallery or camera
  PopupMenuButton<int> _popup(bool _darkTheme) {
    return PopupMenuButton<int>(
        color: _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
        icon: Icon(
          EvaIcons.moreHorizotnalOutline,
          color: _darkTheme ? darkThemeButton : lightThemeButton,
        ),
        offset: Offset(0, 50),
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Logout"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Delete account"),
              ),
            ],
        onSelected: (int) {
          if (int == 1) {
            _confirmSignOut(context);
          }
          if (int == 2) {
            _confirmDelete(context);
          }
        });
  }

  bool _nameVisible = true;
  void _toggleVisibility() {
    setState(() {
      _nameVisible = !_nameVisible;
    });
  }

  void _onSubmittedName(String value) async {
    try {
      if (value.isNotEmpty) {
        /// from ProgressDialog plugin
        final ProgressDialog pr = ProgressDialog(
          context,
          type: ProgressDialogType.Normal,
          // textDirection: TextDirection.rtl,
          isDismissible: true,
        );
        prStyle(pr);

        await pr.show();

        final FirebaseAuthService auth =
            Provider.of<FirebaseAuthService>(context, listen: false);
        await auth.updateUserName(value);

        ///because it takes a while to update name
        await pr.hide();

        setState(() {
          _nameVisible = !_nameVisible;
        });
      }
    } catch (e) {
      print(e.toString());
      _showSignInError(context, e);
    }
  }

  void prStyle(ProgressDialog pr) {
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

  bool _confirmVerifiedVisible = false;
  Future<void> _verifyEmail() async {
    final User user = FirebaseAuth.instance.currentUser;

    try {
      await user.sendEmailVerification();
      await PlatformAlertDialog(
        title: 'Verification link sent',
        content: 'Please check your email to verify your account.',
        defaultActionText: 'OK',
      ).show(context);
      setState(() {
        _confirmVerifiedVisible = !_confirmVerifiedVisible;
      });
    } catch (e) {
      print(e.toString());
      _showSignInError(context, e);
    }
  }

  void _confirmVerified() {
    final User user = FirebaseAuth.instance.currentUser;
    user.reload();
    setState(() {
      _confirmVerifiedVisible = !_confirmVerifiedVisible;
    });
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final FirebaseAuthService auth =
          Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
      _showSignInError(context, e);
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      final FirebaseAuthService auth =
          Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.delete();
    } catch (e) {
      print(e.toString());
      _showSignInError(context, e);
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Delete you iMomentum account',
      content:
          'Warning: Your account and all of its data will be permanently deleted.',
      cancelActionText: 'Cancel',
      defaultActionText: 'Delete',
    ).show(context);
    if (didRequestSignOut == true) {
      _deleteAccount(context);
    }
  }

  Future<void> _showSignInError(BuildContext context, dynamic exception) async {
    await showExceptionAlertDialog(
      context: context,
      title: 'Operation failed',
      exception: exception,
    );
  }
}
