//import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//
//class ScreenCalendar extends StatefulWidget {
//  @override
//  _ScreenCalendarState createState() => new _ScreenCalendarState();
//}
//
//class _ScreenCalendarState extends State<ScreenCalendar> {
//  static String noEventText = "Событий нет";
//  String tabBarTitle = "Calendar";
//  String calendarText = noEventText;
//  DateTime _currentDate = DateTime.now();
//  Color _colorButtonColor = Colors.indigo;
//  Color _colorTextButtonColor = Colors.black;
//  Color _colorTextTodayButton = Colors.white;
//
//  static const String _calendarRussian = "calendarRussian";
//  static const String _eventTitle = "eventTitle";
//
//  static const String _eventDay = "eventDay";
//  static const String _eventMonth = "eventMonth";
//  static const String _eventYear = "eventYear";
//
//  void getCalendarEventList() {
//    Firestore.instance.collection(_calendarRussian).snapshots().listen((data) =>
//        data.documents.forEach((doc) => _markedDateMap.add(
//                new DateTime(int.parse(doc[_eventYear]),
//                    int.parse(doc[_eventMonth]), int.parse(doc[_eventDay])),
//                new Event(
//                    date: new DateTime(int.parse(doc[_eventYear]),
//                        int.parse(doc[_eventMonth]), int.parse(doc[_eventDay])),
//                    title: doc[_eventTitle],
//                    icon: _eventIcon))
////            context.setState(() => refresh(DateTime.now()))}
//            ));
//  }
//
//  @override
//  void initState() {
//    getCalendarEventList();
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: AppBar(
//          title: Text(
//            tabBarTitle,
//            style: Constants.myTextStyleAppBar,
//          ),
//          iconTheme: Constants.myIconThemeDataAppBar,
//          elevation: Constants.myElevationAppBar,
//          backgroundColor: Constants.myAppBarColor,
//        ),
//        body: SingleChildScrollView(
//            child: Column(children: <Widget>[
//          Card(
//              child: CalendarCarousel(
//            weekendTextStyle: TextStyle(
//              color: Colors.red,
//            ),
//            weekFormat: false,
//            selectedDateTime: _currentDate,
//            markedDatesMap: _markedDateMap,
//            selectedDayBorderColor: Colors.transparent,
//            selectedDayButtonColor: Colors.indigo[300],
//            todayTextStyle:
//                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//            selectedDayTextStyle: TextStyle(color: _colorTextButtonColor),
//            todayBorderColor: Colors.indigo,
//            weekdayTextStyle: TextStyle(color: Colors.black),
//            height: 420.0,
//            daysHaveCircularBorder: true,
//            todayButtonColor: Colors.transparent,
//            locale: 'RUS',
//            onDayPressed: (DateTime date, List<Event> events) {
//              this.setState(() => refresh(date));
//            },
//          )),
//          Card(
//              child: Container(
//                  child: Padding(
//                      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
//                      child: Center(
//                          child: Text(
//                        calendarText,
//                        style: Constants.textStyleCommonText,
//                      )))))
//        ])));
//  }
//
//  void refresh(DateTime date) {
//    _currentDate = date;
//    print('selected date ' +
//        date.day.toString() +
//        date.month.toString() +
//        date.year.toString() +
//        ' ' +
//        date.toString());
//    if (_markedDateMap
//        .getEvents(new DateTime(date.year, date.month, date.day))
//        .isNotEmpty) {
//      calendarText = _markedDateMap
//          .getEvents(new DateTime(date.year, date.month, date.day))[0]
//          .title;
//    } else {
//      calendarText = noEventText;
//    }
//    if (date == _currentDate) {
//      _colorButtonColor = Colors.indigo;
//      _colorTextButtonColor = Colors.white;
//      _colorTextTodayButton = Colors.white;
//    } else {
//      _colorTextButtonColor = Colors.indigo;
//      _colorTextTodayButton = Colors.black;
//    }
//  }
//}
//
//EventList<Event> _markedDateMap = new EventList<Event>(events: {
//  new DateTime(2019, 1, 24): [
//    new Event(
//      date: new DateTime(2019, 1, 24),
//      title: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
//          'sed eiusmod tempor incidunt ut labore et dolore magna aliqua.'
//          ' \n\nUt enim ad minim veniam,'
//          ' quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat.'
//          ' \n\nQuis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '
//          'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
//      icon: _eventIcon,
//    )
//  ]
//});
//
//Widget _eventIcon = new Container(
//  decoration: new BoxDecoration(
//      color: Colors.white,
//      borderRadius: BorderRadius.all(Radius.circular(1000)),
//      border: Border.all(color: Colors.blue, width: 2.0)),
//  child: new Icon(
//    Icons.person,
//    color: Colors.amber,
//  ),
//);
