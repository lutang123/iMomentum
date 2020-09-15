import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iMomentum/app/sign_in/auth_service.dart';
import 'package:iMomentum/screens/home_screen/home_screen.dart';
import 'package:iMomentum/screens/notes_screen/folder_screen.dart';
import 'package:iMomentum/screens/todo_screen/todo_screen.dart';
import 'package:iMomentum/app/tab_and_navigation/tab_item.dart';
import 'package:provider/provider.dart';
import '../../screens/home_drawer/home_drawer.dart';
import 'cupertino_home_scaffold.dart';
import 'package:iMomentum/app/utils/cap_string.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  @override
  void initState() {
    /// test on where to call this function
    _showDailyAtTime();
    super.initState();
  }

  /// for local notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Showing a daily notification at a specific time
  Future<void> _showDailyAtTime() async {
    final User user = Provider.of<User>(context, listen: false);

    String userName = user.displayName == null
        ? ''
        : user.displayName.contains(' ')
            ? '${user.displayName.substring(0, user.displayName.indexOf(' ')).firstCaps}'
            : '${user.displayName.firstCaps}';

    // String _toTwoDigitString(int value) {
    //   return value.toString().padLeft(2, '0');
    // }

    var time = Time(10, 0, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0, //id
        'Good morning, $userName', //title
        //body
        "Have a nice day!",
        //notificationTime
        time,
        //NotificationDetails notificationDetails
        platformChannelSpecifics);
  }

  TabItem _currentTab = TabItem.home;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.todo: GlobalKey<NavigatorState>(),
    TabItem.notes: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.home: (_) => MyDrawer(child: HomeScreen()),
      //because we want to make TodoScreen has access to Provider<CalendarBloc>,
      //and this context is from TodoScreen
      TabItem.todo: (context) => TodoScreen.create(context),
      TabItem.notes: (_) => FolderScreen(),
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
