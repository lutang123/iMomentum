import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCalendar extends StatelessWidget {
  const MyCalendar(
      {Key key,
      @required this.calendarController,
      @required this.events,
      this.animationController,
      this.onDaySelected,
      this.onDayLongPressed})
      : super(key: key);
  final CalendarController calendarController;
  final Map<DateTime, List<dynamic>> events;
  final AnimationController animationController;
  final Function(DateTime, List<dynamic>) onDaySelected;
  final Function(DateTime, List<dynamic>) onDayLongPressed;

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 12);
    return TableCalendar(
      locale: 'en_US',
      calendarController: calendarController,
      events: events,
      initialSelectedDay: DateTime.now(), //default
      initialCalendarFormat: CalendarFormat.twoWeeks, //default
      formatAnimation: FormatAnimation.slide, //?
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all, //?
      calendarStyle: CalendarStyle(
        markersColor: Colors.white70,
        canEventMarkersOverflow: true,
        outsideDaysVisible: false,
        weekdayStyle: TextStyle(
//          fontWeight: FontWeight.w400,
          fontSize: 18.0,
        ),
        weekendStyle: TextStyle(
//          fontWeight: FontWeight.w400,
          fontSize: 18.0,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
//          fontWeight: FontWeight.w600,
          fontSize: 20.0,
        ),
        weekendStyle: TextStyle(
//          fontWeight: FontWeight.w600,
          fontSize: 20.0,
        ),
      ),
      headerStyle: HeaderStyle(
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 20.0,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Colors.white,
          size: 28,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Colors.white,
          size: 28,
        ),
        centerHeaderTitle: true,
        formatButtonDecoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        formatButtonTextStyle: GoogleFonts.varelaRound(
          fontWeight: FontWeight.w400,
          fontSize: 18.0,
        ),
        formatButtonShowsNext: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(animationController),
            child: Container(
              decoration: BoxDecoration(
//                color: Color(0xFFdf984d),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50.0),
                border: Border.all(
                  color: calendarController.isSelected(today)
                      ? Colors.deepOrangeAccent
                      : Colors.white70,
                  width: 2.0,
                ),
              ),
              margin: const EdgeInsets.all(4.0),
//              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
//                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            decoration: BoxDecoration(
//              color: Colors.amber[400],
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(50.0),
              border: Border.all(
                color: Colors.deepOrangeAccent,
                width: 2.0,
              ),
            ),
            margin: const EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                '${date.day}',
                style: GoogleFonts.varelaRound(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                ),
              ),
            ),
          );
        },
      ),
      onDaySelected: onDaySelected,
      onDayLongPressed: onDayLongPressed,
    );
  }
}
