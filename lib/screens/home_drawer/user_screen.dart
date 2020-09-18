import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iMomentum/app/common_widgets/avatar.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_text_field.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/sign_in/AppUser.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/sign_in/firebase_auth_service.dart';
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

    final AppUser user = Provider.of<AppUser>(context, listen: false);

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
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Logout',
                  style: TextStyle(
                      color: _darkTheme ? darkThemeButton : lightThemeButton,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () => _confirmSignOut(context),
              ),
            ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Spacer(),
              MyUserInfoContainer(
                child: Column(
                  children: [
                    Avatar(
                      photoUrl: user.photoURL,
                      radius: 30,
                    ),
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
                                          ? 'Not add name yet.'
                                          : user.displayName,
                                      style: TextStyle(
                                          color: _darkTheme
                                              ? darkThemeWords
                                              : lightThemeWords,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Visibility(
                                visible: !_nameVisible,
                                child: SizedBox(
                                  width: 150,
                                  child: TextField(
                                    onSubmitted: _onSubmitted,
                                    cursorColor: _darkTheme
                                        ? darkThemeWords
                                        : lightThemeWords,
                                    maxLength: 20,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(20)
                                    ],
                                    decoration: InputDecoration(
                                      // hintText:
                                      //     'Edit your display name. (Your name will show on Home screen greetings)',
                                      // hintStyle: TextStyle(
                                      //     fontSize: 16.0,
                                      //     color: _darkTheme
                                      //         ? darkThemeHint
                                      //         : lightThemeHint),
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
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            EvaIcons.edit2Outline,
                            size: 26,
                            color:
                                _darkTheme ? darkThemeButton : lightThemeButton,
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
                        Text(user.email,
                            style: TextStyle(
                                color: _darkTheme
                                    ? darkThemeWords
                                    : lightThemeWords,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
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

  void _onSubmitted(String value) {
    if (value.isNotEmpty) {
      final AppUser user = Provider.of<AppUser>(context, listen: false);
      user.displayName = value;
      final FirebaseAuthService auth =
          Provider.of<FirebaseAuthService>(context, listen: false);
      auth.updateUserName(value);
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
