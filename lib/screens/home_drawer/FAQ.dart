import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_stack_screen.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/home_drawer/mantra_top_title.dart';
import 'package:provider/provider.dart';

class FAQ extends StatefulWidget {
  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return MyStackScreen(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: CustomizedContainerNew(
          color: _darkTheme ? darkThemeSurface : lightThemeSurface,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                MantraTopTitle(
                  title: 'Frequent Asked Questions',
                  subtitle: '',
                  onPressed: null,
                  flatButtonText: '',
                  darkTheme: _darkTheme,
                ),
                Column(
                  children: <Widget>[
                    buildContent(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  buildContent() {
    return Column(
      children: [
        Row(
          children: [Text('Question 1: '), Text('')],
        ),
        Row(
          children: [Text('Answer: '), Text('')],
        )
      ],
    );
  }
}
