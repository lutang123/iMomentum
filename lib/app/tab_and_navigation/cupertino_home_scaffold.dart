import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/tab_and_navigation/tab_item.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

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
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return CupertinoTabScaffold(
      backgroundColor: Colors.transparent,
      tabBar: CupertinoTabBar(
        backgroundColor: _darkTheme ? Colors.black12 : Color(0xF0F9F9F9),
        items: [
          _buildItem(context, TabItem.home),

          _buildItem(context, TabItem.todo),
          _buildItem(context, TabItem.notes),

//          _buildItem(TabItem.entries),
//          _buildItem(TabItem.account),
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

  BottomNavigationBarItem _buildItem(BuildContext context, TabItem tabItem) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final itemData = TabItemData.allTabs[tabItem];
    final color = _darkTheme
        ? currentTab == tabItem
            ? Colors.white
            : Color(0xF0e6dedd).withOpacity(0.7)
        : currentTab == tabItem
            ? Colors.black87.withOpacity(0.9)
            : Colors.black38.withOpacity(0.45);
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
              color: color, fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
