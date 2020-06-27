//import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:iMomentum/screens/iMeditate/constants/theme.dart';
//import 'package:iMomentum/screens/iMeditate/meditation_screens/meditation_begin_screen.dart';
//import 'package:iMomentum/screens/iMeditate/utils/utils.dart';
//import 'package:iMomentum/screens/iNotes/notes_screen/notes_main_page.dart';
//import 'package:iMomentum/screens/iPomodoro/pomodoro_begin_screen.dart';
//import 'package:iMomentum/screens/iTodo/todo_screen/todo_calendar_screen.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
//
//class CustomizedBottomBar extends StatelessWidget {
//  const CustomizedBottomBar({
//    Key key,
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      margin: EdgeInsets.only(top: 5.0),
//      width: double.infinity,
//      color: Colors.black12,
//      child: Padding(
//        padding:
//            const EdgeInsets.only(left: 15.0, right: 15, top: 20, bottom: 40),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            InkWell(
//              onTap: () {
//                Navigator.push(
//                    context, MaterialPageRoute(builder: (context) => Notes()));
//              },
//              child: Column(
//                children: <Widget>[
//                  FaIcon(
//                    FontAwesomeIcons.stickyNote,
//                    color: Colors.white,
//                    size: 30,
//                  ),
//                  SizedBox(height: 5),
//                  Text('iNotes',
//                      style: TextStyle(color: Colors.white, fontSize: 18)),
//                ],
//              ),
//            ),
//            InkWell(
//              onTap: () {
//                showModalBottomSheet(
//                  context: context,
//                  isScrollControlled: true,
//                  builder: (context) => MeditationBeginScreen(),
//                );
//              },
////              onTap: () {
////                Navigator.push(
////                    context,
////                    MaterialPageRoute(
////                        builder: (context) =>MainScreen(startingAnimation: true)));
////              },
//              child: Column(
//                children: <Widget>[
//                  FaIcon(
//                    FontAwesomeIcons.smile,
//                    color: Colors.white,
//                    size: 30,
//                  ),
//                  SizedBox(height: 5),
//                  Text('iMeditate',
//                      style: TextStyle(color: Colors.white, fontSize: 18)),
//                ],
//              ),
//            ),
//            InkWell(
//              onTap: () {
//                showModalBottomSheet(
//                  context: context,
//                  isScrollControlled: true,
//                  builder: (context) => PomodoroBeginScreen(),
//                );
//              },
//              child: Column(
//                children: <Widget>[
//                  FaIcon(
//                    FontAwesomeIcons.clock,
//                    color: Colors.white,
//                    size: 30,
//                  ),
//                  SizedBox(height: 5),
//                  Text('iPomodoro',
//                      style: TextStyle(color: Colors.white, fontSize: 18)),
//                ],
//              ),
//            ),
//            InkWell(
//              onTap: () => showCupertinoModalBottomSheet(
//                expand: true,
//                context: context,
//                backgroundColor: isDark(context) ? darkSurface : lightSurface,
//                builder: (context, scrollController) =>
//                    Todo(scrollController: scrollController),
//              ),
//
////              onTap: () {
////                Navigator.push(
////                    context, MaterialPageRoute(builder: (context) => Todo()));
////              },
//              child: Column(
//                children: <Widget>[
//                  FaIcon(
//                    FontAwesomeIcons.calendarAlt,
//                    color: Colors.white,
//                    size: 30,
//                  ),
//                  SizedBox(height: 5),
//                  Text('iTodo',
//                      style: TextStyle(color: Colors.white, fontSize: 18)),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
//
////
////class ButtomBar extends StatelessWidget {
////  const ButtomBar({
////    Key key,
////  }) : super(key: key);
////
////  @override
////  Widget build(BuildContext context) {
////    return BottomNavigationBar(
////      //fixedColor and selectedItemColor can only have one.
//////                fixedColor: Colors.white,
////      selectedItemColor: Colors.white70,
////      type: BottomNavigationBarType.fixed,
//////                onTap: onTabTapped, // new
//////                currentIndex: _currentIndex, // new
////      items: [
////        BottomNavigationBarItem(
////          icon: InkWell(
////              child: FaIcon(FontAwesomeIcons.stickyNote),
////              onTap: () {
////                Navigator.push(
////                    context, MaterialPageRoute(builder: (context) => Notes()));
////              }),
////          title: GestureDetector(
////              child: Text('screens.Notes'),
////              onTap: () {
////                Navigator.push(
////                    context, MaterialPageRoute(builder: (context) => Notes()));
////              }),
////        ),
////        BottomNavigationBarItem(
////          icon: GestureDetector(
////            child: FaIcon(FontAwesomeIcons.smile),
////            onTap: () {
////              Navigator.push(
////                  context,
////                  MaterialPageRoute(
////                      builder: (context) =>
////                          MainScreen(startingAnimation: true)));
////            },
////          ),
////          title: Text('Meditate'),
////        ),
////        BottomNavigationBarItem(
////          icon: GestureDetector(
////            child: FaIcon(FontAwesomeIcons.clock),
////            onTap: () {
////              Navigator.push(
////                  context, MaterialPageRoute(builder: (context) => Pomodoro()));
////            },
////          ),
////          title: Text('Pomodoro'),
////        ),
////        BottomNavigationBarItem(
////          icon: GestureDetector(
////              child: FaIcon(FontAwesomeIcons.calendarAlt),
////              onTap: () {
////                Navigator.push(
////                    context, MaterialPageRoute(builder: (context) => Todo()));
////              }),
////          title: GestureDetector(
////              child: Text('Todo'),
////              onTap: () {
////                Navigator.push(
////                    context, MaterialPageRoute(builder: (context) => Todo()));
////              }),
////        ),
////      ],
////    );
////  }
////}
