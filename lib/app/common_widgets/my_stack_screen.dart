import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/image_path.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';
import 'build_photo_view.dart';

class MyStackScreen extends StatefulWidget {
  final Widget child;
  final Function onTap;

  const MyStackScreen({Key key, @required this.child, this.onTap})
      : super(key: key);

  @override
  _MyStackScreenState createState() => _MyStackScreenState();
}

class _MyStackScreenState extends State<MyStackScreen> {
  int counter = 0;

  void _onDoubleTap() {
    setState(() {
      ImagePath.randomImageUrl = '${ImagePath.randomImageUrlFirstPart}$counter';
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final randomNotifier = Provider.of<RandomNotifier>(context);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // value:
      //     _darkTheme ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      value: SystemUiOverlayStyle(
        // For Android.
        // Use [light] for white status bar and [dark] for black status bar.
        statusBarIconBrightness:
            _darkTheme ? Brightness.light : Brightness.dark,
        systemNavigationBarColor:
            _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
        systemNavigationBarIconBrightness:
            _darkTheme ? Brightness.light : Brightness.dark,
        // For iOS.
        // Use [dark] for white status bar and [light] for black status bar.
        statusBarBrightness: _darkTheme ? Brightness.dark : Brightness.light,
        statusBarColor: Colors.transparent,
      ),

      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          BuildPhotoView(
            imageUrl:
                _randomOn ? ImagePath.randomImageUrl : imageNotifier.getImage(),
          ),
          Container(
              decoration: BoxDecoration(
                  gradient: _darkTheme
                      ? KBackgroundGradientDark
                      : KBackgroundGradient)),
          GestureDetector(
            onDoubleTap: _onDoubleTap,
            onTap: widget.onTap,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

/// https://stackoverflow.com/questions/52489458/how-to-change-status-bar-color-in-flutter/59672398#:~:text=The%20text%20color%20of%20the,SystemChrome.
///https://stackoverflow.com/questions/51709247/how-to-change-the-status-bar-text-color-on-ios

///For those who uses AppBar. To apply for all app bars:
// return MaterialApp(
//   theme: Theme.of(context).copyWith(
//     appBarTheme: Theme.of(context)
//         .appBarTheme
//         .copyWith(brightness: Brightness.light),
//   ...
//   ),
///For those who don't use AppBar
//value: const SystemUiOverlayStyle(
//     // For Android.
//     // Use [light] for white status bar and [dark] for black status bar.
//     statusBarIconBrightness: Brightness.light,
//     // For iOS.
//     // Use [dark] for white status bar and [light] for black status bar.
//     statusBarBrightness: Brightness.dark,
//   ),
