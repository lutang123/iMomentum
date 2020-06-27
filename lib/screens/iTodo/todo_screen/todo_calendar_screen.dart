import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/common_widgets/customized_bottom_sheet.dart';
import 'package:iMomentum/app/common_widgets/linear_gradient_container.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/todo_model.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/common_widgets/my_todo_list_tile.dart';
import 'package:iMomentum/screens/entries/calendar_bloc.dart';
import 'package:iMomentum/screens/entries/daily_todos_details.dart';
import 'package:iMomentum/screens/entries/entry_job.dart';
import 'package:iMomentum/screens/iTodo/todo_screen/new_pie_chart.dart';
import 'package:iMomentum/screens/jobs/empty_content.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'add_todo_screen.dart';
import 'my_calendar.dart';
import 'package:iMomentum/app/common_widgets/format.dart';

//We are not using FutureBuilder as it creates problem by restarting the
// asynchronous task every time the widget rebuild.

//https://image-color-picker.com/

class TodoScreen extends StatefulWidget {
  //from tab page
  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Provider<CalendarBloc>(
      create: (_) => CalendarBloc(database: database),
      child: TodoScreen(),
    );
  }

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> with TickerProviderStateMixin {
  CalendarController _calendarController;
  CalendarController _calendarControllerNew;
  AnimationController _animationController;
//  Map<DateTime, List<dynamic>> _events = {}; //when I do this, _todayList not updating dynamically when adding new data from home screen, why?

  //default as today, and if select other dates, _date will be selectedDay, and
  //then pass it to AddTodoScreen
  DateTime _date = DateTime.now();

  final DateTime today = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 12);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
    _calendarController = CalendarController();
    _calendarControllerNew = CalendarController();
//    print(_calendarController
//        .selectedDay); //only when first come to this page, this is printed as null
    ///then we say if _calendarController.selectedDay == null, we use _todayList, but the problem is as far as we add/delete/update, this line is no longer executed
