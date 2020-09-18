import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

class MyDotContainer extends StatelessWidget {
  final Color color;

  const MyDotContainer({Key key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
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

// for PINNED/OTHERS
class ContainerOnlyText extends StatelessWidget {
  final String text;

  const ContainerOnlyText({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Container(
            decoration: BoxDecoration(
                color: darkThemeAppBar,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text,
                  style: TextStyle(
                    color: darkThemeWords,
                    fontWeight: FontWeight.bold,
                  )),
            ))
      ],
    ));
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

class MySignInContainer extends StatelessWidget {
  const MySignInContainer({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: darkThemeSurface,
          // border: Border.all(
          //     width: 2, color: _darkTheme ? Colors.white38 : Colors.black12),
          borderRadius: BorderRadius.circular(20.0)),
    );
  }
}

class MyUserInfoContainer extends StatelessWidget {
  const MyUserInfoContainer({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
      child: child,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: _darkTheme ? darkThemeSurface : lightThemeSurface,
          // border: Border.all(
          //     width: 2, color: _darkTheme ? Colors.white38 : Colors.black12),
          borderRadius: BorderRadius.circular(20.0)),
    );
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
                        ? Colors.white70
                        : lightThemeButton.withOpacity(0.7)),
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
        // borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20.0),
//           topRight: Radius.circular(20.0),
//         ),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: child,
    );
  }
}

//used in NoteContainer for folder name
class SmallContainer extends StatelessWidget {
  SmallContainer({this.text});
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
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(
            color: _darkTheme ? darkThemeDivider : lightThemeDivider, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(text,
            style: TextStyle(
                color: _darkTheme ? darkThemeHint : lightThemeHint,
                fontSize: 10)),
      ),
    );
  }
}

///not used yet
class SmallContainerForReminder extends StatelessWidget {
  SmallContainerForReminder({this.text = '', this.bkgdColor = Colors.black38});
  final String text;
  final Color bkgdColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: bkgdColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        border: Border.all(color: Colors.white54, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.alarm, color: Colors.yellow, size: 18),
            SizedBox(width: 3),
            Flexible(
                child: Text(text,
                    style: TextStyle(color: Colors.white70, fontSize: 10))),
          ],
        ),
      ),
    );
  }
}

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
