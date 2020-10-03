import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/image_path.dart';
import 'package:iMomentum/app/constants/my_strings.dart';
import 'package:iMomentum/app/utils/shared_axis.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/home_drawer/unsplash/preview_file.dart';
import 'package:iMomentum/screens/home_drawer/unsplash/search_delegate_photo.dart';
import 'package:iMomentum/screens/home_drawer/unsplash/staggered_view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import '../../../app/models/unsplash_image.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_cropper/image_cropper.dart';

/// Screen for showing a collection of trending [UnsplashImage].
class ImageGallery extends StatefulWidget {
  final Database database;

  const ImageGallery({Key key, this.database}) : super(key: key);

  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

/// Provide a state for [ImageGallery].
class _ImageGalleryState extends State<ImageGallery> {
  @override
  initState() {
    super.initState();
    //for second tab
    _getAppliedImage();
//    print(_appliedFilePath);
  }

  //find previously uploaded URL and path:
  String _appliedImageUrl;
  String _appliedFilePath;

  Future<void> _getAppliedImage() async {
    SharedPreferences.getInstance().then((prefs) {
      ///saved when we upload image
      ///when we cancel, we delete and then select an image to upload again

      //OMG, I should use setState, otherwise even though we assigned value to
      //_appliedImageUrl, the screen still apply the null one and cause error
      setState(() {
        _appliedImageUrl = prefs.getString('appliedImageUrl');
        _appliedFilePath = prefs.getString('appliedFilePath');
      });

//      print('_appliedImageUrl: $_appliedImageUrl'); //null
//      print('_appliedFilePath: $_appliedFilePath'); //null
    });
  }

  void _preview() {
    final route = SharedAxisPageRoute(
        page: PreviewFile(imageFile: _imageFile),
        transitionType: SharedAxisTransitionType.scaled);
    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor:
              _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor:
                _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: _darkTheme ? darkThemeButton : lightThemeButton,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text('Photos', style: Theme.of(context).textTheme.headline5
                // TextStyle(
                //     color: _darkTheme ? Colors.white : lightThemeWords),
                ),
            actions: <Widget>[
              IconButton(
                onPressed: () => showSearch(
                  context: context,
                  delegate: SearchPhotos(),
                ),
                icon: Icon(
                  Icons.search,
                  size: 30,
                  color: _darkTheme ? darkThemeButton : lightThemeButton,
                ),
              )
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: TabBar(
                labelStyle: TextStyle(
                    color: _darkTheme ? Colors.white : lightThemeWords),
                indicatorColor: _darkTheme ? darkThemeButton : lightThemeButton,
                tabs: [
                  ///when use text, instead of child, the text color is white when in light theme
                  Tab(
                    child: Text('Choose from our gallery',
                        style: TextStyle(
                            color:
                                _darkTheme ? Colors.white : lightThemeWords)),
                  ),
                  Tab(
                    child: Text('Upload your own photo',
                        style: TextStyle(
                            color:
                                _darkTheme ? Colors.white : lightThemeWords)),
                  )
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: <Widget>[
                StaggeredView('nature,wallpaper,travel,landscape'),
                secondTab(),
              ],
            ),
          )),
    );
  }