//    print(_calendarController.isSelected(today)); //this line is wrong because The getter 'year' was called on null.
  }

  ///notes for pie_charts
  Map<String, double> _dataMapToday;
  Map<String, double> _dataMapSelected = {};
  // {Flutter: 5.0, React: 3.0, Xamarin: 2.0, Ionic: 2.0}
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

  // {Flutter: 5.0, React: 3.0, Xamarin: 2.0, Ionic: 2.0}
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

  // must give an initial value because it directly used in Text
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

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final bloc = Provider.of<CalendarBloc>(context, listen: false);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.network(Constants.homePageImage, fit: BoxFit.cover),
        ContainerLinearGradient(),
        StreamBuilder<List<TodoModel>>(
          stream: database
              .todosStream(), // print(database.todosStream());//Instance of '_MapStream<QuerySnapshot, List<TodoModel>>'
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<TodoModel> todos = snapshot.data;
              if (todos.isNotEmpty) {
                print('first SteamBuilder');

                ///do not assign an empty events map first
//                _events = _groupEvents(todos); //return a map
                final _events = _groupEvents(todos); //return a map
//            print(_events); // {2020-06-23 12:00:00.000: [id: 2020-06-23T09:45:13.260781, title: test1, id: 2020-06-23T09:46:32.982775, title: test 2}
                _todayList = _getTodayTodos(todos);
//                print(_todayList); //[id: 2020-06-23T09:45:13.260781, title: test1, id: 2020-06-23T09:46:32.982775, title: test 2]
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    DefaultTabController(
                      length: 2,
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(
                          elevation: 0,
                          backgroundColor: Colors.black12,
//                          title: Text('Todo',
//                              style: TextStyle(
//                                fontWeight: FontWeight.w500,
//                                fontSize: 30.0,
//                              )),
                          bottom: TabBar(
                            indicatorColor: Colors.white70,
                            tabs: [
                              Tab(
                                icon: Icon(FontAwesomeIcons.list),
                              ),
                              Tab(icon: Icon(FontAwesomeIcons.chartPie))
                            ],
                          ),
                        ),
                        body: StreamBuilder<List<TodoDuration>>(
                            stream: bloc
                                .allTodoDurationStream, //print: flutter: Instance of '_MapStream<List<TodoDuration>, dynamic>'
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final List<TodoDuration> entries = snapshot
                                    .data; //print('x: $entries'); //x: [Instance of 'TodoDuration', Instance of 'TodoDuration']
                                if (entries.isNotEmpty) {
                                  final _eventsNew = _groupEventsNew(entries);
//                                  print(_eventsNew); //{2020-06-22 12:00:00.000: [Instance of 'TodoDetails', Instance of 'TodoDetails'], 2020-06-23 12:00:00.000: [Instance of 'TodosDetails']}
                                  print('second SteamBuilder');

                                  /// it seems every function in this level were execute three times everytime I tap on the screen
                                  ///try with pie_charts
//                                  int('1: $_dataMapToday');
                                  _dataMapToday = _getDataMapToday(entries);
//                                  print('2: $_dataMapToday');
                                  ///same problem when using pie_charts, the above line was executed three times when selecting a day
                                  _todayDuration = _getTodayDuration(entries);
//                                  print(_todayDuration); // if no data, it will show null, not 0
                                  return TabBarView(
                                    children: <Widget>[
                                      //  StreamController<...> _controller = StreamController<...>.broadcast();??
                                      ///moved StreamBuilder up above TabBarView and then it works
                                      Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black26,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0),
                                                ),
                                              ),
                                              child: MyCalendar(
                                                events: _events,
                                                calendarController:
                                                    _calendarController,
                                                onDaySelected: (date, _) {
//                                                print(date); //flutter: 2020-06-25 12:00:00.000Z
                                                  setState(() {
                                                    ///so just mask empty list as today??
                                                    _calendarController.isToday(
                                                            date) //if selected today, we only render _todayList, in this way, _todayList can be dynamically display when added new data in home screen.
                                                        ? _selectedList =
                                                            [] //if it's empty, use today's list
                                                        /// why I can not assign today's list to
                                                        /// -selectedList?
//                                                          _todayList

                                                        : _selectedList =
                                                            _getSelectedDayTodos(
                                                                date,
                                                                todos); //selectedDay is not null, then we use _selectedList
                                                    ///this very important, otherwise can't update _selectedList
                                                    _date = date; //for update
                                                  });
                                                },
                                                onDayLongPressed: (date, _) {
                                                  _date = date;
                                                  _add(database, todos);
                                                },
                                                animationController:
                                                    _animationController,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: CustomizedContainer(
                                              child: Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Text(
                                                      _selectedList.isEmpty
                                                          ? 'Today'
                                                          : Format.date(
                                                              _calendarController
                                                                  .selectedDay),
                                                      style: GoogleFonts
                                                          .varelaRound(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 25.0,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(height: 3.0),
                                                  Expanded(
                                                    child: Container(
                                                      child:

                                                          ///problem is if select a day that does not have data, it always shows today, or when we deleted all the data on selected day, the list will display today's list.
                                                          //at beginning, .selectedDay is null, and _selectedList is empty, so we get _todayList
                                                          ///if using the following line, somehow
                                                          _calendarController
                                                                          .selectedDay ==
                                                                      null ||

                                                                  ///not really nessary for this ==null, because this only excecute once
                                                                  _selectedList
                                                                      .isEmpty

                                                              ///but once we tap on empty list, it shows today list, it's a problem when use delete all items on a selectedDay, once the list is empty, it shows today's list, how to change??
                                                              ? buildListView(
                                                                  database,
                                                                  todos,
                                                                  _todayList) //this should always dynamically updated when adding new data in home screen

                                                              //then we start to select a day, and .selectedDay is not null, then we use _selectedList, it does not matter if it's empty or not.
                                                              // but if .selectedDay is today, we can not assign _todayList to _selectedList and I don't know why,
                                                              // but then it works when I make _selectedList = [] if we selected today, is not Empty,

                                                              : buildListView(
                                                                  database,
                                                                  todos,
                                                                  _selectedList), //but once we select day and the selectedDay is today, how to make this list also dynamically updates?
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: Kdecoration,
                                                child: MyCalendar(
                                                  events: _eventsNew,
                                                  calendarController:
                                                      _calendarControllerNew,
                                                  onDaySelected: (date, _) {
                                                    setState(() {
                                                      /// try with pie_Charts
                                                      _calendarControllerNew
                                                              .isToday(
                                                                  date) //if selected today, we only render _todayList, in this way, _todayList can be dynamically display when added new data in home screen.
                                                          ? _dataMapSelected =
                                                              {}
                                                          : _dataMapSelected =
                                                              _getDataMapSelected(
                                                                  date,
                                                                  entries);
//                                                  print('selected: $_dataMapSelected'); //{explore chart: 1.0}

                                                      _selectedDuration =
                                                          _getSelectedDayDuration(
                                                              date, entries);
                                                    });
                                                  },
                                                  onDayLongPressed: (date, _) {
                                                    _date = date;
                                                    _add(database, todos);
                                                  },
                                                  animationController:
                                                      _animationController,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: CustomizedContainer(
                                                child: Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Text(
                                                        _dataMapSelected.isEmpty
                                                            ? 'Focused Time on Today'
                                                            : 'Focused Time on ${Format.date(_calendarControllerNew.selectedDay)}',
                                                        style: TextStyle(
//                                                          fontWeight:
//                                                              FontWeight.w600,
                                                          fontSize: 25.0,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    SizedBox(height: 3.0),
                                                    Text(
                                                      _dataMapSelected.isEmpty
                                                          ? 'Total ${Format.hours(_todayDuration)}'
                                                          : 'Total ${Format.hours(_selectedDuration)}',
                                                      style: GoogleFonts
                                                          .varelaRound(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 20.0,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(height: 10.0),

                                                    /// try with pie_chart flutter
                                                    _dataMapSelected.isEmpty
                                                        ? NewPieChart(
                                                            dataMap:
                                                                _dataMapToday)
                                                        : NewPieChart(
                                                            dataMap:
                                                                _dataMapSelected),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                } else {
                                  return Center(
                                      child: Text('Add new TODO here'));
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
                            }),
                      ),
                    ),
//                    Stack(
//                      overflow: Overflow.visible,
//                      alignment: FractionalOffset(0.95, .87),
//                      children: [
//                        Padding(
//                          padding: const EdgeInsets.only(bottom: 12.0),
//                          child: FloatingActionButton(
//                            onPressed: () => _add(database, todos),
//                            tooltip: 'Add Note',
//                            shape: CircleBorder(
//                                side: BorderSide(
//                                    color: Colors.white, width: 2.0)),
//                            child:
//                                Icon(Icons.add, size: 30, color: Colors.white),
//                            backgroundColor: Colors.transparent,
//                          ),
//                        ),
//                      ],
//                    ),
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
          },
        ),
      ],
    );
  }

  ListView buildListView(
      Database database, List<TodoModel> todos, List<TodoModel> _selectedList) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount:
            _selectedList.length, //The getter 'length' was called on null.
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.black54,
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Text(
                      'Delete',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              )),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, _selectedList[index]),
            child: TodoListTile(
              todo: _selectedList[index],
              onTap: () => _onTap(database, todos, _selectedList[index]),
              onChangedCheckbox: (newValue) =>
                  _onChangedCheckbox(newValue, context, _selectedList[index]),
            ),
          );
        });
  }

  ///for first tab
  //when i wrote _todayList = [], and before select any date, when doing anything on today's list, e.g. adding new or updating, today's list become empty
  List<TodoModel> _todayList;

  /// if not give an initial value, _selectedList.isEmpty will throw error
  List<TodoModel> _selectedList = [];

  /// for first calendar
  Map<DateTime, List<dynamic>> _groupEvents(List<TodoModel> todos) {
    Map<DateTime, List<dynamic>> map = {}; //for first calendar
    todos.forEach((todo) {
      DateTime date =
          DateTime(todo.date.year, todo.date.month, todo.date.day, 12);
      if (map[date] == null) map[date] = [];
      map[date].add(todo);
    });
    return map;
  }

  List<TodoModel> _getTodayTodos(List<TodoModel> todos) {
//    _todayList = [];
    List<TodoModel> list = [];
    todos.forEach((todo) {
      DateTime todayNew = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      DateTime date = DateTime(todo.date.year, todo.date.month, todo.date.day);
      if (date == todayNew) {
        list.add(todo);
      }
    });
    return list;
  }

  List<TodoModel> _getSelectedDayTodos(DateTime date, List<TodoModel> todos) {
    List<TodoModel> list = [];
    todos.forEach((todo) {
      final formattedDate = DateTime(date.year, date.month, date.day);
      DateTime todoDate =
          DateTime(todo.date.year, todo.date.month, todo.date.day);
      if (todoDate == formattedDate) {
        list.add(todo);
      }
    });
    _date = date;
    return list;
  }

  Future<void> _delete(BuildContext context, TodoModel todo) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteTodo(todo);
      //PlatformException is from import 'package:flutter/services.dart';
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }

    ///    //to make selectedList updates at the same time
    setState(() {
      _selectedList.remove(todo);
    });
  }

  Future<void> _onChangedCheckbox(
      newValue, BuildContext context, TodoModel todo) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      todo.isDone = !todo.isDone;
      await database.updateTodo(todo);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  /// add new & at the same time update _selectedList
  Future<void> _add(Database database, List<TodoModel> todos) async {
    var _typedTitle = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddTodoScreen(
        database: database,
//        onTap: _handleDatePicker,
        pickedDate: _date,
      ),
    );

    if (_typedTitle != null) {
      try {
        final newTodo = TodoModel(
            id: documentIdFromCurrentDate(),
            title: _typedTitle,
            date: _date,
            isDone: false);
        //add newTodo to database
        await database.setTodo(newTodo);

        print(_calendarController.selectedDay); //this never be executed;

        ///    //to make selectedList updates at the same time
//        print(_calendarController.selectedDay);
        //2020-06-24 12:00:00.000Z

        /// but new problem: e.g. if we select June 1st, but add item in June 2nd,
        /// then we add newTodo to selectedList!!! how to solve this? add this if statement
        if (_calendarController.selectedDay == _date) {
          final newList =
              _getSelectedDayTodos(_calendarController.selectedDay, todos);

//        print(newList); // a list, not showing the newly added one
//        print(_groupEvents(todos)); //a map, not showing the newly added one
//        print(_groupEvents(todos)[_calendarController.selectedDay]); //null

          setState(() {
            _selectedList = newList..add(newTodo);
          });
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  /// update & at the same time update _selectedList
  void _onTap(Database database, List<TodoModel> todos, TodoModel todo) async {
    var _typedTitle = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddTodoScreen(
        database: database,
        todo: todo,
//        onTap: _handleDatePicker,
        pickedDate: _date,
      ),
    );

    if (_typedTitle != null) {
      try {
        //we get the id from job in the firebase, if the job.id is null,
        //we create a new one, otherwise we use the existing job.id
        final id = todo?.id ?? documentIdFromCurrentDate();
        final isDone = todo?.isDone ?? false;

        ///first we find this specific Todo item that we want to update
        final newTodo =
            TodoModel(id: id, title: _typedTitle, date: _date, isDone: isDone);
        //add newTodo to database
        await database.setTodo(newTodo);

        ///when we tap, get a new list from _calendarController.selectedDay first
        ///but this should be the same as _selectedList
        final newList =
            _getSelectedDayTodos(_calendarController.selectedDay, todos);
        //todo: use original selectedList works but get white color error: Unhandled Exception: RangeError (index): Invalid value: Valid value range is empty: -1
        ///this two are exactly the same, no need to create newList
//        final newList = selectedList; ///not use this line
//        print('newList: $newList'); //flutter: [id: 2020-06-20T15:22:51.572224, title: hello]
//        print('_selectedList: $_selectedList');
//        print(newTodo);
        ///anyway, then we find it's index of the to-be-updated item
        ///e.g list index is [0,1,2,3]
        ///    list is       [a,b,c,d]
        ///    now we find is this newList/_selectedList, the item we want to update is in index 2
        final index = newList.indexWhere((element) => element.id == newTodo.id);

        ///then we replace this item newList[2] = e, now newList is [a,b,e,d], and of course we need to setState and update our _selectedList
        newList[index] = newTodo;
        setState(() {
          _selectedList = newList;
        });
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
    _calendarControllerNew.dispose();
    _animationController.dispose();
  }
}

///notes for trying Reorderable:
//  List<TodoModel> _newOrderedList = [];
//
//  void onReorder(int oldIndex, int newIndex) {
//    if (newIndex > oldIndex) {
//      newIndex -= 1;
//    }
//    setState(() {
//      TodoModel todo = _todayList[oldIndex];
//      _todayList.removeAt(oldIndex);
//      _todayList.insert(newIndex, todo);
//      _newOrderedList = _todayList;
//    });
//  }
//
//  List<Widget> getListItems() => _newOrderedList.isEmpty
//      ? _todayList
//          .asMap()
//          .map((i, item) => MapEntry(i, buildTenableListTile(item, i)))
//          .values
//          .toList()
//      : _newOrderedList
//          .asMap()
//          .map((i, item) => MapEntry(i, buildTenableListTile(item, i)))
//          .values
//          .toList();
//
//  Widget buildTenableListTile(TodoModel todo, int index) {
//    return MyTodoListTile(
//      key: ValueKey(todo),
//      todo: todo,
//      leading: Text("#${index + 1}"),
//    );
//  }
//
//  void onReorderSelected(int oldIndex, int newIndex) {
//    if (newIndex > oldIndex) {
//      newIndex -= 1;
//    }
//    setState(() {
//      TodoModel todo = _selectedList[oldIndex];
//      _selectedList.removeAt(oldIndex);
//      _selectedList.insert(newIndex, todo);
//    });
//  }
//
//  List<Widget> getListItemsSelected() => _selectedList
//      .asMap()
//      .map((i, item) => MapEntry(i, buildTenableListTileSelected(item, i)))
//      .values
//      .toList();
//
//  Widget buildTenableListTileSelected(TodoModel todo, int index) {
//    return MyTodoListTile(
//      key: ValueKey(todo),
//      todo: todo,
//      leading: Text("#${index + 1}"),
//    );
//  }

///try with charts_flutter
//                                                    _pieDataSelected.isEmpty
//                                                        ? Stack(
//                                                            alignment: Alignment
//                                                                .center,
//                                                            children: <Widget>[
//                                                              Container(
//                                                                height:
//                                                                    size.height /
//                                                                        3.5,
//                                                                child: MyPieChart(
//                                                                    seriesPieData:
//                                                                        _seriesPieData),
//                                                              ), //only initialize in the generateData function
//                                                              Center(
//                                                                child: Column(
//                                                                  children: <
//                                                                      Widget>[
//                                                                    Text(
//                                                                        'Total'),
//                                                                    SizedBox(
//                                                                        height:
//                                                                            5),
//                                                                    Text(Format
//                                                                        .hours(
//                                                                            _todayDuration)),
//                                                                  ],
//                                                                ),
//                                                              )
//                                                            ],
//                                                          )
//                                                        :
//
//                                                        ///this not execute, not know why? no error thrown
//                                                        Stack(
//                                                            alignment: Alignment
//                                                                .center,
//                                                            children: <Widget>[
//                                                              Container(
//                                                                  height:
//                                                                      size.height /
//                                                                          3.5,
//                                                                  child:
//
//                                                                      ///removed 'No data yet', but screen only show today's chart
//                                                                      MyPieChart(
//                                                                          seriesPieData:
//                                                                              _seriesPieDataSelected)),
//                                                              Center(
//                                                                child: Column(
//                                                                  children: <
//                                                                      Widget>[
//                                                                    Text(
//                                                                        'Total'),
//                                                                    SizedBox(
//                                                                        height:
//                                                                            5),
//                                                                    Text(Format
//                                                                        .hours(
//                                                                            _selectedDuration)),
//                                                                  ],
//                                                                ),
//                                                              )
//                                                            ],
//                                                          ),
///in setState
////                                                  ///try with charts_flutter
//////                                                  _calendarControllerNew.isToday(
//////                                                          date) //if selected today, we only render _todayList, in this way, _todayList can be dynamically display when added new data in home screen.
//////                                                      ? _pieDataSelected =
//////                                                          [] //if it's empty, use today's list
//////                                                      :
////
////                                                  /// when we tap on other days, why the screen still shows today's chart??
//                                                  _pieDataSelected =
//                                                      _getPieDataSelected(
//                                                          date, entries);
//                                                  print(_pieDataSelected);
//
//                                                  /// this line not excueted?
//                                                  _seriesPieDataSelected =
//                                                      _generateDataSelected(
//                                                          _pieDataSelected);
//                                                  print(
//                                                      _seriesPieDataSelected); //[Instance of 'Series<TodoDetails, String>']
////                                                  print('selected');
///for today
//                                  _pieDataToday = _getPieDataToday(entries); //returns a list
//                                  ///whe no data, the chart crashes
////                                  if (_pieDataToday.length > 0) {
//                                  ///STEP 1:
////                                  print(
////                                      '_pieDataToday1: $_pieDataToday'); //_seriesPieDataToday: [Instance of 'Series<TodoDetails, String>']
////                                  ///STEP 2:
//                                  _seriesPieData = _generateData(_pieDataToday);
//////                                  }
////                                  ///STEP 3:
//                                  print(
//                                      '_pieDataToday2: $_pieDataToday'); //_seriesPieDataToday: [Instance of 'Series<TodoDetails, String>']
/// when tap on any date from ListView, the above 3 lines are executed 3 times, why??
/// Then on chart page, when tap any date, we get the above line executed first, and then it executes the lines in setState, then the above three lines were executed 3 times again, wow, why??
///notes on calendar date
//                                                  print(_calendarController
//                                                      .isSelected(
//                                                          today)); //before click to select, this is not printed.
//                                                  print(_calendarController
//                                                      .isToday(date));
//                                                  print(_calendarController
//                                                      .selectedDay); //flutter: 2020-06-26 12:00:00.000Z
//                                                  print(
//                                                      today); //flutter: 2020-06-25 12:00:00.000
//                                                  print(DateTime
//                                                      .now()); //flutter: 2020-06-25 23:45:36.966095
//                                                  final formatedToday = DateFormat(
//                                                          "yyyy-MM-dd HH:mm:ss.000'Z'")
//                                                      .format(
//                                                          today); //flutter: 2020-06-26 12:00:00.000Z
//                                                  print(_calendarController
//                                                          .selectedDay ==
//                                                      formatedToday);
///functions for charts_flutter
//for second tab
//List<charts.Series<TodoDetails, String>> _seriesPieData;
//List<charts.Series<TodoDetails, String>> _seriesPieDataSelected;
//
/////  var piedata = [
//////    new Task('Work', 35.8, color),
//////    new Task('Eat', 8.3, color),
//////  ];
//List<TodoDetails> _pieDataToday;
//List<TodoDetails> _pieDataSelected = [];
//
////  ///PieChart can only render a singleSeries, so we need to do this instead of getting _seriesPieData separately for Today and SelectedDay
////  void _generateData(List<TodoDetails> myList) {
////    //PieChart can only be rendered a singleSeries
////    //_seriesPieData will be passed to the pieChart, when this function is called, it will be initialized and assign value.
////    _seriesPieData = List<charts.Series<TodoDetails, String>>();
//////    if (myData != null) {
////    _seriesPieData.add(
////      charts.Series(
////        domainFn: (TodoDetails task, _) => task.title,
////        measureFn: (TodoDetails task, _) => task.durationInHours,
//////        colorFn: TodoDetails task, _) =>
//////            charts.ColorUtil.fromDartColor(Color(int.parse(task.colorVal))),
////        id: 'tasks',
////        data: myList,
////        labelAccessorFn: (TodoDetails row, _) => "${row.durationInHours}",
////      ),
////    );
////    print(
////        _seriesPieData); //flutter: [Instance of 'Series<TodoDetails, String>']
////    print(
////        'tapped'); //when tap on a selectedDay, this function runs 4 times?? and in setState, ot runs once
//////    }
////  }
//
/////PieChart can only render a singleSeries, so we need to do this instead of getting _seriesPieData separately for Today and SelectedDay
//_generateData(List<TodoDetails> myList) {
//  //PieChart can only be rendered a singleSeries
//  //_seriesPieData will be passed to the pieChart, when this function is called, it will be initialized and assign value.
//  final _x = List<charts.Series<TodoDetails, String>>();
////    if (myData != null) {
//  _x.add(
//    charts.Series(
//      domainFn: (TodoDetails task, _) => task.title,
//      measureFn: (TodoDetails task, _) => task.durationInHours,
////        colorFn: TodoDetails task, _) =>
////            charts.ColorUtil.fromDartColor(Color(int.parse(task.colorVal))),
//      id: 'tasks',
//      data: myList,
//      labelAccessorFn: (TodoDetails row, _) => "${row.durationInHours}",
//    ),
//  );
//
//  return _x;
//  //when tap on a selectedDay, this function runs 4 times?? and in setState, ot runs once
//}
//
//_generateDataSelected(List<TodoDetails> myData) {
//  //PieChart can only be rendered a singleSeries
//  //_seriesPieData will be passed to the pieChart, when this function is called, it will be initialized and assign value.
//  final _y = List<charts.Series<TodoDetails, String>>();
////    if (myData != null) {
//  _y.add(
//    charts.Series(
//      domainFn: (TodoDetails task, _) => task.title,
//      measureFn: (TodoDetails task, _) => task.durationInHours,
////        colorFn: TodoDetails task, _) =>
////            charts.ColorUtil.fromDartColor(Color(int.parse(task.colorVal))),
//      id: 'tasks',
//      data: myData,
//      labelAccessorFn: (TodoDetails row, _) => "${row.durationInHours}",
//    ),
//  );
//  return _y;
////    }
//}
////today pie data
//List<TodoDetails> _getPieDataToday(List<TodoDuration> entries) {
//  final _todayEntries =
//  DailyTodosDetails.getTodayEntries(entries); //List<DailyTodosDetails>
//  final List<TodoDetails> pieDataToday = [];
//  _todayEntries.forEach((dailyTodosDetails) {
//    for (TodoDetails todoDuration in dailyTodosDetails.todosDetails) {
//      pieDataToday.add(TodoDetails(
//        title: todoDuration.title,
//        durationInHours: todoDuration.durationInHours,
//      ));
//    }
//  });
//  return pieDataToday;
//}
////selectedDay pie data
//List<TodoDetails> _getPieDataSelected(
//    DateTime date, List<TodoDuration> entries) {
//  final _selectedDayEntries = DailyTodosDetails.getSelectedDayEntries(
//      date, entries); //List<DailyTodosDetails>
//  final List<TodoDetails> pieDataSelected = [];
//  _selectedDayEntries.forEach((dailyTodosDetails) {
//    for (TodoDetails todoDuration in dailyTodosDetails.todosDetails) {
//      pieDataSelected.add(TodoDetails(
//        title: todoDuration.title,
//        durationInHours: todoDuration.durationInHours,
//      ));
//    }
//  });
//  return pieDataSelected;
//}
