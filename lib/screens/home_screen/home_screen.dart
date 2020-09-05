import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_text_field.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/services/network_service/weather_service.dart';
import 'package:iMomentum/app/utils/show_up.dart';
import 'package:iMomentum/app/utils/tooltip_shape_border.dart';
import 'package:iMomentum/app/utils/top_sheet.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/data/congrats_list.dart';
import 'package:iMomentum/app/models/data/mantras_list.dart';
import 'package:iMomentum/app/models/mantra_model.dart';
import 'package:iMomentum/app/models/quote_model.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/services/auth.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/home_drawer/add_mantra.dart';
import 'package:iMomentum/screens/home_drawer/add_quote.dart';
import 'package:iMomentum/app/common_widgets/my_list_tile.dart';
import 'package:iMomentum/screens/home_screen/weather_screen.dart';
import 'package:iMomentum/screens/iPomodoro/clock_begin_screen.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/screens/todo_screen/add_todo_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'quote.dart';
import 'package:flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum CurrentWeatherState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class _HomeScreenState extends State<HomeScreen> {
  double _mantraOpacity = 1.0;
  double _topBarOpacity = 1.0;

  CurrentWeatherState _state = CurrentWeatherState.NOT_DOWNLOADED;
  int temperature;
  String cityName;
  String weatherIcon;

  void _showTopSheet() {
    setState(() {
      _mantraOpacity = 0.0;
      _topBarOpacity = 0.0;
    });
    TopSheet.show(
      context: context,
      child: WeatherScreen(),
      direction: TopSheetDirection.TOP,
    ).then((value) => setState(() {
          _mantraOpacity = 1.0;
          _topBarOpacity = 1.0;
          _fetchWeather();
        }));
  }

  void _fetchWeather() async {
    final metricNotifier = Provider.of<MetricNotifier>(context, listen: false);
    bool _metricUnitOn = metricNotifier.getMetric();
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    // if (mounted) {
    setState(() {
      _state = CurrentWeatherState.DOWNLOADING;
    });

    var weatherData = await WeatherService.getCurrentWeather(
        _metricUnitOn ? 'metric' : 'imperial');
    setState(() {
      if (weatherData == null) {
        return;
      }

      temperature = weatherData['main']['temp'].toInt();
      cityName = weatherData['name'];
      weatherIcon = weatherData['weather'][0]['icon'];
      _getWeatherIconImage(weatherIcon);
    });

    setState(() {
      _state = CurrentWeatherState.FINISHED_DOWNLOADING;
    });
    // }
  }

  Widget _getWeatherIconImage(String weatherIcon, {double size = 20}) {
    if (weatherIcon == '01n') {
      return Icon(EvaIcons.moonOutline, color: Colors.white, size: size);
    } else {
      return Image(
        image: NetworkImage(
            //https://openweathermap.org/img/wn/04n@2x.png
            "https://openweathermap.org/img/wn/$weatherIcon@2x.png"),
      );
    }
  }

  Widget contentFinishedDownload(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final metricNotifier = Provider.of<MetricNotifier>(context, listen: false);
    bool _metricUnitOn = metricNotifier.getMetric();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(children: [
            Container(
              decoration: BoxDecoration(
                  color: _darkTheme ? Colors.transparent : Colors.transparent,
                  shape: BoxShape.circle),
              height: 30,
              width: 30,
              child: _getWeatherIconImage(weatherIcon),
            ),
            SizedBox(width: 3.0),
            Text(
              _metricUnitOn ? '$temperature°C' : '$temperature°F',
              style: TextStyle(
                  // color: Colors.white,
                  color: _darkTheme ? darkThemeWords : lightThemeWords,
                  fontSize: 15.0),
            ),
          ]),
          Text(
            '$cityName',
            style: TextStyle(
                // color: Colors.white,
                color: _darkTheme ? darkThemeWords : lightThemeWords,
                fontSize: 15.0),
          ),
        ],
      ),
    );
  }

  Widget contentDownloading() {
    return Center(child: CircularProgressIndicator(strokeWidth: 10));
  }

  Widget contentNotDownloaded() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '',
          ),
        ],
      ),
    );
  }

  Widget _resultView(BuildContext context) =>
      _state == CurrentWeatherState.FINISHED_DOWNLOADING
          ? contentFinishedDownload(context)
          : _state == CurrentWeatherState.DOWNLOADING
              ? contentDownloading()
              : contentNotDownloaded();

  Widget _topBar() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Opacity(
      opacity: _topBarOpacity,
      child: Container(
        color: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: _showTopSheet,
                      onDoubleTap: _fetchWeather,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15, left: 5),
                        child: _resultView(context),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void _focusButton(Database database, Todo todo) {
    ///if using this one, it works fine but when click play button on Clock Begin
    ///Screen, it always shows a black screen first, and then start timer.
    ///adding BuildContext context has no difference, it still showing black screen when start to play.
    // // default is 400 milliseconds
    // SharedAxisTransitionType _transitionType = SharedAxisTransitionType.scaled;
    // final route = SharedAxisPageRoute(
    //     page: ClockBeginScreen(database: database, todo: todo),
    //     transitionType: _transitionType,
    //     milliseconds: 800);
    // Navigator.of(context, rootNavigator: true).push(route);

    ///use this will work properly
    Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
      builder: (context) => ClockBeginScreen(database: database, todo: todo),
      fullscreenDialog: true,
    ));

    /// the problem of using this is that if we cancel in ClockBeginScreen, it pop
    /// to a black screen instead of HomeScreen.
    /// Notes:
    //https://stackoverflow.com/questions/53723294/flutter-navigator-popcontext-returning-a-black-screen#:~:text=As%20the%20history%20of%20your,MaterialApp%20in%20all%20nested%20screens.
    //https://medium.com/flutter-community/flutter-push-pop-push-1bb718b13c31
    //https://www.freecodecamp.org/news/how-to-handle-navigation-in-your-flutter-apps-ceaf2f411dcd/
    ///
    // Navigator.of(context).pushReplacement(
    //   PageRoutes.fade(() => ClockBeginScreen(database: database, todo: todo)),
    // );
  }

