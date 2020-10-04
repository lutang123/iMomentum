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
    this.buildEventsMarker,
    this.buildHolidayMarker,
    this.holidays,
  }) : super(key: key);
  final CalendarController calendarController;
  final Map<DateTime, List<dynamic>> events;
  final Map<DateTime, List<dynamic>> holidays;
  final AnimationController animationController;
  final Function(DateTime, List<dynamic>) onDaySelected;
  final Function(DateTime, List<dynamic>) onDayLongPressed;
  final Widget buildEventsMarker;
  final Widget buildHolidayMarker;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final DateTime today = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 12);

    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: _darkTheme ? darkThemeSurface : lightThemeSurface,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: TableCalendar(
          locale: 'en_US',
          calendarController: calendarController,
          events: events,
          holidays: holidays,
          initialSelectedDay: DateTime.now(), //default
          initialCalendarFormat: height > 700
              ? CalendarFormat.twoWeeks
              : CalendarFormat.week, //default
          formatAnimation: FormatAnimation.slide,

          ///todo, give user choice
          startingDayOfWeek: StartingDayOfWeek.sunday,
          availableGestures: AvailableGestures.all,
          calendarStyle: CalendarStyle(
            holidayStyle: Theme.of(context)
                .textTheme
                .bodyText1, //this is for the day with not-done task
            outsideStyle: Theme.of(context).textTheme.bodyText1,
            // markersColor: _darkTheme ? Colors.white70 : Colors.black54,
            // outsideDaysVisible: true, //default
            weekdayStyle: Theme.of(context).textTheme.bodyText1, //16
            weekendStyle: Theme.of(context).textTheme.bodyText1,
            outsideWeekendStyle: Theme.of(context).textTheme.bodyText1,
            // outsideHolidayStyle: const TextStyle(color: const Color(0xFFEF9A9A)),

            // weekendStyle: TextStyle(
            //     fontSize: 16,
            //     color:
            //         _darkTheme ? Colors.deepOrangeAccent : Colors.deepOrange),
            unavailableStyle: Theme.of(context).textTheme.bodyText1,
            outsideHolidayStyle: Theme.of(context).textTheme.bodyText1,
          ),

          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: Theme.of(context).textTheme.bodyText1, //16
            weekendStyle: Theme.of(context).textTheme.bodyText1,
            // weekendStyle: TextStyle(
            //     fontSize: 16,
            //     color:
            //         _darkTheme ? Colors.deepOrangeAccent : Colors.deepOrange),
          ),
          headerStyle: HeaderStyle(
            titleTextStyle: Theme.of(context).textTheme.subtitle1, //18.0,
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
            formatButtonVisible: true,
            formatButtonDecoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: _darkTheme
                    ? Color(0xFFE7E7E8)
                    : lightThemeButton.withOpacity(0.7),
                width: 1.0,
              ),
            ),
            formatButtonTextStyle: Theme.of(context).textTheme.bodyText1,
            formatButtonShowsNext: true,
          ),
          builders: CalendarBuilders(
            selectedDayBuilder: (context, date, _) {
              return FadeTransition(
                opacity:
                    Tween(begin: 0.0, end: 1.0).animate(animationController),
                child: Container(
                  decoration: BoxDecoration(
                    color: _darkTheme
                        ? calendarController.isSelected(today)
                            ? darkThemeCalendarSelectedDay
                            : darkThemeCalendarSelectedDay
                        : calendarController.isSelected(today)
                            ? lightThemeCalendarSelectedDay
                            : lightThemeCalendarSelectedDay,
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(
                      color: _darkTheme
                          ? calendarController.isSelected(today)
                              ? darkThemeCalendarSelectedDay
                              : darkThemeCalendarSelectedDay
                          : calendarController.isSelected(today)
                              ? lightThemeCalendarSelectedDay
                              : lightThemeCalendarSelectedDay,
                      width: 2.0,
                    ),
                  ),
                  margin: const EdgeInsets.all(4.0),
                  child: Center(
                    child: Text('${date.day}',
                        style: TextStyle(
                            color: Colors.white, fontSize: 16)), //16.0
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
                      color: _darkTheme
                          ? darkThemeCalendarSelectedDay
                          : lightThemeCalendarSelectedDay,
                      width: 2.0,
                    ),
                  ),
                  margin: const EdgeInsets.all(4.0),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                          fontSize: 16,
                          color: _darkTheme
                              ? darkThemeCalendarSelectedDay
                              : lightThemeCalendarSelectedDay),
                    ),
                  ));
            },
            markersBuilder: (context, date, events, holidays) {
              final children = <Widget>[];

              if (events.isNotEmpty || holidays.isNotEmpty) {
                children.add(
//
//                calendarController.isSelected(date)
//                ? Positioned(right: 1, bottom: 1, child: Container())
//                :
//
                    Positioned(
                  bottom: 5, //widget.calendarStyle.markersPositionBottom
                  ///doesn't have to be this complicated, just to leave as notes on how to build a list
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    //if we have some task not done, we only show not done marker
                    holidays.length > 0
                        ? holidays
                            .take(1) //widget.calendarStyle.markersMaxAmount
                            .map((event) => _buildDefaultNotDoneMarker(
                                date, holidays, calendarController, context))
                            .toList()[0]
                        //And if all done, and we have a list, we show done marker only, and if nothing, we show nothing.
                        : events.length > 0
                            ? events
                                .take(1) //widget.calendarStyle.markersMaxAmount
                                .map((event) => _buildDefaultMarker(
                                    date, events, calendarController, context))
                                .toList()[0]
                            : Container(),
                  ]),
                ));
              }
              return children;
            },
          ),
          onDaySelected: onDaySelected,
          onDayLongPressed: onDayLongPressed,
        ),
      ),
    );
  }

  Widget _buildDefaultMarker(DateTime date, List events,
      CalendarController calendarController, BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 0.3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _darkTheme ? Colors.white70 : Colors.black54,
      ),
    );
  }

  Widget _buildDefaultNotDoneMarker(DateTime date, List events,
      CalendarController calendarController, BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 0.3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _darkTheme ? darkThemeButton : lightThemeButton,
      ),
    );
  }

//  Widget _buildDoneMarker(DateTime date, List events,
//      CalendarController calendarController, BuildContext context) {
//    return AnimatedContainer(
//      duration: const Duration(milliseconds: 300),
//      decoration: BoxDecoration(
//          shape: BoxShape.circle,
//          color:
////        calendarController.isSelected(date)
////            ?
////            :
//
//              calendarController.isToday(date)
//                  ? Colors.brown[300]
//                  : Colors.brown[500]),
//      width: 16.0,
//      height: 16.0,
//      child: Center(
//        child: Text(
//          '${events.length}',
//          style: TextStyle().copyWith(
//            color: Colors.white,
//            fontSize: 12.0,
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget _buildNotDoneMarker(
//      DateTime date, List events, CalendarController calendarController) {
//    return AnimatedContainer(
//      duration: const Duration(milliseconds: 300),
//      decoration: BoxDecoration(
//          shape: BoxShape.circle,
//          color:
////        calendarController.isSelected(date)
////            ?
////            :
//
//              calendarController.isToday(date)
//                  ? Colors.deepOrange[300]
//                  : Colors.deepOrange[500]),
//      width: 16.0,
//      height: 16.0,
//      child: Center(
//        child: Text(
//          '${events.length}',
//          style: TextStyle().copyWith(
//            color: Colors.white,
//            fontSize: 12.0,
//          ),
//        ),
//      ),
//    );
//  }

//
}
