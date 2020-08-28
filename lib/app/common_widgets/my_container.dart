import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

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

class ContainerForNotesPinned extends StatelessWidget {
  final String text;

  const ContainerForNotesPinned({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
        child: Row(
      children: [
        Container(
            decoration: BoxDecoration(
                color: _darkTheme ? Colors.black12 : lightThemeSurface,
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

class NoteSearchBar extends StatelessWidget {
  final VoidCallback onPressed;

  const NoteSearchBar({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
        decoration: BoxDecoration(
            color: _darkTheme ? Colors.black38 : lightThemeSurface,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton.icon(

                ///Todo: implement search
                onPressed: onPressed,
                icon: Icon(
                  Icons.search,
                  color: Colors.white70,
                ),
                label: Text(
                  'Search your notes',
                  style: TextStyle(color: Colors.white70),
                )),
          ],
        ));
  }
}

class CustomizedContainer extends StatelessWidget {
  CustomizedContainer({this.child, this.color});
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 8.0, right: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: child,
    );
  }
}

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

class SmallContainer extends StatelessWidget {
  SmallContainer({this.text, this.bkgdColor = Colors.black38});
  final String text;
  final Color bkgdColor;

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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: bkgdColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        border: Border.all(color: Colors.white54, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child:
            Text(text, style: TextStyle(color: Colors.white70, fontSize: 10)),
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
