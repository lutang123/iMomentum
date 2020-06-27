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
  //default as today, and if select other dates, _date will be _calendarController.selectedDay, and
  //then pass it to AddTodoScreen
  DateTime _date = DateTime.now();

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
//    print(_calendarController.selectedDay); //only when first come to this page, this is printed as null
    ///then we say if _calendarController.selectedDay == null, we use _todayList, but the problem is as far as we add/delete/update, this if statement no longer valid
//    print(_calendarController.isSelected(today)); //this line is wrong because The getter 'year' was called on null, we can only use this on onDaySelected
  }

  ///for listView
  //when i wrote _todayList = [], and before select any date, when doing anything on today's list, e.g. adding new or updating, today's list become empty
  List<TodoModel> _todayList;

  /// if not give an initial value, _selectedList.isEmpty will throw error
  List<TodoModel> _selectedList = [];

  ///for pie chart
  /// groupby only one day, change to: map[date] = entry.todosDetails, instead of map[date] = entry;
  Map<String, double> _dataMapToday;
  Map<String, double> _dataMapSelected =
      {}; //we initialize this because we have _dataMapSelected.isEmpty ? xxx : yyy

  // must give an initial value because it directly used in Text
  double _todayDuration = 0;
  double _selectedDuration = 0;

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
                ///do not assign an empty events map first
//                _events = _groupEvents(todos); //return a map
                final _events =
                    DailyTodosDetails.getEvents(todos); //return a map
//            print(_events); // {2020-06-23 12:00:00.000: [id: 2020-06-23T09:45:13.260781, title: test1, id: 2020-06-23T09:46:32.982775, title: test 2}
                _todayList = DailyTodosDetails.getTodosGroupByData(
                    DateTime.now(), todos);
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
                                  final _eventsNew =
                                      DailyTodosDetails.getEventsNew(entries);
//                                  print(_eventsNew); //{2020-06-22 12:00:00.000: [Instance of 'TodoDetails', Instance of 'TodoDetails'], 2020-06-23 12:00:00.000: [Instance of 'TodosDetails']}
//                                  print('second SteamBuilder');
                                  /// it seems every function in this level were execute three times everytime I tap on the screen
                                  ///try with pie_charts
//                                  int('1: $_dataMapToday');
                                  _dataMapToday =
                                      DailyTodosDetails.getDataMapGroupByDate(
                                          DateTime.now(), entries);
//                                  print('2: $_dataMapToday');
                                  ///same problem when using pie_charts, the above line was executed three times when selecting a day
                                  _todayDuration =
                                      DailyTodosDetails.getDailyTotalDuration(
                                          DateTime.now(), entries);
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
                                              decoration: KBoxDecoration,
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
                                                            DailyTodosDetails
                                                                .getTodosGroupByData(
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
                                                          _selectedList.isEmpty

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
                                                decoration: KBoxDecoration,
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
                                                              DailyTodosDetails
                                                                  .getDataMapGroupByDate(
                                                                      date,
                                                                      entries);
//                                                  print('selected: $_dataMapSelected'); //{explore chart: 1.0}

                                                      _selectedDuration =
                                                          DailyTodosDetails
                                                              .getDailyTotalDuration(
                                                                  date,
                                                                  entries);
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
          final newList = DailyTodosDetails.getTodosGroupByData(
              _calendarController.selectedDay, todos);

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
        final newList = DailyTodosDetails.getTodosGroupByData(
            _calendarController.selectedDay, todos);
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
