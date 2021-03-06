import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/my_sizedbox.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

class TodoTopRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    return Container(
      color: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
      child: Column(
        children: [
          MyTopSizedBox(),
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TabBar(
                indicatorColor: _darkTheme ? darkThemeButton : lightThemeButton,
                tabs: [
                  Tab(
                    icon: Icon(
                      FontAwesomeIcons.list,
                      size: 25,
                      color: _darkTheme ? darkThemeButton : lightThemeButton,
                    ),
                  ),
                  Tab(
                      icon: Icon(
                    FontAwesomeIcons.chartPie,
                    size: 25,
                    color: _darkTheme ? darkThemeButton : lightThemeButton,
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
