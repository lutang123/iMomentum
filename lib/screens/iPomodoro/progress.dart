import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/avatar.dart';
import 'package:iMomentum/app/common_widgets/customized_bottom_sheet.dart';
import 'package:iMomentum/app/common_widgets/format.dart';
import 'package:iMomentum/app/common_widgets/linear_gradient_container.dart';
import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/screens/entries/calendar_bloc.dart';
import 'package:iMomentum/screens/entries/daily_todos_details.dart';
import 'package:iMomentum/screens/entries/entries_bloc.dart';
import 'package:iMomentum/screens/entries/entries_list_tile.dart';
import 'package:iMomentum/app/services/auth.dart';
import 'package:iMomentum/screens/entries/entry_job.dart';
import 'package:iMomentum/screens/jobs/empty_content.dart';
import 'package:iMomentum/screens/jobs/list_items_builder.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:iMomentum/screens/iTodo/todo_screen/new_pie_chart.dart';
import 'package:iMomentum/screens/iTodo/todo_screen/my_calendar.dart';
import 'package:iMomentum/screens/iTodo/todo_screen/my_pie_chart.dart';

class Progress extends StatefulWidget {
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> with TickerProviderStateMixin {
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
            actions: <Widget>[
//              FlatButton(
//                child: Text(
//                  'Logout',
//                  style: TextStyle(
//                    fontSize: 18.0,
//                    color: Colors.white,
//                  ),
//                ),
//                onPressed: () => _confirmSignOut(context),
//              ),
            ],
          ),
          body: _buildContents(context),
        ),
      ],
    );
  }

  ///notes for pie_charts
  ///
  Map<String, double> _dataMapToday;

  Map<String, double> _dataMapSelected = {};

  Map<String, double> _getDataMapToday(List<TodoDuration> entries) {
    final _todayEntries =
        DailyTodosDetails.getTodayEntries(entries); //List<DailyTodosDetails>
    Map<String, double> _mapDataToday = {};
    _todayEntries.forEach((dailyTodosDetails) {
      for (TodoDetails jobDuration in dailyTodosDetails.todosDetails) {
        _mapDataToday[jobDuration.title] = jobDuration.durationInHours;
      }
    });
    return _mapDataToday;
  }

  Map<String, double> _getDataMapSelected(
      DateTime date, List<TodoDuration> entries) {
    final _selectedEntries = DailyTodosDetails.getSelectedDayEntries(
        date, entries); //List<DailyTodosDetails>
    Map<String, double> _mapDataSelected = {};
    _selectedEntries.forEach((dailyTodosDetails) {
      for (TodoDetails jobDuration in dailyTodosDetails.todosDetails) {
        _mapDataSelected[jobDuration.title] = jobDuration.durationInHours;
      }
    });
    return _mapDataSelected;
  }

  ///for second tab
  List<charts.Series<TodoDetails, String>> _seriesPieDataToday;

  ///  var piedata = [
  ////    new Task('Work', 35.8, color),
  ////    new Task('Eat', 8.3, color),
  ////  ];
  List<TodoDetails> _pieDataToday;

  List<TodoDetails> _pieDataSelected = [];

  ///PieChart can only render a singleSeries, so we need to do this instead of getting _seriesPieData separately for Today and SelectedDay
  void _generateData(List<TodoDetails> myList) {
    //PieChart can only be rendered a singleSeries
    //_seriesPieData will be passed to the pieChart, when this function is called, it will be initialized and assign value.
    _seriesPieDataToday = List<charts.Series<TodoDetails, String>>();
//    if (myData != null) {
    _seriesPieDataToday.add(
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
        _seriesPieDataToday); //flutter: [Instance of 'Series<TodoDetails, String>']
    print(
        'tapped'); //when tap on a selectedDay, this function runs 4 times?? and in setState, ot runs once
//    }
  }

////    if (myData != null) {
//    _seriesPieDataSelected.add(
//      charts.Series(
//        domainFn: (TodoDetails task, _) => task.title,
//        measureFn: (TodoDetails task, _) => task.durationInHours,
////        colorFn: TodoDetails task, _) =>
////            charts.ColorUtil.fromDartColor(Color(int.parse(task.colorVal))),
//        id: 'tasks',
//        data: myData,
//        labelAccessorFn: (TodoDetails row, _) => "${row.durationInHours}",
//      ),
//    );
////    }
//  }

