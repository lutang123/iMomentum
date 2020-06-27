import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/tab_and_navigation/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    Key key,
    @required this.currentTab,
    @required this.onSelectTab,
    @required this.widgetBuilders,
    @required this.navigatorKeys,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.black12,
        items: [
          _buildItem(TabItem.iMomentum),
          _buildItem(TabItem.todo),
          _buildItem(TabItem.notes),
//          _buildItem(TabItem.entries),
          _buildItem(TabItem.account),
        ],
        onTap: (index) => onSelectTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[item],
          builder: (context) => widgetBuilders[item](context),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    final color = currentTab == tabItem ? Colors.white : Colors.grey;
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Icon(
          itemData.icon,
          color: color,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 3.0),
        child: Text(
          itemData.title,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
