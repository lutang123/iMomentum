import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/format.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/screens/entries/calendar_bloc.dart';
import 'package:iMomentum/screens/entries/daily_todos_details.dart';
import 'package:iMomentum/screens/iTodo/todo_screen/my_pie_chart.dart';
import 'package:iMomentum/screens/jobs/empty_content.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:iMomentum/screens/iTodo/todo_screen/my_calendar.dart';

///somehow this is not working
class ChartsFlutter extends StatefulWidget {
  @override
  _ChartsFlutterState createState() => _ChartsFlutterState();
}

class _ChartsFlutterState extends State<ChartsFlutter>
    with TickerProviderStateMixin {
  CalendarController _calendarControllerNew;
  AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
    _calendarControllerNew = CalendarController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _calendarControllerNew.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.network(Constants.homePageImage, fit: BoxFit.cover),
        ContainerLinearGradient(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: <Widget>[],
          ),
          body: _buildContents(context),
        ),
      ],
    );
  }

  ///for charts_flutter pie chart
  List<charts.Series<TodoDetails, String>> _seriesPieData;

  ///  var piedata = [
  ////    new Task('Work', 35.8, color),
  ////    new Task('Eat', 8.3, color),
  ////  ];
  List<TodoDetails>
      _pieDataToday; //DailyTodosDetails.groupByDate(date, entries)
  List<TodoDetails> _pieDataSelected = [];

  ///PieChart can only render a singleSeries, so we need to do this instead of getting _seriesPieData separately for Today and SelectedDay
  void _generateData(List<TodoDetails> myList) {
    //PieChart can only be rendered a singleSeries
    //_seriesPieData will be passed to the pieChart, when this function is called, it will be initialized and assign value.
    _seriesPieData = List<charts.Series<TodoDetails, String>>();
    if (myList != null) {
      _seriesPieData.add(
        charts.Series(
          domainFn: (TodoDetails task, _) => task.title,
          measureFn: (TodoDetails task, _) => task.durationInHours,
//        colorFn: TodoDetails task, _) =>
//            charts.ColorUtil.fromDartColor(Color(int.parse(task.colorVal))),
          id: 'tasks',
          data: myList,
          labelAccessorFn: (TodoDetails row, _) => "${row.durationInHours}",
        ),
      );
      print(
          _seriesPieData); //flutter: [Instance of 'Series<TodoDetails, String>']
      print(
          'tapped'); //when tap on a selectedDay, this function runs 4 times?? and in setState, ot runs once
    }
  }

  //must give an initial value because it directly used in Text
  double _todayDuration = 0;

  double _selectedDuration = 0;

  Widget _buildContents(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bloc = Provider.of<CalendarBloc>(context, listen: false);
    return StreamBuilder<List<TodoDuration>>(
        stream: bloc
            .allTodoDurationStream, //print: flutter: Instance of '_MapStream<List<TodoDuration>, dynamic>'
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<TodoDuration> entries = snapshot
                .data; //print('x: $entries'); //x: [Instance of 'TodoDuration', Instance of 'TodoDuration']
            if (entries.isNotEmpty) {
              final _eventsNew = DailyTodosDetails.getEventsNew(
                  entries); //{2020-06-22 12:00:00.000: [Instance of 'DailyTodosDetails'], 2020-06-23 12:00:00.000: [Instance of 'DailyTodosDetails']}
//                                  //print(_todayEntries);
              _pieDataToday = DailyTodosDetails.getPieDataGroupByData(
                  DateTime.now(), entries); //start []
              ///whe no data, the chart crashes
              if (_pieDataToday.length > 0) {
                ///STEP 1:
//                                  print(
//                                      '_pieDataToday1: $_pieDataToday'); //_seriesPieDataToday: [Instance of 'Series<TodoDetails, String>']
//                                  ///STEP 2:
                _generateData(_pieDataToday);
              }
//                                  ///STEP 3:
//                                  print(
//                                      '_pieDataToday2: $_pieDataToday'); //_seriesPieDataToday: [Instance of 'Series<TodoDetails, String>']

              ///same problem when using pie_charts, the above line was executed three times when selecting a day
              _todayDuration = DailyTodosDetails.getDailyTotalDuration(
                  DateTime.now(), entries);
//                                  print(_todayDuration); // if no data, it will show null, not 0//flutter: 0.016666666666666666
              return Column(
                children: <Widget>[
                  Container(
                    color: Colors.black26,
                    child: MyCalendar(
                      events: _eventsNew,
                      calendarController: _calendarControllerNew,
                      onDaySelected: (date, _) {
                        setState(() {
                          _calendarControllerNew.isToday(
                                  date) //if selected today, we only render _todayList, in this way, _todayList can be dynamically display when added new data in home screen.
                              ? _pieDataSelected =
                                  [] //if it's empty, use today's list
                              :
                              //when we tap on other days, why the screen still shows today's chart??
                              _pieDataSelected =
                                  DailyTodosDetails.getPieDataGroupByData(
                                      date, entries);
//                                                  print(
//                                                      _pieDataSelected); //[Instance of 'TodoDetails']
                          _generateData(_pieDataSelected);
//                                                  print('selected');

                          _selectedDuration =
                              DailyTodosDetails.getDailyTotalDuration(
                                  date, entries);
                        });
                      },
                      animationController: _animationController,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        color: Colors.black26,
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Focused Time on daily tasks',
                              style: TextStyle(fontSize: 24.0),
                            ),
                            SizedBox(height: 10.0),
                            _pieDataSelected.isEmpty
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: size.height / 3.5,
                                        child: MyPieChart(
                                            seriesPieData: _seriesPieData),
                                      ), //only initialize in the generateData function
                                      Center(
                                        child: Column(
                                          children: <Widget>[
                                            Text('Total'),
                                            SizedBox(height: 5),
                                            Text(Format.hours(_todayDuration)),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                : Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                          height: size.height / 3.5,
                                          child:

                                              ///removed 'No data yet', but screen only show today's chart
                                              MyPieChart(
                                                  seriesPieData:
                                                      _seriesPieData)),
                                      Center(
                                        child: Column(
                                          children: <Widget>[
                                            Text('Total'),
                                            SizedBox(height: 5),
                                            Text(Format.hours(
                                                _selectedDuration)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Text('Add new TODO here'));
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                children: <Widget>[
                  Text(snapshot.error.toString()),
                  ErrorMessage(
                    title: 'Something went wrong',
                    message: 'Can\'t load items right now',
                  )
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
