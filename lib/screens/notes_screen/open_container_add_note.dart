import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

const double _fabDimension = 56.0;

class OpenContainerAddNotes extends StatelessWidget {
  const OpenContainerAddNotes({
    Key key,
    @required this.context,
    @required this.openWidget,
  });

  final BuildContext context;
  final Widget openWidget;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return OpenContainer(
      useRootNavigator: true,
      transitionType: ContainerTransitionType.fade,
      openElevation: 0.0,
      openColor: Colors.transparent,
      openBuilder: (BuildContext context, VoidCallback _) {
        return openWidget;
      },
      closedElevation: 6.0,
      // closedColor: Colors.transparent,
      closedColor: _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
      closedShape: RoundedRectangleBorder(
        side: BorderSide(
            color: _darkTheme ? darkThemeButton : lightThemeButton, width: 2.0),
        borderRadius: BorderRadius.all(
          Radius.circular(_fabDimension / 2),
        ),
      ),
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return SizedBox(
            height: _fabDimension,
            width: _fabDimension,
            child: Center(
              child: Icon(Icons.add,
                  size: 30,
                  color: _darkTheme ? darkThemeButton : lightThemeButton),
            ));
      },
    );
  }
}
