import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

class MySignInContainer extends StatelessWidget {
  const MySignInContainer({Key key, this.child, this.height, this.padding = 15})
      : super(key: key);
  final Widget child;
  final double height;
  final double padding;

  @override
  Widget build(BuildContext context) {
    // final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    // bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
          color: lightThemeSurface, borderRadius: BorderRadius.circular(20.0)),
      height: height,
      child: child,
    );
  }
}

class FlushBarButtonChild extends StatelessWidget {
  final String title;

  const FlushBarButtonChild({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.white54),
          borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

// in home screen
class MyDotContainer extends StatelessWidget {
  final Color color;
  final double size;

  const MyDotContainer({Key key, this.color, this.size = 8.0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

// in home screen error, user screen, folder screen
class MyContainerWithDarkMode extends StatelessWidget {
  const MyContainerWithDarkMode({
    Key key,
    this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: _darkTheme ? darkThemeSurface : lightThemeSurface,
          borderRadius: BorderRadius.circular(20.0)),
      child: Center(child: child),
    );
  }
}

class HomeErrorMessage extends StatelessWidget {
  final String text;
  final String textTap;
  final Function onTap;
  const HomeErrorMessage({Key key, this.text, this.textTap, this.onTap})
      : super(key: key);
  @override
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return MyContainerWithDarkMode(
        child: RichText(
      text: TextSpan(
        style: TextStyle(
            color: _darkTheme
                ? darkThemeWords.withOpacity(0.85)
                : lightThemeWords.withOpacity(0.85),
            fontStyle: FontStyle.italic,
            fontSize: 16),
        children: [
          TextSpan(
            text: text,
          ),
          TextSpan(
            text: textTap,
            recognizer: TapGestureRecognizer()..onTap = onTap,
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: _darkTheme
                    ? darkThemeWords.withOpacity(0.85)
                    : lightThemeWords.withOpacity(0.85),
                fontStyle: FontStyle.italic,
                fontSize: 16),
          ),
        ],
      ),
    ));
  }
}

class NoteSearchBar extends StatelessWidget {
  final VoidCallback onPressed;

  const NoteSearchBar({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
        decoration: BoxDecoration(
            color: _darkTheme ? darkThemeDrawer : lightThemeDrawer,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton.icon(

                ///Todo: implement search
                onPressed: onPressed,
                icon: Icon(Icons.search,
                    color: _darkTheme
                        ? darkThemeButton.withOpacity(0.9)
                        : lightThemeButton.withOpacity(0.9)),
                label: Text(
                  'Search your notes',
                  style: TextStyle(
                      color: _darkTheme
                          ? Colors.white70
                          : lightThemeWords.withOpacity(0.7)),
                )),
          ],
        ));
  }
}

///used in todoscreen and mantra and quote
class CustomizedContainerNew extends StatelessWidget {
  CustomizedContainerNew({this.child, this.color});
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 8.0, right: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: child,
    );
  }
}

//used in NoteContainer for folder name
class SmallContainerFolderName extends StatelessWidget {
  SmallContainerFolderName({this.text});
  final String text;

  ////                              Container(
  ////                                decoration: BoxDecoration(
  ////                                  shape: BoxShape.circle,
  ////                                  border: Border.all(
  ////                                      color: Colors.white70, width: 1),
  ////                                ),
  ////                                child: IconButton(
  ////                                    icon: Icon(EvaIcons.moreHorizotnalOutline),
  ////                                    onPressed: null),
  ////                              ),

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: _darkTheme ? darkThemeDrawer : lightThemeDrawer,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        border: Border.all(
            color: _darkTheme ? darkThemeDivider : lightThemeDivider, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(text,
            style: TextStyle(
                color: _darkTheme ? darkThemeHint : lightThemeHint,
                fontSize: 13)),
      ),
    );
  }
}

class ContainerOnlyTextPhotoSearch extends StatelessWidget {
  final String text;

  const ContainerOnlyTextPhotoSearch({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
        child: Row(
      children: [
        Container(
            decoration: BoxDecoration(
                color: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text,
                  style: TextStyle(
                    color: _darkTheme ? darkThemeWords : lightThemeWords,
                    fontWeight: FontWeight.bold,
                  )),
            ))
      ],
    ));
  }
}

class MyBottomContainerInImage extends StatelessWidget {
  final Widget child;

  const MyBottomContainerInImage({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
        margin: const EdgeInsets.only(top: 5.0),
        decoration: BoxDecoration(
          color: _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Center(child: child));
  }
}

///all add screen
class CustomizedBottomSheet extends StatelessWidget {
  CustomizedBottomSheet({this.child, this.color});
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: EdgeInsets.only(left: 8.0, right: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: child,
      ),
    );
  }
}
