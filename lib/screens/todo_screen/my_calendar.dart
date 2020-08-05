import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:iMomentum/app/constants/theme.dart';

class MyCalendar extends StatelessWidget {
  const MyCalendar({
    Key key,
    @required this.calendarController,
    @required this.events,
    this.animationController,
    this.onDaySelected,
    this.onDayLongPressed,
    this.markerDone,
    this.markerNotDone,
    this.notDoneMap,
  }) : super(key: key);
  final CalendarController calendarController;
  final Map<DateTime, List<dynamic>> events;
  final Map<DateTime, List<dynamic>> notDoneMap;
  final AnimationController animationController;
  final Function(DateTime, List<dynamic>) onDaySelected;
  final Function(DateTime, List<dynamic>) onDayLongPressed;
  final Widget markerDone;
  final Widget markerNotDone;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final DateTime today = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 12);
    return TableCalendar(
      locale: 'en_US',
      calendarController: calendarController,
      events: events,
      holidays: notDoneMap,
      initialSelectedDay: DateTime.now(), //default
      initialCalendarFormat: CalendarFormat.twoWeeks, //default
      formatAnimation: FormatAnimation.slide, //?
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      calendarStyle: CalendarStyle(
        markersColor: _darkTheme ? Colors.white70 : Colors.black54,
        outsideDaysVisible: false,
        weekdayStyle: Theme.of(context).textTheme.bodyText1,
        weekendStyle: Theme.of(context).textTheme.bodyText1,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: Theme.of(context).textTheme.bodyText1,
        weekendStyle: Theme.of(context).textTheme.bodyText1,
      ),
      headerStyle: HeaderStyle(
          titleTextStyle: Theme.of(context).textTheme.subtitle1,
          leftChevronIcon: Icon(
            FontAwesomeIcons.chevronLeft,
            color: _darkTheme ? Color(0xFFE7E7E8) : Colors.black38,
            size: 25,
          ),
          rightChevronIcon: Icon(
            FontAwesomeIcons.chevronRight,
            color: _darkTheme ? Color(0xFFE7E7E8) : Colors.black38,
            size: 25,
          ),
          centerHeaderTitle: true,
          formatButtonVisible: false
//        formatButtonDecoration: BoxDecoration(
//          color: Colors.transparent,
//          borderRadius: BorderRadius.circular(20.0),
//          border: Border.all(
//            color: _darkTheme ? Color(0xFFE7E7E8) : Colors.black38,
//            width: 1.0,
//          ),
//        ),
//        formatButtonTextStyle: Theme.of(context).textTheme.button,
//        formatButtonShowsNext: false,
          ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(animationController),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50.0),
                border: Border.all(
                  color: _darkTheme
                      ? calendarController.isSelected(today)
                          ? Color(0xFFfcbf1e)
                          : Color(0xFF40bad5)
                      : calendarController.isSelected(today)
                          ? Color(0xFFfcbf1e)
                          : Color(0xFF40bad5),
                  width: 2.0,
                ),
              ),
              margin: const EdgeInsets.all(4.0),
              child: Center(
                child: Text('${date.day}',
                    style: Theme.of(context).textTheme.bodyText1),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(50.0),
              border: Border.all(
                color: _darkTheme ? Color(0xFFfcbf1e) : Color(0xFFfcbf1e),
                width: 2.0,
              ),
            ),
            margin: const EdgeInsets.all(4.0),
            child: Center(
              child: Text('${date.day}',
                  style: Theme.of(context).textTheme.bodyText1),
            ),
          );
        },
//        markersBuilder: (context, date, done, notDone) {
//          final children = <Widget>[];
//
//          if (done.isNotEmpty) {
//            children.add(
//              Positioned(
//                right: 1,
//                bottom: 1,
//                child: markerDone,
//              ),
//            );
//          }
//
//          if (notDone.isNotEmpty) {
//            children.add(
//              Positioned(
//                right: -2,
//                top: -2,
//                child: markerNotDone,
//              ),
//            );
//          }
//
//          return children;
//        },
      ),

      onDaySelected: onDaySelected,
      onDayLongPressed: onDayLongPressed,
    );
  }

//
}