//  final String formattedTime = DateFormat('kk:mm').format(DateTime.now());
  final String dayOfWeek = DateFormat.E().format(DateTime.now());
  final String formattedDate = DateFormat.MMMd().format(DateTime.now());
  String _secondGreetings;
  String _focusAnswer = '';

  bool _middleColumnVisible = true;
  // change visible to opacity, otherwise, quote always updates.
  // bool _quoteVisible = true;
  double _quoteOpacity = 1.0;

  DateTime _date = DateTime.now();

  @override
  void initState() {
    _secondGreetings = DefaultMantraList().showMantra().body;
    _fetchWeather();
    super.initState();
  }

  int counter = 0;
  void _onDoubleTap() {
    setState(() {
      ImageUrl.randomImageUrl = '${ImageUrl.randomImageUrlFirstPart}$counter';
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _topBar(),
                  _buildStream(), //Expanded
                  Opacity(
                    opacity: _quoteOpacity,
                    // visible: _quoteVisible,
                    child: _buildQuoteStream(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Todo> _getTodayNotDone(List<Todo> todos) {
    List<Todo> todayTodos = [];
    todos.forEach((todo) {
      DateTime today = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      DateTime date = DateTime(todo.date.year, todo.date.month, todo.date.day);
      if ((date == today) && (todo.isDone == false) && (todo.category == 0)) {
        todayTodos.add(todo);
      }
    });
    return todayTodos;
  }

  int _current = 0;
  Widget _buildStream() {
    // final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    // bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final database = Provider.of<Database>(context, listen: false);
    final focusNotifier = Provider.of<FocusNotifier>(context);
    bool _focusModeOn = focusNotifier.getFocus();

    return StreamBuilder<List<Todo>>(
      stream: database.todosStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Todo> todos = snapshot.data;
          if (todos.isNotEmpty) {
            final todayTodosNotDone = _getTodayNotDone(todos);
            if (todayTodosNotDone.length > 0) {
//              final todo = todayTodosNotDone.first; //changed to carousal
              return Visibility(
                visible: _middleColumnVisible,
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Spacer(flex: _focusModeOn ? 3 : 1),
                      Opacity(
                        opacity: _mantraOpacity,
                        child: Column(
                          children: <Widget>[
                            _buildMantraStream(),
                            Visibility(
                              visible: _focusModeOn ? true : false,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 50), //space between mantra
                                  CarouselSlider(
                                    options: CarouselOptions(
//                                    height: 250.0, //default height is good enough
                                      viewportFraction: 1.0,
                                      initialPage: 0, //default
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _current = index;
                                        });
                                      },
                                    ),
                                    items: todayTodosNotDone.map((todo) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              getToday, //25
                                              SizedBox(height: 5),
                                              Center(
                                                child: HomeTodoListTile(
                                                  todo: todo,
                                                  onChangedCheckbox:
                                                      (newValue) =>
                                                          _onChangedCheckbox(
                                                              newValue,
                                                              database,
                                                              todo),
                                                  onTap: () => _onTapTodo(
                                                      database,
//                                                      todayTodosNotDone,
                                                      todo),
                                                  onPressed: () =>
                                                      _delete(database, todo),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                child: Tooltip(
                                                  message:
                                                      'This button takes you to Pomodoro Timer Page.',
                                                  textStyle: TextStyle(
                                                      color: Colors.white),
                                                  preferBelow: false,
                                                  verticalOffset: 0,
                                                  decoration: ShapeDecoration(
                                                    color: Color(0xf0086972)
                                                        .withOpacity(0.9),
                                                    shape: TooltipShapeBorder(
                                                        arrowArc: 0.5),
                                                    shadows: [
                                                      BoxShadow(
                                                          color: Colors.black26,
                                                          blurRadius: 4.0,
                                                          offset: Offset(2, 2))
                                                    ],
                                                  ),
                                                  margin: const EdgeInsets.all(
                                                      30.0),
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: MyFlatButton(
                                                    // color: _darkTheme
                                                    //     ? Colors.white
                                                    //     : lightThemeButton,
                                                    onPressed: () =>
                                                        _focusButton(
                                                            database, todo),
                                                    text: 'Focus Mode',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: todayTodosNotDone.map((todo) {
                                        int index =
                                            todayTodosNotDone.indexOf(todo);
                                        return todayTodosNotDone.length > 1
                                            ? Container(
                                                width: 8.0,
                                                height: 8.0,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 2.0),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: _current == index
                                                        ? Colors.white70
                                                        : Colors.white24),
                                              )
                                            : Container();
                                      }).toList()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              );
            } else {
              return _emptyListScreen(); //if todayTodosNotDone is empty
            }
          } else {
            return _emptyListScreen(); // if todos is empty
          }
        } else if (snapshot.hasError) {
          return _emptyListScreen(text: textError); //if error
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _emptyListScreen({String text = ''}) {
    final focusNotifier = Provider.of<FocusNotifier>(context);
    bool _focusModeOn = (focusNotifier.getFocus() == true);

    return Expanded(
      child: Column(
        children: <Widget>[
          Visibility(
              visible: _focusModeOn ? false : true,
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Spacer(),
                    Opacity(
                      opacity: _mantraOpacity,
                      child: Column(
                        children: <Widget>[
                          _buildMantraStream(),
                        ],
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              )),
          Visibility(
            visible: _focusModeOn ? true : false,
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Spacer(flex: 1),
                  SizedBox(height: 30),
                  Opacity(
                    opacity: _mantraOpacity,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: getFirstGreetings,
                        ), //first greetings
                        SizedBox(height: 80),
                        Column(
                          children: <Widget>[
                            getFormattedDate, //30
                            SizedBox(height: 20),
                            getQuestion(), //33
                            HomeTextField(
                              onSubmitted: _onSubmitted,
                            ),
                            SizedBox(height: 10),
                            Text(text)
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///all function on task:
  void _onSubmitted(newText) async {
    final database = Provider.of<Database>(context, listen: false);
    if (newText.isNotEmpty) {
      setState(() {
        _focusAnswer = newText;
      });
      FocusScope.of(context).unfocus();
      try {
        final todo = Todo(
          id: documentIdFromCurrentDate(),
          title: _focusAnswer,
          date: DateTime.now(),
          isDone: false,
          category: 0,
          hasReminder: false,
        );
        await database.setTodo(todo);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  Future<void> _delete(Database database, Todo todo) async {
    setState(() {
      _quoteOpacity = 0.0;
    });

    try {
      await database.deleteTodo(todo);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }

    Flushbar(
      isDismissible: true,
      mainButton: FlatButton(
          onPressed: () async {
            try {
              await database.setTodo(todo);
            } on PlatformException catch (e) {
              PlatformExceptionAlertDialog(
                title: 'Operation failed',
                exception: e,
              ).show(context);
            }

            ///should not add this line, because when it's going to be automatically
            ///dismissed, and then press this will take to black screen.
            ///
            /// added BuildContext context, then not pop to black screen

            // Navigator.pop(context);
          },
          child: FlushBarButtonChild(title: 'UNDO')),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(left: 10),
      borderRadius: 15,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundGradient: LinearGradient(colors: [
        Color(0xF0888888).withOpacity(0.85),
        darkThemeNoPhotoBkgdColor,
      ]),
      duration: Duration(seconds: 3),
      icon: Icon(
        EvaIcons.trash2Outline,
        color: Colors.white,
      ),
      titleText: Text('Deleted', style: KFlushBarTitle),
      messageText: Text(todo.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: KFlushBarMessage),
    )..show(context).then((value) => setState(() {
          // _quoteVisible = !_quoteVisible;
          _quoteOpacity = 1.0;
        }));
  }

  final String _congrats = CongratsList().getCongrats().body;

  Future<void> _onChangedCheckbox(
      newValue, Database database, Todo todo) async {
    setState(() {
      _quoteOpacity = 0.0;
      // _quoteVisible = !_quoteVisible;
    });

    try {
      todo.isDone = true;
      await database.setTodo(todo);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }

    Flushbar(
      isDismissible: true,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
      borderRadius: 15,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
//      reverseAnimationCurve: Curves.decelerate,
//      forwardAnimationCurve: Curves.elasticOut,
      backgroundGradient: LinearGradient(colors: [
        Color(0xF0a2de96).withOpacity(0.95),
        Color(0xF03ca59d).withOpacity(0.95)
      ]),
      duration: Duration(seconds: 3),
      icon: Icon(
        Icons.check,
        color: Colors.white,
      ),
      titleText: Text(
        _congrats,
        style: KFlushBarTitle,
      ),
      messageText: Text(
        todo.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: KFlushBarMessage,
      ),
    )..show(context).then((value) => setState(() {
          // _quoteVisible = !_quoteVisible;
          _quoteOpacity = 1.0;
        }));
  }

  /// update & at the same time update _selectedList
  void _onTapTodo(Database database, Todo todo) async {
    setState(() {
      _middleColumnVisible = false;
      // _quoteVisible = false;
      _quoteOpacity = 0.0;
    });
    var _typedTitleAndComment = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddTodoScreen(
        database: database,
        todo: todo,
        pickedDate: _date,
      ),
    );

    if (_typedTitleAndComment != null) {
      try {
        //we get the id from job in the firebase, if the job.id is null,
        //we create a new one, otherwise we use the existing job.id
        final id = todo?.id ?? documentIdFromCurrentDate();
        final isDone = todo?.isDone ?? false;
        final hasReminder = todo?.hasReminder ?? false;
        final reminderData = todo?.reminderDate ?? null;

        ///first we find this specific Todo item that we want to update
        final newTodo = Todo(
            id: id,
            title: _typedTitleAndComment[0],
            comment: _typedTitleAndComment[1],
            date: _typedTitleAndComment[2],
            isDone: isDone,
            category: _typedTitleAndComment[3],
            hasReminder: hasReminder,
            reminderDate: reminderData);

        //add newTodo to database
        await database.setTodo(newTodo);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }

    setState(() {
      _middleColumnVisible = true;
      // _quoteVisible = true;
      _quoteOpacity = 1.0;
    });
  }

  ///mantra stream
  Widget _buildMantraStream() {
    final database = Provider.of<Database>(context, listen: false);
    //for mantra
    final mantraNotifier = Provider.of<MantraNotifier>(context);
    bool _useMyMantra = mantraNotifier.getMantra();
//    int _getMantraIndex = mantraNotifier.getMantraIndex();
    return StreamBuilder<List<MantraModel>>(
      stream: database.mantrasStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<MantraModel> mantras = snapshot.data;
          if (mantras.isNotEmpty) {
            if (_useMyMantra == true) {
//              final mantra = mantras[mantras.length - 1];
              return CarouselSlider(
                options: CarouselOptions(
                  height:
                      120.0, //if we don't give it a height, it will set as default height which is higher
                  viewportFraction: 1,
//                  //we have change to make the most-recent edited one to be the first
//                  initialPage: mantras.length - 1,
                ),
                items: mantras.map((mantra) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Center(
                        child: HomeMantraListTile(
                          mantra: mantra,
                          onTap: () => _onTapMantra(database, mantra),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            } else {
              return getSecondGreetings;
            }
          } else {
            return getSecondGreetings;
          }
        } else if (snapshot.hasError) {
          return getSecondGreetings;
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void _onTapMantra(Database database, MantraModel mantra) async {
    setState(() {
      // _quoteVisible = false;
      _quoteOpacity = 0.0;
      _middleColumnVisible = false;
    });
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => AddMantraScreen(
              database: database,
              mantra: mantra,
            ));
    setState(() {
      // _quoteVisible = true;
      _quoteOpacity = 1.0;
      _middleColumnVisible = true;
    });
  }

  ///quote stream
  Widget _buildQuoteStream() {
    final database = Provider.of<Database>(context, listen: false);
    final quoteNotifier = Provider.of<QuoteNotifier>(context);
    bool _useMyQuote = quoteNotifier.getQuote();
    return StreamBuilder<List<QuoteModel>>(
      stream: database.quotesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<QuoteModel> quotes = snapshot.data;
          if (quotes.isNotEmpty) {
            if (_useMyQuote == true) {
              return CarouselSlider(
                options: CarouselOptions(
                  height: 70.0,
                  viewportFraction: 1,
//                  initialPage: quotes.length - 1, //default is first, we already changed the order from database
                ),
                items: quotes.map((quote) {
                  return Builder(
                    builder: (BuildContext context) {
                      return InkWell(
                        onTap: () => _onTapQuote(database, quote),
                        child: DailyQuote(
                            title: quote.title, author: quote.author),
                      );
                    },
                  );
                }).toList(),
              );
            } else {
              return APIQuote();
            }
          } else {
            return APIQuote();
          }
        } else if (snapshot.hasError) {
          return APIQuote();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void _onTapQuote(Database database, QuoteModel quote) async {
    setState(() {
      _middleColumnVisible = false;
      // _quoteVisible = false;
      _quoteOpacity = 0.0;
    });
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => AddQuoteScreen(
              database: database,
              quote: quote,
            ));
    setState(() {
      _middleColumnVisible = true;
      // _quoteVisible = true;
      _quoteOpacity = 1.0;
    });
  }

  Text get getFormattedDate {
    return Text(
      '$dayOfWeek, $formattedDate ',
      style: TextStyle(
        color: Colors.white,
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget getQuestion() {
    return TypewriterAnimatedTextKit(
      isRepeatingAnimation: false,
      text: ['What is your main focus today?'],
      textAlign: TextAlign.center,
      textStyle: TextStyle(
          color: Colors.white, fontSize: 33.0, fontWeight: FontWeight.bold),
    );
  }

  Widget get getFirstGreetings {
    final User user = Provider.of<User>(context, listen: false);

    return AutoSizeText(
      user.displayName == null
          ? '${FirstGreetings().showGreetings()}'
          : '${FirstGreetings().showGreetings()}, ${user.displayName.substring(0, user.displayName.indexOf(' '))}',
      maxLines: 2,
      maxFontSize: 35,
      minFontSize: 30,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 35.0, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  Widget get getSecondGreetings {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ShowUp(
        delay: 500,
        child: Text(
          _secondGreetings, //SecondGreetings().showGreetings().body
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 35.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Text get getToday {
    return Text(
      'TODAY',
      style: TextStyle(
          color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
    );
  }
}
