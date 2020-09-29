import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/keys_sign_in.dart';
import 'package:iMomentum/screens/tab_and_navigation/tab_item.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

@immutable
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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return CupertinoTabScaffold(
      backgroundColor: Colors.transparent,
      tabBar: CupertinoTabBar(
        key: const Key(Keys.tabBar),
        backgroundColor: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
        items: [
          _buildItem(context, TabItem.home),
          _buildItem(context, TabItem.todo),
          _buildItem(context, TabItem.notes),
        ],
        onTap: (index) => onSelectTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[item],
          builder: (context) => widgetBuilders[item](context),

          /// in Android's new code.
          // onGenerateRoute: CupertinoTabViewRouter.generateRoute,
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(BuildContext context, TabItem tabItem) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final itemData = TabItemData.allTabs[tabItem];
    final color = _darkTheme
        ? currentTab == tabItem
            ? darkThemeButton
            : darkThemeButton.withOpacity(0.5)
        : currentTab == tabItem
            ? lightThemeButton
            : lightThemeButton.withOpacity(0.5);
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
              color: color, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
