import 'dart:async';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_fab.dart';
import 'package:iMomentum/app/common_widgets/my_list_tile.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/services/calendar_bloc.dart';
import 'package:iMomentum/app/services/daily_todos_details.dart';
import 'package:iMomentum/screens/todo_screen/new_pie_chart.dart';
import 'package:iMomentum/app/common_widgets/empty_content.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'add_todo_screen.dart';
import 'my_calendar.dart';
import 'package:iMomentum/app/utils/format.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'dart:math' as math;

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
  bool _addButtonVisible = true;
  bool _calendarVisible = true;
  ScrollController _hideButtonController;

  //default as today, and if select other dates, _date will be _calendarController.selectedDay, and
  //then pass it to AddTodoScreen
  DateTime _taskDate = DateTime.now();
  //this is for empty content in task list
  Map<DateTime, List<dynamic>> _eventNoData = {};

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
    ///then we say if _calendarController.selectedDay == null, we use _todayList, but the problem is as far as we add/delete/update, this if statement no longer valid
//    print(_calendarController.isSelected(today)); //this line is wrong because The getter 'year' was called on null, we can only use this in onDaySelected
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_addButtonVisible == true && _calendarVisible == true) {
          setState(() {
            _addButtonVisible = false;
            _calendarVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_addButtonVisible == false && _calendarVisible == false) {
            setState(() {
              _addButtonVisible = true;
              _calendarVisible = true;
            });
          }
        }
      }
    });
  }

  // https://source.unsplash.com/daily?nature
  //'https://source.unsplash.com/random?nature'
  //https://source.unsplash.com/random?nature/$counter
  int counter = 0;
  void _onDoubleTap() {
    setState(() {
      ImageUrl.randomImageUrl =
          'https://source.unsplash.com/random?nature/$counter';
      counter++;
    });
  }

  ///for listView
  ///
  //we assign value in StreamBuilder
  List<Todo> _todayList;
  List<Todo> _todayNotDoneList;

  /// if not give an initial value, _selectedList.isEmpty will throw error
  List<Todo> _selectedList = [];
  List<Todo> _selectedNotDoneList = [];

  void _onDaySelected(DateTime date, List<Todo> todos) {
//    print('_onDaySelected: $date'); //flutter: 2020-06-25 12:00:00.000Z
    setState(() {
      //if selected today, we only render _todayList, in this way, _todayList can be dynamically display when added new data in home screen.
      ///this main problem is if selectedDay is empty, it always shows today's list
      _calendarController.isToday(date)
          ? _selectedList =
              _todayList // but if it's empty, it also uses today's list
          : _selectedList = DailyTodosDetails.getTodosGroupByData(date, todos);

      _calendarController.isToday(date)
          ? _selectedNotDoneList =
              _todayNotDoneList // but if it's empty, it also uses today's list
          : _selectedNotDoneList =
              DailyTodosDetails.getNotDoneTodosGroupByData(date, todos);

      ///this very important, otherwise can't update _selectedList
      //_taskDate initial value is today
      _taskDate = date; //for update task date
    });
  }

  ///for pie chart
  ///
  /// groupby only one day, change to: map[date] = entry.todosDetails,
  /// instead of map[date] = entry;
  // this is map because this is the value used in pie chart
  Map<String, double> _dataMapToday; //again we assign value in SteamBuilder
  Map<String, double> _dataMapSelected =
      {}; // again we gave an empty value to this because we have _dataMapSelected.isEmpty ?

  // must give an initial value because it directly used in Text
  double _todayDuration = 0; //this is just inital value
  double _selectedDuration = 0;

  void _onDaySelectedNew(DateTime date, List<TodoDuration> entries) {
    setState(() {
      /// try with pie_Charts
      _calendarControllerNew.isToday(
              date) //if selected today, we only render _todayList, in this way, _todayList can be dynamically display when added new data in home screen.
          ? _dataMapSelected = _dataMapToday
          : _dataMapSelected =
              DailyTodosDetails.getDataMapGroupByDate(date, entries);
      _selectedDuration =
          DailyTodosDetails.getDailyTotalDuration(date, entries);
    });
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final bloc = Provider.of<CalendarBloc>(context, listen: false);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final randomNotifier = Provider.of<RandomNotifier>(context);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context);

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        BuildPhotoView(
          imageUrl:
              _randomOn ? ImageUrl.randomImageUrl : imageNotifier.getImage(),
        ),
        ContainerLinearGradient(),
        GestureDetector(
          onDoubleTap: _onDoubleTap,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              top: false, // this is to make top bar color cover all
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      child: Container(
                          color:
                              _darkTheme ? darkThemeAppBar : lightThemeSurface),
                    ),
                    SizedBox(
                      height: 50,
                      child: Container(
                        color: _darkTheme ? darkThemeAppBar : lightThemeSurface,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TabBar(
                            indicatorColor:
                                _darkTheme ? darkThemeButton : lightThemeButton,
                            tabs: [
                              Tab(
                                icon: Icon(
                                  FontAwesomeIcons.list,
                                  size: 25,
                                  color: _darkTheme
                                      ? darkThemeButton
                                      : lightThemeButton,
                                ),
                              ),
                              Tab(
                                  icon: Icon(
                                FontAwesomeIcons.chartPie,
                                size: 25,
                                color: _darkTheme
                                    ? darkThemeButton
                                    : lightThemeButton,
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    // two SteamBuilder nested together, The returned value is
                    // TabBarView, and this must be below StreamBuilder
                    Expanded(
                      ///StreamBuilder must wrap with Scaffold first, otherwise the empty list message will look terrible
                      child: StreamBuilder<List<Todo>>(
                        stream: database
                            .todosStream(), // print(database.todosStream());//Instance of '_MapStream<QuerySnapshot, List<TodoModel>>'
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final List<Todo> todos = snapshot.data;
//                            // ignore: missing_return
//                            todos.sort((lhs, rhs) {
//                              if ((lhs.category != null) &&
//                                  (rhs.category != null)) {
//                                return rhs.category.compareTo(lhs.category);
//                              }
//                            });
                            if (todos.isNotEmpty) {
                              //TODO
                              final _events = //do not assign an empty events map first, why?/
                                  DailyTodosDetails.getEvents(
                                      todos); //return a map to use on calender
                              final _notDoneEvents =
                                  DailyTodosDetails.getNotDoneEvents(todos);

                              ///get today's list, (unfortunately, it's designed to show on every empty day too)
                              _todayList =
                                  DailyTodosDetails.getTodosGroupByData(
                                      DateTime.now(), todos);

                              _todayNotDoneList =
                                  DailyTodosDetails.getNotDoneTodosGroupByData(
                                      DateTime.now(), todos);

                              return StreamBuilder<List<TodoDuration>>(
                                  stream: bloc
                                      .allTodoDurationStream, //print: flutter: Instance of '_MapStream<List<TodoDuration>, dynamic>'
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final List<TodoDuration> entries = snapshot
                                          .data; //print('x: $entries'); //x: [Instance of 'TodoDuration', Instance of 'TodoDuration']
                                      if (entries.isNotEmpty) {
                                        ///for second calendar
                                        final _eventsNew =
                                            DailyTodosDetails.getEventsNew(
                                                entries);

                                        /// for the pie chart /// it seems every function in this level were execute three times every time I tap on the screen, o
                                        _dataMapToday = DailyTodosDetails
                                            .getDataMapGroupByDate(
                                                DateTime.now(), entries);
                                        _todayDuration = DailyTodosDetails
                                            .getDailyTotalDuration(
                                                DateTime.now(), entries);
//                                            print(_todayDuration); // if no data, it will show null, not 0
                                        ///moved StreamBuilder up above TabBarView, otherwise we got error: Bad state: Stream has already been listened to
                                        return TabBarView(
                                          children: <Widget>[
                                            firstTab(database, todos, _events,
                                                _notDoneEvents),
                                            secondTab(
                                                database, entries, _eventsNew),
                                          ],
                                        );
                                      } else {
                                        ///the problem is if no data on pie chart, it always shows nothing on task list,
                                        ///that's why if no data on pie chart, we return the whole first tab column
                                        return TabBarView(
                                          children: <Widget>[
                                            firstTab(database, todos, _events,
                                                _notDoneEvents),
                                            secondTabNoDataContent(
                                                database, _eventNoData),
                                          ],
                                        );
                                      }
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(snapshot.error.toString()),
                                            EmptyMessage(
                                              title: 'Something went wrong',
                                              message:
                                                  'Can\'t load items right now, please try again later',
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                    return Center(
                                        child: CircularProgressIndicator());
                                  });
                            } else {
                              return firstTabNoDataContent(
                                  database, _eventNoData);
                            }
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                children: <Widget>[
                                  Text(snapshot.error.toString()),
                                  EmptyMessage(
                                    title: 'Something went wrong',
                                    message:
                                        'Can\'t load items right now, please try again later',
                                  )
                                ],
                              ),
                            );
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget pieChartContent() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Expanded(
      //this is within a column
      child: CustomizedContainerNew(
          color: _darkTheme ? darkThemeSurfaceTodo : lightThemeSurface,
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: <Widget>[
              _buildBoxAdaptorPieChart(),
              SliverToBoxAdapter(
                child: _dataMapSelected.isEmpty
                    ? NewPieChart(dataMap: _dataMapToday)
                    : NewPieChart(dataMap: _dataMapSelected),
              )
            ],
          )),
    );
  }

  Widget _buildBoxAdaptorPieChart() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: TextStyle(
                    fontSize: 22.0,
                    color: _darkTheme ? Colors.white : lightThemeWords),
                children: <TextSpan>[
                  TextSpan(text: 'Focused Time on '),
                  TextSpan(
                    text: _dataMapSelected.isEmpty
                        ? 'Today'
                        : '${Format.date(_calendarControllerNew.selectedDay)}',
                    style: TextStyle(
                        fontSize: 22,
                        color: _darkTheme ? Colors.white : lightThemeWords,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _dataMapSelected.isEmpty
                    ? 'Total ${Format.minutes(_todayDuration)}'
                    : 'Total ${Format.minutes(_selectedDuration)}',
                style: Theme.of(context).textTheme.subtitle2,
                textAlign: TextAlign.center,
              ),
            ),
//            SizedBox(height: 10.0),
////              Expanded(  //why adding Expanded here is wrong, because we have SingleChildScrollView
////                child:
//            _dataMapSelected.isEmpty
//                ? NewPieChart(dataMap: _dataMapToday)
//                : NewPieChart(dataMap: _dataMapSelected),
//
////              ),
//            Spacer()
          ],
        ),
      ),
    );
  }

  Widget firstTabNoDataContent(
      Database database, Map<DateTime, List<dynamic>> calendarEvent) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Stack(
//      overflow: Overflow.visible, //no difference
      alignment: Alignment.bottomRight,
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: _darkTheme ? darkThemeSurfaceTodo : lightThemeSurface,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: MyCalendar(
                  events: calendarEvent, //this is empty
                  calendarController: _calendarController,
//                  onDaySelected: (date, _) => _onDaySelected(date, todos),
//                  onDayLongPressed: (date, _) =>
//                      _onLongPressed(date, database, todos),
                  animationController: _animationController,
                ),
              ),
            ),
            Expanded(
              child: CustomizedContainer(
                color: _darkTheme ? darkThemeSurfaceTodo : lightThemeSurface,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                              fontSize: 22.0,
                              color:
                                  _darkTheme ? Colors.white : Colors.black87),
                          children: <TextSpan>[
                            TextSpan(text: 'Task list on '),
                            TextSpan(
                              text: _selectedList.isEmpty ||
                                      (DateFormat('M/d/y').format(
                                              _calendarController
                                                  .selectedDay) ==
                                          DateFormat('M/d/y')
                                              .format(DateTime.now()))
                                  ? 'Today'
                                  : '${Format.date(_calendarController.selectedDay)}',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: _darkTheme
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

//                      Text(
//                        _selectedList.isEmpty
//                            ? 'Task list on Today'
//                            : 'Task list on ${Format.date(_calendarController.selectedDay)}',
//                        style: Theme.of(context).textTheme.headline5,
//                        textAlign: TextAlign.center,
//                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Tap the plus button to enter your first task today.',
                          style: KEmptyContent,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: _listVisible,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0, right: 15),
            child: Tooltip(
              message: 'Tap to add new task',
              preferBelow: false,
              child: MyFAB(
                  heroTag: "btn1",
                  child: Icon(Icons.add, size: 30, color: Colors.white),
                  onPressed: () => _add(database)),
            ),
          ),
        ),
      ],
    );
  }

  Widget secondTabNoDataContent(
      Database database, Map<DateTime, List<dynamic>> calendarEvent) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: _darkTheme ? darkThemeSurfaceTodo : lightThemeSurface,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: MyCalendar(
              events: calendarEvent, //also empty
              calendarController: _calendarController,
              animationController: _animationController,
            ),
          ),
        ),
        pieChartContent(),
      ],
    );
  }

  double _calendarOpacity = 1;

  ///main problem is this add button won't update _selectedList
  Widget firstTab(
    Database database,
    List<Todo> todos,
    Map<DateTime, List<dynamic>> calendarEvent,
    Map<DateTime, List<dynamic>> _notDoneEvents,
  ) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    return Stack(
//      overflow: Overflow.visible, //doesn't change anything
      alignment: Alignment.bottomRight,
      children: <Widget>[
        ///Notes: I was trying to hide the calendar when adding or updating, but
        ///it turns out the calendar will automatically re-set to only select today,
        ///because we have setState: change calendar with Opacity works.
        Column(
          children: <Widget>[
            Visibility(
              visible: _calendarVisible,
              child: Opacity(
                opacity: _calendarOpacity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          _darkTheme ? darkThemeSurfaceTodo : lightThemeSurface,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: MyCalendar(
                      events: calendarEvent,
                      holidays: _notDoneEvents,
                      calendarController: _calendarController,
                      onDaySelected: (date, _) => _onDaySelected(date, todos),
                      onDayLongPressed: (date, _) {
                        setState(() {
                          _taskDate = date;
                        });
                        _add(database);
                      },
                      animationController: _animationController,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Visibility(
                visible: _listVisible,
                child: CustomizedContainerNew(
                  color: _darkTheme ? darkThemeSurfaceTodo : lightThemeSurface,
                  child: CustomScrollView(
                    shrinkWrap: true,
                    controller: _hideButtonController,
                    // put AppBar in NestedScrollView to have it sliver off on scrolling
                    slivers: <Widget>[
                      _buildBoxAdaptor(),
                      _selectedList.isEmpty
                          ? _buildSliverListView(database, todos,
                              _todayList) //this should always dynamically updated when adding new data in home screen
                          : _buildSliverListView(
                              database, todos, _selectedList),

                      //filter null views
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: _listVisible,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0, right: 15),
            child: Visibility(
              visible: _addButtonVisible,
              child: MyFAB(
                  heroTag: "btn1",
                  child: Icon(Icons.add, size: 30, color: Colors.white),
                  onPressed: () => _add(database)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBoxAdaptor() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          children: <Widget>[
            RichText(
              text: TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: TextStyle(
                    fontSize: 22.0,
                    color: _darkTheme ? Colors.white : Colors.black87),
                children: <TextSpan>[
                  TextSpan(text: 'Task list on '),
                  TextSpan(
                    text: _selectedList.isEmpty ||
                            (DateFormat('M/d/y')
                                    .format(_calendarController.selectedDay) ==
                                DateFormat('M/d/y').format(DateTime.now()))
                        ? 'Today'
                        : '${Format.date(_calendarController.selectedDay)}',
                    style: TextStyle(
                        fontSize: 22,
                        color: _darkTheme ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: Text(
                  _selectedList.isEmpty ||
                          (DateFormat('M/d/y')
                                  .format(_calendarController.selectedDay) ==
                              DateFormat('M/d/y').format(DateTime.now()))
                      ? '${_todayNotDoneList.length.toString()} / ${_todayList.length.toString()} tasks'
                      : '${_selectedNotDoneList.length.toString()} / ${_selectedList.length.toString()} tasks',
                  style: Theme.of(context).textTheme.subtitle2,
                )),
            taskListDivider(),
          ],
        ),
      ),
    );
  }

  Widget secondTab(Database database, List<TodoDuration> entries,
      Map<DateTime, List<dynamic>> calendarEvent) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Column(
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: _darkTheme ? darkThemeSurfaceTodo : lightThemeSurface,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: MyCalendar(
                events: calendarEvent,
                calendarController: _calendarControllerNew,
                onDaySelected: (date, _) => _onDaySelectedNew(date, entries),

                ///removed longPressed because we don't have access to todos at this level
//                onDayLongPressed: (date,
//                    _) =>
//                    _onLongPressed(
//                        date,
//                        database,
//                        todos),
                animationController: _animationController,
              ),
            ),
          ),
        ),
        pieChartContent(),
      ],
    );
  }

  Widget _buildSliverListView(
      Database database, List<Todo> todos, List<Todo> anyList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final int itemIndex = index ~/ 2;
          if (index.isEven) {
            return slidableListItem(database, todos, anyList, itemIndex + 1);
          }
          return taskListDivider();
        },
        semanticIndexCallback: (Widget widget, int localIndex) {
          if (localIndex.isEven) {
            return localIndex ~/ 2;
          }
          return null;
        },
        childCount: math.max(0, anyList.length * 2 - 1),
      ),
    );
  }

  Widget taskListDivider() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Divider(
      indent: 75,
      endIndent: 75,
      height: 0.5,
      color: _darkTheme ? Colors.white70 : Colors.black38,
    );
  }

  Widget slidableListItem(
      Database database, List<Todo> todos, List<Todo> anyList, int index) {
    return Slidable(
      key: UniqueKey(),
      closeOnScroll: true,
      actionPane: SlidableDrawerActionPane(),
      // dismissal: SlidableDismissal(
      //   child: SlidableDrawerDismissal(),
      //   onDismissed: (actionType) {
      //     _delete(
      //       context,
      //       anyList,
      //       index,
      //       anyList[index - 1],
      //     );
      //   },
      // ),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        ///Todo
        IconSlideAction(
          caption: 'Add reminder',
          foregroundColor: Colors.yellow,
          color: Colors.black12,
          icon: FontAwesomeIcons.bell,
          onTap: () => null,
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          foregroundColor: Colors.red,
          color: Colors.black12,
          icon: EvaIcons.trash2Outline,
          onTap: () => _delete(
            context,
            anyList,
            index,
            anyList[index - 1],
          ),
        ),

        ///if allow focus here, then user can have two pomodoro at the same time and that's not good.
      ],
      child: TodoListTile(
        todo: anyList[index - 1],
        onPressed: () => _update(database, todos, anyList[index - 1]),
        onTap: () => _update(database, todos, anyList[index - 1]),
        onChangedCheckbox: (newValue) =>
            _onChangedCheckbox(newValue, context, anyList[index - 1]),
      ),
    );
  }

  Future<void> _delete(BuildContext context, List<Todo> _selectedList,
      int index, Todo todo) async {
    final database = Provider.of<Database>(context, listen: false);
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    // added this block
    Todo deletedItem = _selectedList.removeAt(index - 1);
    try {
      await database.deleteTodo(todo);
      //PlatformException is from import 'package:flutter/services.dart';
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }

    ///to make selectedList updates at the same time,
    ///because  _selectedList is not from firebase, it only assign a value when we tap on it.
    setState(() {
      _selectedList.remove(todo);
      _addButtonVisible = false;
    });

    Flushbar(
        isDismissible: true,
        mainButton: FlatButton(
          onPressed: () async {
            try {
              await database.setTodo(todo);
              //PlatformException is from import 'package:flutter/services.dart';
            } on PlatformException catch (e) {
              PlatformExceptionAlertDialog(
                title: 'Operation failed',
                exception: e,
              ).show(context);
            }
//          Navigator.of(context).pop();
            setState(() {
              _selectedList.insert(index - 1, deletedItem);
            });
          },
          child: FlushBarButtonChild(title: 'UNDO'),
        ),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.only(left: 10),
        borderRadius: 15,
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.FLOATING,
//      reverseAnimationCurve: Curves.decelerate,
//      forwardAnimationCurve: Curves.elasticOut,
        backgroundGradient: LinearGradient(colors: [
          Color(0xF0888888).withOpacity(0.95),
          darkThemeNoPhotoBkgdColor
        ]),
        duration: Duration(seconds: 3),
        titleText: Text(
          'Deleted',
          style: KFlushBarTitle,
        ),
        messageText: Text(todo.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: KFlushBarMessage))
      ..show(context).then((value) => setState(() {
            _addButtonVisible = true;
          }));
  }

  Future<void> _onChangedCheckbox(
      newValue, BuildContext context, Todo todo) async {
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

  bool _listVisible = true;
  final DateFormat _dateFormatter = DateFormat('M/d/y');

  /// add new & at the same time update _selectedList
  /// just found that I can not remove todos as a parameter, because we have to create a newList and then add newTodo into the newList and in setState we assign it to anyList, otherwise every time we add a item, the screen only shows the newly added item, the previous is gone unless tap on the day
  Future<void> _add(Database database) async {
    setState(() {
      _listVisible = false;
      _calendarOpacity = 0.0;
    });
    var _typedTitleAndComment = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => AddTodoScreen(
              database: database,
              pickedDate: _taskDate,
//              onTap: _handleDatePicker,
//              dateController: _dateController,
            ));

    if (_typedTitleAndComment != null) {
      try {
        final newTodo = Todo(
          id: documentIdFromCurrentDate(),
          title: _typedTitleAndComment[0],
          comment: _typedTitleAndComment[1],
//            date: _taskDate,
          date: _typedTitleAndComment[2],
          isDone: false,
          category: _typedTitleAndComment[3],
        );
//        print('newTodo.id: ${newTodo.id}');
//        print('newTodo.date: ${newTodo.date}'); //we can't use this to sort the order
        //add newTodo to database
        await database.setTodo(newTodo);

//        print(
//            '_calendarController.selectedDay 1: ${_calendarController.selectedDay}');
//
//        print('newTodo.date: ${newTodo.date}');

        ///if not selecting any day, default is today:
        /// 1st. try not to change date, and this line printed as:
        //flutter: dateNew in init if null: 2020-07-30 11:58:38.538103
        //flutter: widget.dateController.text if null: Jul 30
        //
        //flutter: _calendarController.selectedDay 1: 2020-07-30 11:48:56.819861
        //flutter: newTodo.date: 2020-07-30 11:48:56.589238
        ///the two are not exactly the same, although it's the same day

        ///2. 2nd, change date:
        //flutter: dateNew in init if null: 2020-07-30 11:58:38.538103
        //flutter: widget.dateController.text if null: Jul 30
        //flutter: _dateController.text: Aug 09
        //
        //flutter: _calendarController.selectedDay 1: 2020-07-30 11:58:38.775560
        //flutter: newTodo.date: 2020-08-09 00:00:00.000

        ///if tap on today and only change text, not date, the above two print result is:
        //flutter: dateNew in init if null: 2020-07-30 12:00:00.000Z
        //flutter: widget.dateController.text if null: Jul 30
        //
        //flutter: _calendarController.selectedDay 1: 2020-07-30 12:00:00.000Z
        //flutter: newTodo.date: 2020-07-30 12:00:00.000Z

        ///if tap on today, but add on other day:
        //flutter: dateNew in init if null: 2020-07-30 12:00:00.000Z
        //flutter: widget.dateController.text if null: Jul 30
        //flutter: _dateController.text: Aug 04
        //flutter: _calendarController.selectedDay 1: 2020-07-30 12:00:00.000Z
        //flutter: newTodo.date: 2020-08-04 00:00:00.000

        ///something new: because I added visibility on todo list, the list will automatically update after adding or update item because of setState of visibility
        ///to make selectedList updates at the same time

        /// but new problem: e.g. if we select June 1st, but add item in June 2nd,
        /// then we add newTodo to selectedList!!! how to solve this? the solution
        /// is to add this if statement:
        if (_dateFormatter.format(_calendarController.selectedDay) ==
            _dateFormatter.format(newTodo.date)) {
//          print(
//              '_calendarController.selectedDay 2 if the same date: ${_calendarController.selectedDay}'); //2020-07-27 13:21:08.940561
//          print(
//              'newTodo.date if the same date formatted: ${_dateFormatter.format(newTodo.date)}');

          _selectedList
                  .isEmpty //which means we have not tap on any dates, default is today
              ? setState(() {
                  _todayList = _todayList..add(newTodo);
                })
              : setState(() {
                  _selectedList = _selectedList..add(newTodo);
                });
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
    setState(() {
      _listVisible = true;
      _calendarOpacity = 1.0;
    });
  }

  /// update & at the same time update _selectedList
  void _update(Database database, List<Todo> todos, Todo todo) async {
    setState(() {
      _listVisible = false;
      _calendarOpacity = 0.0;
    });
    var _typedTitleAndComment = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => AddTodoScreen(
              database: database,
              todo: todo,
              pickedDate:
                  _taskDate, //this is the date we are going to pass to add/edote screen
            ));

    if (_typedTitleAndComment != null) {
      try {
        //we get the id from job in the firebase, if the job.id is null,
        //we create a new one, otherwise we use the existing job.id
        final id = todo?.id ?? documentIdFromCurrentDate();
        final isDone = todo?.isDone ?? false;
        final category = todo?.category ?? _typedTitleAndComment[3];

        ///first we find this specific Todo item that we want to update
        final newTodo = Todo(
          id: id,
          title: _typedTitleAndComment[0],
          comment: _typedTitleAndComment[1],
          date: _typedTitleAndComment[2],
          isDone: isDone,
          category: category,
        );

        ///then update newTodo to database
        await database.setTodo(newTodo);

//        print('_taskDate in update: $_taskDate');
//
//        print(
//            '_calendarController.selectedDay in update: ${_calendarController.selectedDay}');
//
//        print('newTodo.date in update: ${newTodo.date}');

        ///if not selecting/tapping on any day, default is today
        /// 1. only update text in today, we got this:
        //flutter: dateNew if NOT null: 2020-07-30 05:00:00.000 //this is todo.date
        //flutter: widget.dateController.text if NOT null: Today
        //
        //flutter: _taskDate in update: 2020-07-30 11:26:47.191350
        //flutter: _calendarController.selectedDay in update: 2020-07-30 11:26:47.445151
        //flutter: newTodo.date in update: 2020-07-30 05:00:00.000 //this is todo.date
        /// 2. now if we change the date in today's list, we got this:
        //flutter: dateNew if NOT null: 2020-07-31 05:00:00.000 //this is todo.date
        //flutter: widget.dateController.text if NOT null: Today
        //flutter: _dateController.text: Aug 01
        //

        //dateNew if NOT null: 2020-07-30 11:26:47.191
        //flutter: widget.dateController.text if NOT null: Today
        //flutter: _dateController.text: Aug 07
        //
        //flutter: _taskDate in update: 2020-07-30 11:26:47.191350
        //flutter: _calendarController.selectedDay in update: 2020-07-30 11:26:47.445151
        //flutter: newTodo.date in update: 2020-08-07 00:00:00.000

        /// in the case we tap on any day:
        /// if changed the date
        //flutter: dateNew if NOT null: 2020-08-03 05:00:00.000
        //flutter: widget.dateController.text if NOT null: Aug 03
        //flutter: _dateController.text: Aug 05
        //
        //flutter: _taskDate in update: 2020-08-03 12:00:00.000Z
        //flutter: _calendarController.selectedDay in update: 2020-08-03 12:00:00.000Z
        //flutter: newTodo.date in update: 2020-08-05 00:00:00.000

        //if not changing date, we get this result:
        //flutter: _calendarController.selectedDay in update: 2020-07-26 12:00:00.000Z
        //flutter: _taskDate in update: 2020-07-26 12:00:00.000Z

        //if changed the date, we get this:
        //flutter: _calendarController.selectedDay in update: 2020-07-26 12:00:00.000Z
        //flutter: _taskDate in update: 2020-07-27 00:00:00.000

        final newList = DailyTodosDetails.getTodosGroupByData(
            _calendarController.selectedDay, todos);
        //todo: use original selectedList works but get white color error: Unhandled Exception: RangeError (index): Invalid value: Valid value range is empty: -1
        ///this two are exactly the same, no need to create newList
//        print('newList: $newList');
//        print('_selectedList: $_selectedList');
//        print(newTodo);

        ///anyway, then we find it's index of the to-be-updated item
        ///e.g list index is [0,1,2,3]
        ///    list is       [a,b,c,d]
        ///    now we find is this newList/_selectedList, the item we want to update is in index 2
        final index = newList.indexWhere((element) => element.id == newTodo.id);

        ///add this if statement because if edited the date, that selectedDay is not the same as final date, then we don't need to insert this to _selectedList
        //this if statement means we did not changed the date
        if (_dateFormatter.format(_calendarController.selectedDay) ==
            _dateFormatter.format(newTodo.date)) {
          ///then we replace this item newList[2] = e, now newList is [a,b,e,d], and of course we need to setState and update our _selectedList
          newList[index] = newTodo;
          setState(() {
            _selectedList = newList;
          });
//          print(
//              'if (_calendarController.selectedDay == newTodo.date), newTodo.date: $newTodo.date');
        } else if (
            //make it formatted because if not selecting any day, default selected day is today and it's in different format
            _dateFormatter.format(_calendarController.selectedDay) !=
                _dateFormatter.format(newTodo.date)) {
          newList[index] = newTodo;
//          print('index: $index');
          newList.remove(newTodo);
//          print(newList.remove(newTodo)); //false
//          print(
//              newList); //this list not updated?, we need to add first and then remove
          setState(() {
            _selectedList = newList;
          });
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }

    setState(() {
      _listVisible = true;
      _calendarOpacity = 1.0;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
    _calendarControllerNew.dispose();
    _animationController.dispose();
  }
}

///layout builder note
//  LayoutBuilder(
//    builder: (context, constraint) {
//      return SingleChildScrollView(
//        child: ConstrainedBox(
//          constraints: BoxConstraints(minHeight: constraint.maxHeight),
//          child: IntrinsicHeight(
//            child: Column(
//              children: <Widget>[
//                Text("Header"),
//                Expanded(
//                  child: Container(
//                    color: Colors.red,
//                  ),
//                ),
//                Text("Footer"),
//              ],
//            ),
//          ),
//        ),
//      );
//    },
//  )
//
//  Widget pieChartContent() {
//    final themeNotifier = Provider.of<ThemeNotifier>(context);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//    return LayoutBuilder(builder: (context, constraint) {
//      return SingleChildScrollView(
//        child: ConstrainedBox(
//          constraints: BoxConstraints(minHeight: constraint.maxHeight),
//          child: IntrinsicHeight(
//            child: Column(
//              children: [
//                Expanded(
//                  //this is within a column
//                  child:
////      SingleChildScrollView(
////        child:
//                      CustomizedContainerNew(
//                    color: _darkTheme ? darkSurfaceTodo : lightSurface,
//                    child: Padding(
//                      padding: const EdgeInsets.all(15.0),
//                      child: Column(
//                        children: <Widget>[
//                          Text(
//                            _dataMapSelected.isEmpty
//                                ? 'Focused Time on Today'
//                                : 'Focused Time on ${Format.date(_calendarControllerNew.selectedDay)}',
//                            style: Theme.of(context).textTheme.headline5,
//                            textAlign: TextAlign.center,
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.only(top: 8.0),
//                            child: Text(
//                              _dataMapSelected.isEmpty
//                                  ? 'Total ${Format.minutes(_todayDuration)}'
//                                  : 'Total ${Format.minutes(_selectedDuration)}',
//                              style: Theme.of(context).textTheme.headline6,
//                              textAlign: TextAlign.center,
//                            ),
//                          ),
//                          SizedBox(height: 10.0),
////              Expanded(  //why adding Expanded here is wrong, because we have SingleChildScrollView
////                child:
//                          _dataMapSelected.isEmpty
//                              ? NewPieChart(dataMap: _dataMapToday)
//                              : NewPieChart(dataMap: _dataMapSelected),
//
////              ),
//                          Spacer()
//                        ],
//                      ),
//                    ),
//                  ),
////      ),
//                ),
//              ],
//            ),
//          ),
//        ),
//      );
//    });
//  }
///original without sliver
//  Widget buildListView(
//      Database database, List<Todo> todos, List<Todo> anyList) {
//    final themeNotifier = Provider.of<ThemeNotifier>(context);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//    return ListView.separated(
//        controller: _hideButtonController,
//        itemCount: anyList.length + 2,
//        separatorBuilder: (context, index) => Divider(
//              indent: 75,
//              endIndent: 75,
//              height: 0.5,
//              color: _darkTheme ? Colors.white70 : Colors.black38,
//            ),
////        shrinkWrap: true,
//        itemBuilder: (context, index) {
//          if (index == 0 || index == anyList.length + 1) {
//            return Container();
//          }
//          return slidableListItem(database, todos, anyList, index);
//        });
//  }

///notes for trying Reorderable: it's only working for selectedList, and the order is temporary
//
//  Widget buildListView(
//      Database database, List<Todo> todos, List<Todo> anyList) {
//    void _onReorder(int oldIndex, int newIndex) {
//      setState(
//        () {
//          if (newIndex > oldIndex) {
//            newIndex -= 1;
//          }
//          final Todo todo = anyList.removeAt(oldIndex);
//          anyList.insert(newIndex, todo);
//        },
//      );
//    }
//
//    return ReorderableListView(
//        //replaced ListView.builder
//        onReorder: _onReorder,
//        scrollDirection: Axis.vertical,
////        shrinkWrap: true,
////        itemCount: anyList.length, //The getter 'length' was called on null.
//        children: List.generate(
//          anyList.length,
//          (index) {
//            return DismissibleListItem(
//              //this one take a TodoListTile
//              index: index,
//              key: Key('$index'),
//              listItems: anyList,
//              database: database,
//              delete: () => _delete(context, anyList[index]),
//              onTap: () => _onTap(database, todos, anyList[index]),
//              onChangedCheckbox: (newValue) =>
//                  _onChangedCheckbox(newValue, context, anyList[index]),
//            );
//          },
//        ));
//  }

///tried to move stream builder down but has error because of TabBarView
