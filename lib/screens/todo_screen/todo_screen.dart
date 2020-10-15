import 'dart:async';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_fab.dart';
import 'package:iMomentum/app/common_widgets/my_stack_screen.dart';
import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/my_strings.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/services/calendar_bloc.dart';
import 'package:iMomentum/app/services/daily_todos_details.dart';
import 'package:iMomentum/screens/todo_screen/new_pie_chart.dart';
import 'package:iMomentum/screens/todo_screen/add_reminder_screen.dart';
import 'package:iMomentum/screens/todo_screen/todo_empty_or_error.dart';
import 'package:iMomentum/screens/todo_screen/todo_list_tile.dart';
import 'package:iMomentum/screens/todo_screen/todo_top_row.dart';
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
  CalendarController _firstCalendarController;
  CalendarController _secondCalendarController;
  AnimationController _animationController;
  Map<DateTime, List<dynamic>> _eventNoData =
      {}; //this is for empty content in task list

  ///for todoList (first tab)
  bool _addButtonVisible = true;
  double _calendarOpacity = 1; //changed to not hide
  bool _listVisible = true; //changed to not hide

  final DateFormat _dateFormatter = DateFormat('M/d/y');
  ScrollController _hideButtonController;
  //default as today, and if select other dates, _date will be _calendarController.selectedDay, and then pass it to AddTodoScreen
  DateTime _taskDate = DateTime.now();

  //this is the list title on the screen, and when user tap on calendar, the date title will change.
  String _titleDateString = 'Today';

  Map<DateTime, List> _events; // for first calendar
  Map<DateTime, List> _notDoneEvents; //for first calendar marker
  //we assign value in StreamBuilder, but must have an initial value
  List<Todo> _todayList = [];
  List<Todo> _todayNotDoneList = [];

  // if not give an initial value, _selectedList.isEmpty will throw error
  List<Todo> _selectedList = [];
  List<Todo> _selectedNotDoneList = [];

  void _onDaySelected1(DateTime date, List<Todo> todos) {
//    print('_onDaySelected: $date'); //flutter: 2020-06-25 12:00:00.000Z
    setState(() {
      //if selected today, we only render _todayList, in this way, _todayList can be dynamically display when added new data in home screen.
      ///this main problem is if selectedDay is empty, it always shows today's list
      _firstCalendarController.isToday(date)
          ? _selectedList =
              _todayList // but if it's empty, it also uses today's list
          : _selectedList = DailyTodosDetails.getTodosGroupByData(date, todos);

      _firstCalendarController.isToday(date)
          ? _selectedNotDoneList =
              _todayNotDoneList // but if it's empty, it also uses today's list
          : _selectedNotDoneList =
              DailyTodosDetails.getNotDoneTodosGroupByData(date, todos);

      ///this very important, otherwise can't update _selectedList
      //_taskDate initial value is today
      _taskDate = date; //for update task date

      ///here update the title, and need to make sure if we tap one today, it shows today
      _getTodoDateTitle(date);
    });
  }

  void _getTodoDateTitle(DateTime date) {
    setState(() {
      _selectedList.isEmpty || //need to check this, this because initial date
              // is always today, we are using the same function for both empty
              // and non-empty list, but if selectedDay list is empty, screen showing today's list, so the date here should also be today.
              (DateFormat('M/d/y')
                      .format(_firstCalendarController.selectedDay) ==
                  DateFormat('M/d/y').format(DateTime.now()))
          ? _titleDateString = 'Today'
          : _titleDateString = '${Format.date(date)}';
    });
  }

  /// for pie chart
  String _titleDateStringPieChart = 'Today';
  // groupby only one day, change to: map[date] = entry.todosDetails, instead of map[date] = entry;
  Map<DateTime, List> _eventsNew; //for second calendar
  //this is map because this is the value used in pie chart
  Map<String, double> _todayDataMap; //again we assign value in SteamBuilder
  Map<String, double> _selectedDataMap =
      {}; // again we gave an empty value to this because we have _dataMapSelected.isEmpty ?

  // must give an initial value because it directly used in Text
  double _todayDuration = 0;
  double _selectedDuration = 0;

  void _onDaySelected2(DateTime date, List<TodoDuration> entries) {
    setState(() {
      _secondCalendarController.isToday(
              date) //if selected today, we only render _todayList, in this way, _todayList can be dynamically display when added new data in home screen.
          ? _selectedDataMap = _todayDataMap
          : _selectedDataMap =
              DailyTodosDetails.getDataMapGroupByDate(date, entries);
      _selectedDuration =
          DailyTodosDetails.getDailyTotalDuration(date, entries);

      _getPieChartTitle(date);
    });
  }

  void _getPieChartTitle(DateTime date) {
    setState(() {
      _selectedDataMap.isEmpty ||
              (DateFormat('M/d/y')
                      .format(_secondCalendarController.selectedDay) ==
                  DateFormat('M/d/y').format(DateTime.now()))
          ? _titleDateStringPieChart = 'Today'
          : _titleDateStringPieChart = '${Format.date(date)}';
    });
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();

    _firstCalendarController = CalendarController();
    _secondCalendarController = CalendarController();
//    print(_calendarController
//        .selectedDay); //only when first come to this page, this is printed as null
    ///then we say if _calendarController.selectedDay == null, we use _todayList, but the problem is as far as we add/delete/update, this if statement no longer valid.
//    print(_calendarController.isSelected(today)); //this line is wrong because The getter 'year' was called on null, we can only use this in onDaySelected
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_addButtonVisible == true) {
          setState(() {
            _addButtonVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_addButtonVisible == false) {
            setState(() {
              _addButtonVisible = true;
            });
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final bloc = Provider.of<CalendarBloc>(context, listen: false);

    return MyStackScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          top: false, // this is to make top bar color cover all
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: _listVisible,
                  child: TodoTopRow(),
                ),
                // two SteamBuilder nested together, The returned value is
                // TabBarView, and this must be below StreamBuilder
                ///StreamBuilder must wrap with Scaffold first, otherwise the empty list message will look terrible
                /// can not remove this Expanded
                Expanded(child: buildStreamBuilderTodo(database, bloc)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<Todo>> buildStreamBuilderTodo(
      Database database, CalendarBloc bloc) {
    return StreamBuilder<List<Todo>>(
      stream: database
          .todosStream(), // print(database.todosStream());//Instance of '_MapStream<QuerySnapshot, List<TodoModel>>'
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Todo> todos = snapshot.data;
          if (todos.isNotEmpty) {
            _events = DailyTodosDetails.getEvents(
                todos); //return a map to use on calender
            _notDoneEvents = DailyTodosDetails.getNotDoneEvents(todos);

            ///get today's list, (unfortunately, it's designed to show _todayList on every other day if this day is empty.)
            _todayList =
                DailyTodosDetails.getTodosGroupByData(DateTime.now(), todos);

            _todayNotDoneList = DailyTodosDetails.getNotDoneTodosGroupByData(
                DateTime.now(), todos);

            return buildStreamBuilderDuration(bloc, database, todos);

            ///here means if no data in today's todoList, that also
            ///means no data in pie chart, we show both empty one
          } else {
            return buildTabBarViewEmptyContent(database);
          }
        } else if

            /// this is if TodoList stream builder has error, we show our error content
            (snapshot.hasError) {
          print('Todo StreamBuilder error: ${snapshot.error.toString()}');
          return buildTabBarViewTodoError(database);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  TabBarView buildTabBarViewEmptyContent(Database database) {
    return TabBarView(
      children: <Widget>[
        firstTabNoDataContent(
            database, _eventNoData, Strings.emptyTodoList, '', ''),
        secondTabNoDataContent(database, _eventNoData),
      ],
    );
  }

  TabBarView buildTabBarViewTodoError(Database database) {
    return TabBarView(
      children: <Widget>[
        ///Todo, contact us
        firstTabNoDataContent(database, _eventNoData, '',
            Strings.streamErrorMessage, 'Or contact us'),
        secondTabNoDataContent(database, _eventNoData),
      ],
    );
  }

  StreamBuilder<List<TodoDuration>> buildStreamBuilderDuration(
      CalendarBloc bloc, Database database, List<Todo> todos) {
    return StreamBuilder<List<TodoDuration>>(
        stream: bloc
            .allTodoDurationStream, //print: flutter: Instance of '_MapStream<List<TodoDuration>, dynamic>'
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<TodoDuration> entries = snapshot
                .data; //print('x: $entries'); //x: [Instance of 'TodoDuration', Instance of 'TodoDuration']
            if (entries.isNotEmpty) {
              ///for second calendar
              _eventsNew = DailyTodosDetails.getEventsNew(entries);

              /// for the pie chart /// it seems every function in this level were execute three times every time I tap on the screen, o
              _todayDataMap = DailyTodosDetails.getDataMapGroupByDate(
                  DateTime.now(), entries);
              _todayDuration = DailyTodosDetails.getDailyTotalDuration(
                  DateTime.now(), entries);
//                                            print(_todayDuration); // if no data, it will show null, not 0
              ///moved StreamBuilder up above TabBarView, otherwise we got error: Bad state: Stream has already been listened to
              return buildTabBarViewMainContent(database, todos, entries);
            } else {
              ///the problem is if no data on pie chart, it always shows nothing on task list,
              ///that's why if no data on pie chart, we return the whole first tab column
              return buildTabBarViewDurationEmptyAndError(database, todos);
            }
          } else if (snapshot.hasError) {
            print('PieChart StreamBuilder error: ${snapshot.error.toString()}');

            /// this is if pie chart stream builder has error, we still show the same as no data on pie chart
            return buildTabBarViewDurationEmptyAndError(database, todos);
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  TabBarView buildTabBarViewMainContent(
      Database database, List<Todo> todos, List<TodoDuration> entries) {
    return TabBarView(
      children: <Widget>[
        firstTab(database, todos, _events, _notDoneEvents),
        secondTab(entries, _eventsNew),
      ],
    );
  }

  TabBarView buildTabBarViewDurationEmptyAndError(
      Database database, List<Todo> todos) {
    return TabBarView(
      children: <Widget>[
        firstTab(database, todos, _events, _notDoneEvents),
        secondTabNoDataContent(database, _eventNoData),
      ],
    );
  }

  /// firstTab UI
  Widget firstTab(
    Database database,
    List<Todo> todos,
    Map<DateTime, List<dynamic>> calendarEvent,
    Map<DateTime, List<dynamic>> _notDoneEvents,
  ) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        ///Notes: I was trying to hide the calendar when adding or updating, but
        ///it turns out the calendar will automatically re-set to only select today,
        ///because we have setState: change calendar with Opacity works.
        Column(
          children: <Widget>[
            firstCalendar(
                database, todos, calendarEvent, _notDoneEvents), //calendar
            todoListCustomScrollView(database,
                todos), //this is a CustomScrollView inside an Expanded
          ],
        ),
        (_todayList.isEmpty) && (_selectedList.isEmpty)
            ? _bottomRow(database)
            : todoAddButton(database),
      ],
    );
  }

  Widget firstCalendar(
    Database database,
    List<Todo> todos,
    Map<DateTime, List<dynamic>> calendarEvent,
    Map<DateTime, List<dynamic>> _notDoneEvents,
  ) {
    return Opacity(
      opacity: _calendarOpacity,
      child: MyCalendar(
        events: calendarEvent,
        holidays: _notDoneEvents,
        calendarController: _firstCalendarController,
        onDaySelected: (date, _) => _onDaySelected1(date, todos),
        onDayLongPressed: (date, _) {
          setState(() {
            _taskDate = date;
          });
          _add(database);
        },
        animationController: _animationController,
      ),
    );
  }

  Widget todoListCustomScrollView(Database database, List<Todo> todos) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Expanded(
      child: Visibility(
        visible: _listVisible,
        child: CustomizedContainerNew(
          color: _darkTheme ? darkThemeSurface : lightThemeSurface,
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  shrinkWrap: true,
                  controller: _hideButtonController,
                  // put AppBar in NestedScrollView to have it sliver off on scrolling
                  slivers: <Widget>[
                    _buildBoxAdaptorForTodoListTitle(),
                    (_todayList.isEmpty) && (_selectedList.isEmpty)
                        ? SliverToBoxAdapter(
                            child: TodoScreenEmptyOrError(
                                text1: Strings.emptyTodoList, tips: ''),
                          )
                        : _selectedList.isEmpty

                            ///not working
                            // _firstCalendarController.selectedDay == null
                            //
                            //     /// it's null, so the method .format get error: getter month was called on null
                            //     // ||
                            //     //     (DateFormat('M/d/y')
                            //     //             .format(_secondCalendarController.selectedDay) ==
                            //     //         DateFormat('M/d/y').format(DateTime.now()))
                            ? _buildSliverList(database, todos,
                                _todayList) //this should always dynamically updated when adding new data in home screen
                            : _buildSliverList(database, todos, _selectedList),
                  ],
                ),
              ),

              ///add this to make add button not hiding task item // or add show tip
              // Visibility(
              //     visible: _addButtonVisible,
              //     child: Column(
              //       children: [_bottomRow(database)],
              //     )),
            ],
          ),
        ),
      ),
    );
  }

  Padding titleAndSubtitle(bool _darkTheme,
      {String title, String dateHighlight, String subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RichText(
            text: TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: textStyleTodoTitle(_darkTheme),
              children: <TextSpan>[
                TextSpan(text: title),
                TextSpan(
                    text: dateHighlight,
                    style: textStyleTodoTitleHighlight(_darkTheme)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxAdaptorForTodoListTitle() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SliverToBoxAdapter(
      child: titleAndSubtitle(
        _darkTheme,
        title: 'Task list on ',
        dateHighlight: _titleDateString,
        subtitle: _selectedList.isEmpty ||
                (DateFormat('M/d/y')
                        .format(_firstCalendarController.selectedDay) ==
                    DateFormat('M/d/y').format(DateTime.now()))
            ? '${_todayNotDoneList.length.toString()} / ${_todayList.length.toString()} tasks'
            : '${_selectedNotDoneList.length.toString()} / ${_selectedList.length.toString()} tasks',
      ),
    );
  }

  Widget _bottomRow(Database database) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Visibility(
      visible: _listVisible,
      child: Visibility(
        visible: _addButtonVisible,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: FlatButton(
                child: Text(
                  'Show Tips',
                  style: textStyleShowTip(_darkTheme),
                ),
                onPressed: _showTipDialog,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0, right: 15),
              child: MyFAB(onPressed: () => _add(database)),
            ),
            // todoAddButton(database),
          ],
        ),
      ),
    );
  }

  Future<void> _showTipDialog() async {
    await PlatformAlertDialog(
      title: 'Tips',
      content: Strings.tipsOnTodoListScreen,
      defaultActionText: 'OK.',
    ).show(context);
  }

  Widget todoAddButton(Database database) {
    return Visibility(
      visible: _listVisible,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 3.0, right: 15),
        child: Visibility(
          visible: _addButtonVisible,
          child: MyFAB(heroTag: "btn1", onPressed: () => _add(database)),
        ),
      ),
    );
  }

  Widget _buildSliverList(
      Database database, List<Todo> todos, List<Todo> anyList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final int itemIndex = index ~/ 2;
          if (index.isEven) {
            return _slidableListItem(database, todos, anyList, itemIndex + 1);
          }
          return _todoListDivider();
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

  Widget _todoListDivider() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Divider(
      indent: 75,
      endIndent: 75,
      height: 0.5,
      color: _darkTheme ? darkThemeDivider : lightThemeDivider,
    );
  }

  Widget _slidableListItem(
      Database database, List<Todo> todos, List<Todo> anyList, int index) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    final Todo todo = anyList[index - 1];
    // this is to make sure only today or after today can add reminder
    // final difference = todo.date.difference(DateTime.now());
    return Slidable(
      key: UniqueKey(),
      closeOnScroll: true,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        // difference.inDays > 0 || difference.inDays == 0
        //     ?
        IconSlideAction(

            ///this is not necessary, but previously many todos were added without hasReminder property, so to prevent error, we add this
            caption: todo.hasReminder == null || todo.hasReminder == false
                ? 'Add reminder'
                : 'Change reminder',
            foregroundColor: _darkTheme ? Colors.yellowAccent : Colors.teal,
            color: _darkTheme ? Colors.black12 : lightThemeNoPhotoColor,
            icon: todo.hasReminder == null || todo.hasReminder == false
                ? FontAwesomeIcons.bell
                : FontAwesomeIcons.solidBell,
            onTap: () => _showAddReminderScreen(todo, database))
        // : null
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          foregroundColor: Colors.red,
          color: _darkTheme ? Colors.black12 : lightThemeNoPhotoColor,
          // lightThemeButton.withOpacity(0.4),
          icon: EvaIcons.trash2Outline,
          onTap: () => _delete(
            context,
            anyList,
            index,
            todo,
          ),
        ),
      ],
      child: TodoListTile(
          todo: todo,
          onPressed: () => _update(database, todos, todo),
          onTap: () => _update(database, todos, todo),
          onChangedCheckbox: (newValue) =>
              _onChangedCheckbox(newValue, context, todo)),
    );
  }

  /// UI for first Tab no data or error
  Widget firstTabNoDataContent(
      Database database,
      Map<DateTime, List<dynamic>> calendarEvent,
      String text1,
      String text2,
      String text3) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Column(
          children: <Widget>[
            firstCalendarEmpty(calendarEvent),
            todoListEmptyContent(text1, text2, text3),
          ],
        ),
        _bottomRow(database)
        // todoAddButton(database),
      ],
    );
  }

  Widget firstCalendarEmpty(Map<DateTime, List<dynamic>> calendarEvent) {
    return Opacity(
      opacity: _calendarOpacity,
      child: MyCalendar(
        events: calendarEvent, //this is empty
        calendarController: _firstCalendarController,
        onDaySelected: (date, _) => _getTodoDateTitle(date),
        animationController: _animationController,
      ),
    );
  }

  Widget todoListEmptyContent(String text1, String text2, String text3) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Expanded(
      child: Visibility(
        visible: _listVisible,
        child: CustomizedContainerNew(
          color: _darkTheme ? darkThemeSurface : lightThemeSurface,
          child: CustomScrollView(
            shrinkWrap: true,
            controller: _hideButtonController,
            // put AppBar in NestedScrollView to have it sliver off on scrolling
            slivers: <Widget>[
              _buildBoxAdaptorForTodoListTitle(),
              SliverToBoxAdapter(
                child: TodoScreenEmptyOrError(
                    text1: text1, tips: text2, textTap: text3),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// secondTab UI
  Widget secondTab(
      List<TodoDuration> entries, Map<DateTime, List<dynamic>> calendarEvent) {
    return Column(
      children: <Widget>[
        MyCalendar(
          events: calendarEvent,
          calendarController: _secondCalendarController,
          onDaySelected: (date, _) => _onDaySelected2(date, entries),
          animationController: _animationController,
        ),
        pieChartCustomScrollView(),
      ],
    );
  }

  Widget pieChartCustomScrollView() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Expanded(
      //this Expanded is within a column
      child: CustomizedContainerNew(
          color: _darkTheme ? darkThemeSurface : lightThemeSurface,
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: <Widget>[
              _buildSliverToBoxForPieChartTitle(), //first two line for title and sutitle
              SliverToBoxAdapter(
                child: _selectedDataMap.isEmpty
                    ? NewPieChart(dataMap: _todayDataMap)
                    : NewPieChart(dataMap: _selectedDataMap),
              )
            ],
          )),
    );
  }

  Widget _buildSliverToBoxForPieChartTitle() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SliverToBoxAdapter(
      child: titleAndSubtitle(
        _darkTheme,
        title: 'Focused Time on ',
        dateHighlight: _titleDateStringPieChart,
        subtitle: _selectedDataMap.isEmpty
            ? 'Total ${Format.minutes(_todayDuration)}'
            : 'Total ${Format.minutes(_selectedDuration)}',
      ),
    );
  }

  Widget secondTabNoDataContent(
      Database database, Map<DateTime, List<dynamic>> calendarEvent) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MyCalendar(
              events: calendarEvent, //also empty
              calendarController: _secondCalendarController,
              onDaySelected: (date, _) => _getPieChartTitle(date),
              animationController: _animationController,
            ), //calendar
            //this already included the content if it's empty
            pieChartCustomScrollView(),
          ],
        ),
        _bottomRowSecondTab(database),
      ],
    );
  }

  Widget _bottomRowSecondTab(Database database) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Visibility(
      visible: _listVisible,
      child: Visibility(
        visible: _addButtonVisible,
        child: SizedBox(
          height: 60,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: FlatButton(
                  child: Text(
                    'Show Tips',
                    style: textStyleShowTip(_darkTheme),
                  ),
                  onPressed: _showTipDialogSecondTab,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTipDialogSecondTab() async {
    await PlatformAlertDialog(
      title: 'Tips',
      content: Strings.tipsOnPieChartScreen,
      defaultActionText: 'OK.',
    ).show(context);
  }

  TextStyle textStyleShowTip(bool _darkTheme) {
    return TextStyle(
        fontSize: 15,
        color: _darkTheme
            ? darkThemeWords.withOpacity(0.8)
            : lightThemeButton.withOpacity(0.9));
  }

  TextStyle textStyleTodoTitle(bool _darkTheme) {
    return TextStyle(
        fontSize: 19.0, color: _darkTheme ? darkThemeWords : lightThemeWords);
  }

  TextStyle textStyleTodoTitleHighlight(bool _darkTheme) {
    return TextStyle(
      fontSize: 19,
      color: _darkTheme ? darkThemeWords : lightThemeWords,
      fontWeight: FontWeight.w600,
    );
  }

  /// all functions for first Tab
  void _showAddReminderScreen(Todo todo, Database database) async {
    // setState(() {
    //   _listVisible = false;
    //   _calendarOpacity = 0.0;
    // });

    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => AddReminderScreen(
              todo: todo,
              database: database,
            ));
    // setState(() {
    //   _listVisible = true;
    //   _calendarOpacity = 1.0;
    // });
  }

  Future<void> _delete(BuildContext context, List<Todo> _selectedList,
      int index, Todo todo) async {
    final database = Provider.of<Database>(context, listen: false);

    ///in callback function, listen should be false
    // final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    // bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

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

            ///we can nit have this
            // Navigator.of(context).pop();
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
        backgroundGradient: KFlushBarGradient,
        duration: Duration(seconds: 4),
        icon: Icon(
          EvaIcons.trash2Outline,
          color: Colors.white,
        ),
        titleText: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            Strings.deleteTaskWarning,
            style: KFlushBarTitle,
          ),
        ),
        messageText: Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Text(todo.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: KFlushBarMessage),
        ))
      ..show(context).then((value) => setState(() {
            _addButtonVisible = true;
          }));
  }

  Future<void> _onChangedCheckbox(
      newValue, BuildContext context, Todo todo) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      todo.isDone = !todo.isDone;
      await database.setTodo(todo);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  Future<void> _add(Database database) async {
    // setState(() {
    //   _listVisible = false;
    //   _calendarOpacity = 0.0;
    // });
    var _typedTitleAndComment = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => AddTodoScreen(
              database: database,
              pickedDate: _taskDate,

              ///moved this to AddTodoScreen
//              onTap: _handleDatePicker,
//              dateController: _dateController,
            ));

    if (_typedTitleAndComment != null) {
      try {
        final newTodo = Todo(
          id: documentIdFromCurrentDate(),
          title: _typedTitleAndComment[0],
          comment: _typedTitleAndComment[1],
          date: _typedTitleAndComment[2],
          isDone: false,
          category: _typedTitleAndComment[3],
          hasReminder: false,
        );
//        print('newTodo.id: ${newTodo.id}');
//        print('newTodo.date: ${newTodo.date}'); //we can't use this to sort the order
//         print(
//             'newTodo.category: ${newTodo.category}');
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
        ///
        // print(
        //     '_firstCalendarController.selectedDay: ${_firstCalendarController.selectedDay}');

        if (_dateFormatter.format(_firstCalendarController.selectedDay) ==
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
    // setState(() {
    //   _listVisible = true;
    //   _calendarOpacity = 1.0;
    // });
  }

  /// update & at the same time update _selectedList
  void _update(Database database, List<Todo> todos, Todo todo) async {
    // setState(() {
    //   _listVisible = false;
    //   _calendarOpacity = 0.0;
    // });
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
        final hasReminder = todo?.hasReminder ?? false;
        final reminderData = todo?.reminderDate ?? null;
        // final category = todo?.category ?? _typedTitleAndComment[3]; //this makes category can not be updated
        // print('update: category: $category');

        ///first we find this specific Todo item that we want to update
        final newTodo = Todo(
          id: id,
          title: _typedTitleAndComment[0],
          comment: _typedTitleAndComment[1],
          date: _typedTitleAndComment[2],
          isDone: isDone,
          category: _typedTitleAndComment[3],
          hasReminder: hasReminder,
          reminderDate: reminderData,
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
            _firstCalendarController.selectedDay, todos); //e.g.
        //todo: use original selectedList works but get white color error: Unhandled Exception: RangeError (index): Invalid value: Valid value range is empty: -1
        ///this two are exactly the same, no need to create newList
        // print('newList: $newList');
        // print('_selectedList: $_selectedList');
        // print(newTodo);

        ///anyway, then we find it's index of the to-be-updated item
        ///e.g list index is [0,1,2,3]
        ///    list is       [a,b,c,d]
        ///    now we find is this newList/_selectedList, the item we want to update is in index 2
        final index = newList.indexWhere((element) => element.id == newTodo.id);
        // print('index: $index');

        ///add this if statement because if edited the date, that selectedDay is not the same as final date, then we don't need to insert this to _selectedList
        //this if statement means we did not changed the date
        //make it formatted because if not selecting any day, default selected
        // day is today and it's in different format
        if (_dateFormatter.format(_firstCalendarController.selectedDay) ==
            _dateFormatter.format(newTodo.date)) {
          ///then we replace this item newList[2] = e, now newList becomes [a,b,e,d], and of course we need to setState and update our _selectedList
          newList[index] = newTodo;
          setState(() {
            _selectedList = newList;
          });
//          print(
//              'if (_calendarController.selectedDay == newTodo.date), newTodo.date: $newTodo.date');
        } else if (_dateFormatter
                .format(_firstCalendarController.selectedDay) !=
            _dateFormatter.format(newTodo.date)) {
          // final newList2 = DailyTodosDetails.getTodosGroupByData(
          //     _firstCalendarController.selectedDay, todos);

          ///we sometimes got range error if inserting newTodo and then remove it
          // newList[index] = newTodo;
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

    // setState(() {
    //   _listVisible = true;
    //   _calendarOpacity = 1.0;
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _firstCalendarController.dispose();
    // _secondCalendarController.dispose();
    _animationController.dispose();
  }
}
