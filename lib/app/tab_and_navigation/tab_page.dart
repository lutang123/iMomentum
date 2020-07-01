import 'package:flutter/material.dart';
import 'package:iMomentum/screens/home_screen/home_screen.dart';
import 'package:iMomentum/screens/iNotes/notes_screen/notes_screen.dart';
import 'package:iMomentum/screens/iTodo/todo_screen/todo_screen.dart';
import 'package:iMomentum/app/tab_and_navigation/tab_item.dart';

import '../../screens/account/account_page.dart';
import 'cupertino_home_scaffold.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  TabItem _currentTab = TabItem.iMomentum;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.iMomentum: GlobalKey<NavigatorState>(),
    TabItem.todo: GlobalKey<NavigatorState>(),
    TabItem.notes: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.iMomentum: (_) => HomeScreen(),
      //because we want to make TodoScreen has access to Provider<CalendarBloc>
      TabItem.todo: (context) => TodoScreen.create(context),
      TabItem.notes: (_) => NotesScreen(),
      TabItem.account: (context) => AccountPage.create(context),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