  Widget secondTab() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _appliedFilePath != null
            ? Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 15),
                    Text(
                      'Uploaded photo',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(15.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(_appliedImageUrl,
                                  fit: BoxFit.cover))),
                    ),
                    MyBottomContainer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          myFlatIconButton(
                            Icons.clear,
                            'Change',
                            onPressed: _deleteApplied,
                          ),
                          myFlatIconButton(
                            Icons.check,
                            'Apply Again',
                            onPressed: () => _applyAgain(_appliedImageUrl),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Visibility(
                visible:
                    _addButtonVisible, //that means no uploaded //if user already uploaded, then we hide the add button
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Personalize your inspiration by adding your own photo',
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      MyFlatButton(
                        text: '+ Add Photo',
                        bkgdColor: _darkTheme
                            ? Colors.transparent
                            : Colors.transparent,
                        color: _darkTheme ? darkThemeButton : lightThemeButton,
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                    ],
                  ),
                ),
              ),

        ///after selecting one, we have imageFile, and when we
        ///upload, we make visible as false and then we only see the uploaded one with url

        if (_imageFile != null) ...[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 15),
                Text(
                  'Selected photo',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Hero(
                          tag: _imageFile.path,
                          child: Image.file(_imageFile, fit: BoxFit.cover)),
                    ),
                  ),
                ),
                MyBottomContainer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          myFlatIconButton(Icons.crop, 'Crop',
                              onPressed: _cropImage),
                          myFlatIconButton(Icons.remove_red_eye, 'Preview',
                              onPressed: _preview),
                          myFlatIconButton(Icons.clear, 'Cancel',
                              onPressed: _cancel),
                        ],
                      ),
                      Row(
                        children: [
                          FlatButton(
                            child: Text(
                              'Show Tips',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: _darkTheme
                                      ? darkThemeButton.withOpacity(0.9)
                                      : lightThemeButton.withOpacity(0.9)),
                            ),
                            onPressed: _showTipDialog,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // SizedBox(height: 10),
              ],
            ),
          )
        ]
      ],
    );
  }

  Padding myFlatIconButton(IconData icon, String text,
      {@required VoidCallback onPressed}) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
                color: _darkTheme ? darkThemeHint : lightThemeHint,
                width: 1.0)),
        icon:
            Icon(icon, color: _darkTheme ? darkThemeButton : lightThemeButton),
        onPressed: onPressed,
        label: Text(
          text,
          style:
              TextStyle(color: _darkTheme ? darkThemeWords : lightThemeWords),
        ),
      ),
    );
  }

  Future<void> _showTipDialog() async {
    await PlatformAlertDialog(
      title: 'Tips',
      content: Strings.tipsOnUploadYourPhoto,
      defaultActionText: 'OK.',
    ).show(context);
  }

  /// Active image file
  File _imageFile;

  final picker = ImagePicker();

  bool _addButtonVisible = true;

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://imomentum-5969c.appspot.com');

  /// Cropper plugin
  /// TODO: NOT WORKING
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
        title: 'Cropper',
      ),
    );
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    //from ProgressDialog plugin
    final ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      textDirection: TextDirection.rtl,
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

    final PickedFile selectedImage = await picker.getImage(source: source);

    await pr.hide();

    if (selectedImage != null) {
      setState(() {
        _addButtonVisible = false; //hide add button
        _imageFile = File(selectedImage.path);
      });
    }
  }

  /// Remove image
  void _cancel() {
    setState(() {
      _imageFile = null;
      _addButtonVisible = true;
    });
  }

  void _applyAgain(String _appliedImageUrl) async {
    final imageNotifier = Provider.of<ImageNotifier>(context, listen: false);
    final randomNotifier = Provider.of<RandomNotifier>(context, listen: false);
//      final appliedOwnPhotoNotifier =
//          Provider.of<AppliedOwnPhotoNotifier>(context, listen: false);
    //save image changes
    imageNotifier.setImage(_appliedImageUrl);
    //change the randomOn value to false at the same time
    randomNotifier.setRandom(false);
//      appliedOwnPhotoNotifier.setBoolOwnPhoto(true);
    //then save in shared preference
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('imageUrl', _appliedImageUrl);
    //save settings
    prefs.setBool('randomOn', false);

    ///navigate back two level
    Navigator.of(context).pop();
  }

  /// change
  Future<void> _deleteApplied() async {
    // first: find the path we saved:
    var prefs = await SharedPreferences.getInstance();

    // get StorageReference
    final StorageReference storageReference =
        _storage.ref().child(_appliedFilePath);
    // then delete:
    if (_appliedFilePath != null) {
      try {
        await storageReference.delete(); //fist delete from storage
        print('confirm delete from firebase storage');
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }

    ///after delete applied image, the url will not exist, to prevent error, we need to change setting too
    final imageNotifier = Provider.of<ImageNotifier>(context, listen: false);
    final randomNotifier = Provider.of<RandomNotifier>(context, listen: false);
//    final appliedOwnPhotoNotifier =
//        Provider.of<AppliedOwnPhotoNotifier>(context, listen: false);
    //save image changes
    imageNotifier.setImage(ImagePath.fixedImageUrl);
    //change the randomOn value to false at the same time
    randomNotifier.setRandom(true);
//    appliedOwnPhotoNotifier.setBoolOwnPhoto(true);
    //then save in shared preference
    prefs.setString('imageUrl', ImagePath.fixedImageUrl);
    //save settings
    prefs.setBool('randomOn', true);

    ///at the same time, reset prefs uploadedImageURL and filePath
    prefs.setString('appliedImageUrl', null);
    prefs.setString('appliedFilePath', null);
//    prefs.setBool('appliedOwnPhoto', false);
//     print(
//         'confirm delete from share preference, deleted appliedImageURL: ${prefs.getString('appliedImageURL')}, '
//         'deleted appliedFilePath: ${prefs.getString('appliedFilePath')}');

    setState(() {
      _appliedImageUrl = null; //this is for UI
      _appliedFilePath = null;
      _addButtonVisible = true;
    });
  }
}
