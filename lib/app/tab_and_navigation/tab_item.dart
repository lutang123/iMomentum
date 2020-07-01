import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TabItem { iMomentum, todo, notes, account }

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.iMomentum: TabItemData(title: 'Home', icon: FontAwesomeIcons.home),
    TabItem.todo:
        TabItemData(title: 'Todo', icon: FontAwesomeIcons.calendarAlt),
    TabItem.notes:
        TabItemData(title: 'Notes', icon: FontAwesomeIcons.stickyNote),
//    TabItem.entries: TabItemData(title: 'Entries', icon: FontAwesomeIcons.list),
    TabItem.account: TabItemData(
      title: 'Account',
      icon: FontAwesomeIcons.user,
    ),
  };
}
