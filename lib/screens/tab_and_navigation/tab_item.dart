import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

enum TabItem {
  home,
  todo,
  notes,
}

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.home: TabItemData(title: 'Home', icon: EvaIcons.homeOutline),
    TabItem.todo: TabItemData(title: 'Todo', icon: EvaIcons.listOutline),
    TabItem.notes: TabItemData(title: 'Notes', icon: EvaIcons.bookOutline),

//    TabItem.entries: TabItemData(title: 'Entries', icon: FontAwesomeIcons.list),
//    TabItem.account: TabItemData(
//      title: 'Account',
//      icon: FontAwesomeIcons.user,
//    ),
  };
}
