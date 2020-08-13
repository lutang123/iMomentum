import 'package:flutter/material.dart';
import 'package:iMomentum/screens/home_screen/home_screen.dart';
import 'package:iMomentum/screens/notes_screen/notes_drawer.dart';
import 'package:iMomentum/screens/notes_screen/folder_screen.dart';
import 'package:iMomentum/screens/notes_screen/notes_screen.dart';
import 'package:iMomentum/screens/todo_screen/todo_screen.dart';
import 'package:iMomentum/app/tab_and_navigation/tab_item.dart';
import '../../screens/home_drawer/home_drawer.dart';
import 'cupertino_home_scaffold.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  TabItem _currentTab = TabItem.home;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.todo: GlobalKey<NavigatorState>(),
    TabItem.notes: GlobalKey<NavigatorState>(),
//    TabItem.account: GlobalKey<NavigatorState>(),
  };

//  /// Stores the current page index for the api requests.
//  int page = 1, totalPages = -1;
//
//  /// Stores the currently loaded loaded images.
//  List<UnsplashImage> imageList = [];
//
//  @override
//  void initState() {
//    super.initState();
//    _loadImages();
//  }
//
//  _loadImages() async {
//    // load images
//    List<UnsplashImage> images;
//
//    List res = await UnsplashImageProvider.loadImagesWithKeyword(page: ++page);
//    // set totalPages
//    totalPages = res[0];
//    // set images
//    images = res[1];
//    print('totalPages: $totalPages');
////    print(images.length); //10
//
//    // TODO: handle errors
//
//    // update the state
//    setState(() {
//      // done loading
////      loadingImages = false;
//      // set new loaded images
//      this.imageList.addAll(images);
//    });
//    print(images);
//  }
//
////  Future<void> fetchImage() async {
////    final image = await UnsplashImageProvider.loadImagesRandom();
////    print(image);
////    print('loaded');
////  }

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.home: (_) => MyDrawer(child: HomeScreen()),
      //because we want to make TodoScreen has access to Provider<CalendarBloc>
      TabItem.todo: (context) => TodoScreen.create(context),
//      TabItem.notes: (_) => NotesDrawer(child: NotesScreen()),
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