//  final domainValue = domainFn(datum, index);
//  final measureValue = measureFn(datum, index);
//  if (domainValue != null && measureValue != null) {
//  pointList.add(_getPoint(datum, domainValue, series, domainAxis,
//  measureValue, measureOffsetFn(datum, index), measureAxis));
//  }

  //must give an initial value because it directly used in Text
  double _todayDuration = 0;

  double _selectedDuration = 0;

  /// for second calendar
  /// groupby only one day, change to: map[date] = entry.todosDetails, instead of map[date] = entry;
  Map<DateTime, List<dynamic>> _groupEventsNew(List<TodoDuration> entries) {
    final allEntries = DailyTodosDetails.all(entries); //List<DailyTodosDetails>
    Map<DateTime, List<dynamic>> map = {}; //for calendar
    allEntries.forEach((entry) {
      DateTime date =
          DateTime(entry.date.year, entry.date.month, entry.date.day, 12);
//      if (map[date] == null) map[date] = [];
      map[date] = entry.todosDetails;
    });
    return map; //{2020-06-22 12:00:00.000: [List<TodosDetails>], 2020-06-23 12:00:00.000: [List<TodosDetails>]}
  }

  ///for today
  ///  //this function is called before SteamBuilder return
  //today total
  double _getTodayDuration(List<TodoDuration> entries) {
    final _todayEntries =
        DailyTodosDetails.getTodayEntries(entries); //List<DailyTodosDetails>
    double dailyDuration;
    _todayEntries.forEach((dailyTodosDetails) {
      dailyDuration = dailyTodosDetails.duration;
    });
    return dailyDuration;
  }

  List<TodoDetails> _getPieDataToday(List<TodoDuration> entries) {
    final _todayEntries =
        DailyTodosDetails.getTodayEntries(entries); //List<DailyTodosDetails>
    final List<TodoDetails> pieDataToday = [];
    _todayEntries.forEach((dailyTodosDetails) {
      for (TodoDetails todoDuration in dailyTodosDetails.todosDetails) {
        pieDataToday.add(TodoDetails(
          title: todoDuration.title,
          durationInHours: todoDuration.durationInHours,
        ));
      }
    });
    return pieDataToday;
  }

  ///for selectedDay
  ///  ///  //this function is called in setState
  //selectedDay total
  double _getSelectedDayDuration(DateTime date, List<TodoDuration> entries) {
    final _selectedDayEntries =
        DailyTodosDetails.getSelectedDayEntries(date, entries);
    double data;
    _selectedDayEntries.forEach((dailyTodosDetails) {
      data = dailyTodosDetails.duration;
    });
    return data;
  }

  List<TodoDetails> _getPieDataSelected(
      DateTime date, List<TodoDuration> entries) {
    final _selectedDayEntries = DailyTodosDetails.getSelectedDayEntries(
        date, entries); //List<DailyTodosDetails>
    final List<TodoDetails> pieDataSelected = [];
    _selectedDayEntries.forEach((dailyTodosDetails) {
      for (TodoDetails todoDuration in dailyTodosDetails.todosDetails) {
        pieDataSelected.add(TodoDetails(
          title: todoDuration.title,
          durationInHours: todoDuration.durationInHours,
        ));
      }
    });
    return pieDataSelected;
  }

  Widget _buildContents(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    //listen : false??
    final bloc = Provider.of<CalendarBloc>(context, listen: false);
    return StreamBuilder<List<TodoDuration>>(
        stream: bloc
            .allTodoDurationStream, //print: flutter: Instance of '_MapStream<List<TodoDuration>, dynamic>'
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<TodoDuration> entries = snapshot
                .data; //print('x: $entries'); //x: [Instance of 'TodoDuration', Instance of 'TodoDuration']
            if (entries.isNotEmpty) {
              final _eventsNew = _groupEventsNew(
                  entries); //{2020-06-22 12:00:00.000: [Instance of 'DailyTodosDetails'], 2020-06-23 12:00:00.000: [Instance of 'DailyTodosDetails']}
//                                  //print(_todayEntries);
//                                  _pieDataToday = _getPieDataToday(entries); //start []
              ///whe no data, the chart crashes
//                                  if (_pieDataToday.length > 0) {
              ///STEP 1:
//                                  print(
//                                      '_pieDataToday1: $_pieDataToday'); //_seriesPieDataToday: [Instance of 'Series<TodoDetails, String>']
//                                  ///STEP 2:
////                                  _generateData(_pieDataToday);
////                                  }
//                                  ///STEP 3:
//                                  print(
//                                      '_pieDataToday2: $_pieDataToday'); //_seriesPieDataToday: [Instance of 'Series<TodoDetails, String>']
              /// when tap on any date from ListView, the above 3 lines are executed 3 times, why??
              /// Then on chart page, when tap any date, we get the above line executed first, and then it executes the lines in setState, then the above three lines were executed 3 times again, wow, why??
              print('1: $_dataMapToday');
              _dataMapToday = _getDataMapToday(entries);
              print('2: $_dataMapToday');

              ///same problem when using pie_charts, the above line was executed three times when selecting a day
              _todayDuration = _getTodayDuration(entries);
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
//                                                  _calendarControllerNew.isToday(
//                                                          date) //if selected today, we only render _todayList, in this way, _todayList can be dynamically display when added new data in home screen.
//                                                      ? _pieDataSelected =
//                                                          [] //if it's empty, use today's list
//                                                      :
                          //when we tap on other days, why the screen still shows today's chart??
//                                                  _pieDataSelected =
//                                                      _getPieDataSelected(
//                                                          date, entries);
//                                                  print(
//                                                      _pieDataSelected); //[Instance of 'TodoDetails']
//                                                  _generateData(
//                                                      _pieDataSelected);
//                                                  print('selected');

                          /// when comes to TODO tab,
                          _dataMapSelected = _getDataMapSelected(date, entries);
                          print(
                              'selected: $_dataMapSelected'); //{explore chart: 1.0}

                          _selectedDuration =
                              _getSelectedDayDuration(date, entries);
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
//                                                    Stack(
//                                                      alignment:
//                                                          Alignment.center,
//                                                      children: <Widget>[
//                                                        Container(
//                                                          height:
//                                                              size.height / 3.5,
//                                                          child: MyPieChart(
//                                                              seriesPieData:
//                                                                  _seriesPieDataToday),
////                                                                    NewPieChart(dataMap: _dataMapToday),
//                                                        ), //only initialize in the generateData function
//                                                        Center(
//                                                          child: Column(
//                                                            children: <Widget>[
//                                                              Text('Total'),
//                                                              SizedBox(
//                                                                  height: 5),
//                                                              Text(Format.hours(
//                                                                  _todayDuration)),
//                                                            ],
//                                                          ),
//                                                        )
//                                                      ],
//                                                    )

                            _pieDataSelected.isEmpty
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: size.height / 3.5,
                                        child:

//                                                                MyPieChart(
//                                                                    seriesPieData:
//                                                                        _seriesPieDataToday),
                                            NewPieChart(dataMap: _dataMapToday),
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
//                              MyPieChart(
//                                                                      seriesPieData:
//                                                                          _seriesPieDataToday)

                                            NewPieChart(
                                                dataMap: _dataMapSelected),
                                      ),
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
                  EmptyContent(
                    title: 'Something went wrong',
                    message: 'Can\'t load items right now',
                  )
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });

//      StreamBuilder<List<EntriesListTileModel>>(
//      stream: bloc.entriesTileModelStream,
//      builder: (context, snapshot) {
//        return CustomizedContainer(
//          child: ListItemsBuilder<EntriesListTileModel>(
//            snapshot: snapshot,
//            itemBuilder: (context, model) => EntriesListTile(model: model),
//          ),
//        );
//      },
//    );
  }

  Widget _buildUserInfo(User user) {
    return Column(
      children: <Widget>[
        Avatar(
          photoUrl: user.photoUrl,
          radius: 50,
        ),
        SizedBox(height: 8),
        if (user.displayName != null)
          Text(
            user.displayName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        SizedBox(height: 8),
      ],
    );
  }
}
