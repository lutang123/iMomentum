import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iMomentum/app/common_widgets/avatar.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/sign_in/new_firebase_auth_service.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../../app/common_widgets/avatar.dart';
import '../../app/common_widgets/platform_alert_dialog.dart';
import '../../app/constants/constants_style.dart';
import '../../app/constants/theme.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    final randomNotifier = Provider.of<RandomNotifier>(context, listen: false);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context, listen: false);

    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    final User user = FirebaseAuth.instance.currentUser;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        BuildPhotoView(
          imageUrl:
              _randomOn ? ImageUrl.randomImageUrl : imageNotifier.getImage(),
        ),
        ContainerLinearGradient(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                size: 30,
                color: _darkTheme ? darkThemeButton : lightThemeButton,
              ),
            ),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Spacer(),
              MySignInContainer(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Avatar(
                        photoUrl: user.photoURL,
                        radius: 30,
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: [
                                Text('Name:',
                                    style: TextStyle(
                                        color: _darkTheme
                                            ? darkThemeWords
                                            : lightThemeWords,
                                        fontSize: 18.0)),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Visibility(
                                    visible: _nameVisible,
                                    child: Text(
                                        user.displayName == null ||
                                                user.displayName.isEmpty
                                            ? 'No added name yet.'
                                            : user.displayName,
                                        style: TextStyle(
                                            color: _darkTheme
                                                ? darkThemeWords
                                                : lightThemeWords,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                Expanded(
                                  child: Visibility(
                                    visible: !_nameVisible,
                                    child: SizedBox(
                                      width: 150,
                                      child: TextField(
                                        autofocus: true,
                                        onSubmitted: _onSubmitted,
                                        keyboardAppearance: _darkTheme
                                            ? Brightness.dark
                                            : Brightness.light,
                                        cursorColor: _darkTheme
                                            ? darkThemeWords
                                            : lightThemeWords,
                                        maxLines: 1,
                                        maxLength: 15,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(20)
                                        ],
                                        decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _darkTheme
                                                  ? darkThemeDivider
                                                  : lightThemeDivider,
                                            ),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: _darkTheme
                                                ? darkThemeDivider
                                                : lightThemeDivider,
                                          )),
                                        ),
                                        style: TextStyle(
                                            color: _darkTheme
                                                ? darkThemeWords
                                                : lightThemeWords,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              EvaIcons.edit2Outline,
                              size: 26,
                              color: _darkTheme
                                  ? darkThemeButton
                                  : lightThemeButton,
                            ),
                            onPressed: _editName,
                          )
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Email:',
                              style: TextStyle(
                                  color: _darkTheme
                                      ? darkThemeWords
                                      : lightThemeWords,
                                  fontSize: 18.0)),
                          SizedBox(width: 20.0),
                          Text(
                              user.email == null || user.email.isEmpty
                                  ? 'No registered email.'
                                  : user.email,
                              style: TextStyle(
                                  color: _darkTheme
                                      ? darkThemeWords
                                      : lightThemeWords,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => _confirmDelete(context),
                            child: Text('Delete account',
                                style: TextStyle(
                                    color: _darkTheme
                                        ? darkThemeHint
                                        : lightThemeHint,
                                    fontSize: 18.0)),
                          ),
                          SizedBox(width: 20.0),
                          FlatButton(
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                  color: _darkTheme
                                      ? darkThemeButton
                                      : lightThemeButton,
                                  fontSize: 18),
                            ),
                            onPressed: () => _confirmSignOut(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
      ],
    );
  }

  bool _nameVisible = true;

  void _editName() {
    setState(() {
      _nameVisible = !_nameVisible;
    });
  }

  void _onSubmitted(String value) async {
    if (value.isNotEmpty) {
      //from ProgressDialog plugin
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

      final FirebaseAuthService auth =
          Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.updateUserName(value);

      ///because it takes a while to update name
      await pr.hide();

      setState(() {
        _nameVisible = !_nameVisible;
      });
    }
    // Navigator.pop(context);
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final FirebaseAuthService auth =
          Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
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

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      final FirebaseAuthService auth =
          Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.delete();
    } catch (e) {
      print(e.toString());
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

  ///notes for pop up to choose from gallery or camera
  // Widget _popup() => PopupMenuButton<int>(
  //     icon: FaIcon(FontAwesomeIcons.pencilAlt),
  //     offset: Offset(0, 50),
  //     itemBuilder: (context) => [
  //           PopupMenuItem(
  //             value: 1,
  //             child: Text("Choose from gallery"),
  //           ),
  //           PopupMenuItem(
  //             value: 2,
  //             child: Text("Take a new photo"),
  //           ),
  //         ],
  //     onSelected: (int) {
  //       if (int == 1) {
  //         _pickImage(ImageSource.gallery);
  //       }
  //       if (int == 2) {
  //         _pickImage(ImageSource.camera);
  //       }
  //     });
}
