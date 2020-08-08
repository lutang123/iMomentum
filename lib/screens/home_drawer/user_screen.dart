import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/avatar.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../../app/common_widgets/avatar.dart';
import '../../app/common_widgets/platform_alert_dialog.dart';
import '../../app/constants/constants.dart';
import '../../app/services/auth.dart';
import '../../app/constants/theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;

class UserScreen extends StatefulWidget {
  final User user;
  const UserScreen({Key key, this.user}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  File _image;
  String _uploadedFileURL;
  final picker = ImagePicker();
  bool isLoading = false;

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final PickedFile selectedImage = await picker.getImage(source: source);

    setState(() {
      _image = File(selectedImage.path);
    });
  }

//  Future _uploadFile() async {
//    setState(() {
//      isLoading = true;
//    });
//    StorageReference storageReference = FirebaseStorage.instance
//        .ref()
//        .child('images/${Path.basename(_image.path)}}');
//    StorageUploadTask uploadTask = storageReference.putFile(_image);
//    await uploadTask.onComplete;
//    print('File Uploaded');
//    storageReference.getDownloadURL().then((fileURL) {
//      setState(() {
//        _uploadedFileURL = fileURL;
//        isLoading = false;
//      });
//    });
//  }

  @override
  Widget build(BuildContext context) {
    final randomNotifier = Provider.of<RandomNotifier>(context);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context);
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
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                size: 30,
              ),
              color: Colors.white,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Logout',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () => _confirmSignOut(context),
              ),
            ],
          ),
          body: Center(
              child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildUserInfo(context, widget.user),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  Align(
//                    alignment: Alignment.centerLeft,
//                    child: Container(
//                      child: Column(
//                        children: <Widget>[
//                          Align(
//                            alignment: Alignment.centerLeft,
//                            child: Text('Username',
//                                style: TextStyle(
//                                    color: Colors.blueGrey, fontSize: 18.0)),
//                          ),
//                          Align(
//                            alignment: Alignment.centerLeft,
//                            child: Text('Michelle James',
//                                style: TextStyle(
//                                    color: Colors.black,
//                                    fontSize: 20.0,
//                                    fontWeight: FontWeight.bold)),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                  Align(
//                    alignment: Alignment.centerRight,
//                    child: Container(
//                      child: Icon(
//                        FontAwesomeIcons.pen,
//                        color: Color(0xff476cfb),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//              SizedBox(height: 20.0),
//              Container(
//                margin: EdgeInsets.all(20.0),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                    Text('Email',
//                        style:
//                            TextStyle(color: Colors.blueGrey, fontSize: 18.0)),
//                    SizedBox(width: 20.0),
//                    Text('michelle123@gmail.com',
//                        style: TextStyle(
//                            color: Colors.black,
//                            fontSize: 20.0,
//                            fontWeight: FontWeight.bold)),
//                  ],
//                ),
//              ),
//              SizedBox(
//                height: 20.0,
//              ),
//              Padding(
//                padding: const EdgeInsets.all(15.0),
//                child: Text(
//                  "xxxxxx",
//                  style: KStartSubtitle,
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(15.0),
//                child: Text(
//                  "xxxxxx",
//                  style: KStartSubtitle,
//                ),
//              ),
              SizedBox(height: 10),
            ],
          )),
        ),
      ],
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
//      print(e.toString());
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

  Widget _buildUserInfo(BuildContext context, User user) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Avatar(
//              photoUrl: _uploadedFileURL != null
//                  ? user.photoUrl == null ? _uploadedFileURL : 'No Image'
//              : user.photoUrl,
                  photoUrl:
                      _uploadedFileURL != null ? _uploadedFileURL : 'No Image',
                  radius: 50,
                ),
                SizedBox(height: 8),
                if (user.displayName != null)
                  Text(
                    user.displayName,
                    style: TextStyle(
                      color: _darkTheme ? darkButton : lightButton,
                      fontSize: 18.0,
                    ),
                  ),
                SizedBox(height: 8),
              ],
            ),
            SizedBox(width: 20),
            _popup(),
//            IconButton(
//              icon: Icon(
//                FontAwesomeIcons.edit,
//                size: 30.0,
//              ),
//              onPressed: () {
//                _pickImage(ImageSource.gallery);
//              },
//            ),
          ],
        ),
      ],
    );
  }

  Widget _popup() => PopupMenuButton<int>(
      icon: FaIcon(FontAwesomeIcons.pencilAlt),
      offset: Offset(0, 50),
      itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Text("Choose from gallery"),
            ),
            PopupMenuItem(
              value: 2,
              child: Text("Take a new photo"),
            ),
          ],
      onSelected: (int) {
        if (int == 1) {
          _pickImage(ImageSource.gallery);
        }
        if (int == 2) {
          _pickImage(ImageSource.camera);
        }
      });
}
