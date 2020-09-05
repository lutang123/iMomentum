import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/screens/home_drawer/unsplash/widget/info_sheet.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/services/network_service/unsplash_image_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/models/unsplash_image.dart';

/// Screen for showing an individual [UnsplashImage].
class ImagePage extends StatefulWidget {
  final String imageId, imageUrl;
  final Database database;

  ImagePage(this.imageId, this.imageUrl, this.database, {Key key})
      : super(key: key);

  @override
  _ImagePageState createState() => _ImagePageState();
}

/// Provide a state for [ImagePage].
class _ImagePageState extends State<ImagePage> {
  /// create global key to show info bottom sheet
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  /// Displayed image.
  UnsplashImage image;

  @override
  void initState() {
    super.initState();
    // load image
    _loadImage();
  }

  /// Reloads the image from unsplash to get extra data, like: exif, location, ...
  _loadImage() async {
    UnsplashImage image = await UnsplashImageProvider.loadImage(widget.imageId);
    setState(() {
      this.image = image;
    });
  }

//  bool isLiked = false;

//  Future<void> _save(Database database, UnsplashImage image) async {
//    setState(() {
//      isLiked = !isLiked;
//    });
//
//    try {
//      final id = image.getId() ?? documentIdFromCurrentDate();
//
//      final newImage = ImageModel(id: id, url: widget.imageUrl);
//      //add newTodo to database
//      await database.setImage(newImage);
//    } on PlatformException catch (e) {
//      PlatformExceptionAlertDialog(
//        title: 'Operation failed',
//        exception: e,
//      ).show(context);
//    }
//  }

  /// Returns AppBar.
  Widget _buildAppBar(Database database) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return AppBar(
      elevation: 0.0,
      backgroundColor: _darkTheme ? darkThemeDrawer : lightThemeAppBar,
      leading:
          // back button
          IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: _darkTheme ? Colors.white : lightThemeButton,
                size: 30,
              ),
              onPressed: () => Navigator.of(context).pop()),
      title: Text(
        'Preview',
        style: TextStyle(color: _darkTheme ? darkThemeWords : lightThemeWords),
      ),
      centerTitle: true,
      actions: <Widget>[
//          IconButton(
//            icon: Icon(
//              isLiked ? Icons.favorite : Icons.favorite_border,
//              color: Colors.white,
//              size: 30,
//            ),
//            tooltip: 'Add to favourite',
//            onPressed: () => _save(database, image),
//          ),
        // show image info
        IconButton(
            icon: Icon(
              Icons.info_outline,
              color: _darkTheme ? Colors.white : lightThemeButton,
              size: 30,
            ),
            tooltip: 'Image Info',
            onPressed: () => _showInfoBottomSheet()),
        // open in browser icon button
        IconButton(
            icon: Icon(
              Icons.open_in_browser,
              color: _darkTheme ? Colors.white : lightThemeButton,
              size: 30,
            ),
            tooltip: 'Open in Browser',
            onPressed: () => launch(image?.getHtmlLink())),
      ],
    );
  }

  /// Returns PhotoView around given [imageId] & [imageUrl].
  Widget _buildPhotoView(String imageUrl) => PhotoView(
      imageProvider: NetworkImage(imageUrl),
      initialScale: PhotoViewComputedScale.covered,
      minScale: PhotoViewComputedScale.covered,
      maxScale: PhotoViewComputedScale.covered,
//      heroAttributes: PhotoViewHeroAttributes(tag: '$imageUrl'),
      loadingBuilder: (BuildContext context, ImageChunkEvent event) {
        return Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
        ));
      });

  @override
  Widget build(BuildContext context) {
    ///set image
    final imageNotifier = Provider.of<ImageNotifier>(context);

    return Scaffold(
      // set the global key
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          _buildPhotoView(widget.imageUrl),
          // wrap in Positioned to not use entire screen
          Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: _buildAppBar(widget.database)),
          Positioned(
            bottom: 60,
            left: 60,
            right: 60,
            child: MyFlatButton(
              text: 'Set as background photo',
              onPressed: () => _onImageChanged(widget.imageUrl, imageNotifier),
            ),
          )
        ],
      ),
    );
  }

  void _onImageChanged(String url, ImageNotifier imageNotifier) async {
    final randomNotifier = Provider.of<RandomNotifier>(context, listen: false);
    //save changes
    imageNotifier.setImage(url);
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('imageUrl', url);
    //change the randomOn value to false at the same time
    randomNotifier.setRandom(false);
    //save settings
    prefs.setBool('randomOn', false);

    //pop back
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == 2;
    });
  }

  /// Shows a BottomSheet containing image info.
  _showInfoBottomSheet() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) => InfoSheet(image));
  }
}
