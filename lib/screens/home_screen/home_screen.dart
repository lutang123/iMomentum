import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_text_field.dart';
import 'package:iMomentum/app/common_widgets/my_tooltip.dart';
import 'package:iMomentum/app/common_widgets/my_sizedbox.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/constants/image_path.dart';
import 'package:iMomentum/app/constants/my_strings.dart';
import 'package:iMomentum/app/services/network_service/weather_service.dart';
import 'package:iMomentum/app/sign_in/firebase_auth_service_new.dart';
import 'package:iMomentum/app/utils/show_up.dart';
import 'package:iMomentum/app/utils/top_sheet.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/data/congrats_list.dart';
import 'package:iMomentum/app/models/data/mantras_list.dart';
import 'package:iMomentum/app/models/mantra_model.dart';
import 'package:iMomentum/app/models/quote_model.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/home_drawer/add_mantra_screen.dart';
import 'package:iMomentum/screens/home_drawer/add_quote_screen.dart';
import 'package:iMomentum/app/common_widgets/my_list_tile.dart';
import 'package:iMomentum/screens/home_screen/weather_screen.dart';
import 'package:iMomentum/screens/iPomodoro/clock_begin_screen.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/screens/todo_screen/add_todo_screen.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcase.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'daily_quote.dart';
import 'package:flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:iMomentum/app/utils/extension_firstCaps.dart';

class HomeScreen extends StatefulWidget {
  static const PREFERENCES_IS_FIRST_LAUNCH_STRING =
      "HOME_IS_FIRST_LAUNCH_STRING";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum CurrentWeatherState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class _HomeScreenState extends State<HomeScreen> {
  double _quoteOpacity = 1.0; //used when showing flush bar
  double _wholeBodyOpacity = 1.0; //used when edit or show top sheet
  //todo
  bool _questionVisible = true;
  bool _nameVisible = true; //used when edit name

  CurrentWeatherState _state = CurrentWeatherState.NOT_DOWNLOADED;
  int temperature;
  String cityName;
  String weatherIcon;

  void _showTopSheet() {
    setState(() {
      _wholeBodyOpacity = 0.0;
    });
    TopSheet.show(
      context: context,
      child: WeatherScreen(),
      direction: TopSheetDirection.TOP,
    ).then((value) => setState(() {
          _wholeBodyOpacity = 1.0;
          _fetchWeather();
        }));
  }

  void _fetchWeather() async {
    ///because we call fetch weather again after changing, so listen can be false
    final metricNotifier = Provider.of<MetricNotifier>(context, listen: false);
    bool _metricUnitOn = metricNotifier.getMetric();
    // If the widget was removed from the tree while the asynchronous platform message was in flight, we want to discard the reply rather than calling setState to update our non-existent appearance.
    if (!mounted) return;
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
  }

  Widget _getWeatherIconImage(String weatherIcon, {double size = 20}) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    if (weatherIcon == '01n') {
      return Icon(EvaIcons.moonOutline,
          color: _darkTheme
              ? darkThemeWords.withOpacity(0.7)
              : lightThemeWords.withOpacity(0.7),
          size: size);
    } else {
      return Image(
        image: NetworkImage(
            //https://openweathermap.org/img/wn/04n@2x.png
            "https://openweathermap.org/img/wn/$weatherIcon@2x.png"),
      );
    }
  }

  void _focusButton(Database database, Todo todo) {
    ///if using SharedAxisPageRoute, it works fine but when click play button on Clock Begin Screen, it always shows a black screen first, and then start timer.
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

    /// the problem of using PageRoutes.fade is that if we cancel in ClockBeginScreen, it pop to a black screen instead of HomeScreen.
    //https://stackoverflow.com/questions/53723294/flutter-navigator-popcontext-returning-a-black-screen#:~:text=As%20the%20history%20of%20your,MaterialApp%20in%20all%20nested%20screens.
    //https://medium.com/flutter-community/flutter-push-pop-push-1bb718b13c31
    //https://www.freecodecamp.org/news/how-to-handle-navigation-in-your-flutter-apps-ceaf2f411dcd/
    //
    // Navigator.of(context).pushReplacement(
    //   PageRoutes.fade(() => ClockBeginScreen(database: database, todo: todo)),
    // );
  }

  final String dayOfWeek = DateFormat.E().format(DateTime.now());
  final String formattedDate = DateFormat.MMMd().format(DateTime.now());
  final String _congrats = CongratsList().getCongrats().body;
  String _defaultMantra;

  DateTime _date = DateTime.now();

  @override
  void initState() {
    _defaultMantra = DefaultMantraList().showMantra().body;
    _fetchWeather();
    super.initState();
  }

  int counter = 0;
  void _onDoubleTap() {
    setState(() {
      ImagePath.randomImageUrl = '${ImagePath.randomImageUrlFirstPart}$counter';
      counter++;
    });
  }

  ///notes on showcase view
  GlobalKey _first = GlobalKey();
  GlobalKey _second = GlobalKey();
  GlobalKey _third = GlobalKey();
  GlobalKey _fourth = GlobalKey();

  Future<bool> _isFirstLaunch() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    bool isFirstLaunch = sharedPreferences
            .getBool(HomeScreen.PREFERENCES_IS_FIRST_LAUNCH_STRING) ??
        true;
    if (isFirstLaunch)
      sharedPreferences.setBool(
          HomeScreen.PREFERENCES_IS_FIRST_LAUNCH_STRING, false);
    return isFirstLaunch;
  }

  @override
  Widget build(BuildContext context) {
    /// add showcase only if first launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isFirstLaunch().then((result) {
        if (result)
          ShowCaseWidget.of(context)
              .startShowCase([_first, _second, _third, _fourth]);
      });
    });

    /// in homepage this can not have listen to false (same as HomeDrawer) otherwise the screen photo not immediately updates, but in other screen it can have listen to false
    final randomNotifier = Provider.of<RandomNotifier>(context);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context);
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        BuildPhotoView(
          imageUrl:
              _randomOn ? ImagePath.randomImageUrl : imageNotifier.getImage(),
        ),
        ContainerLinearGradient(),
        GestureDetector(
          onDoubleTap: _onDoubleTap,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
                top: false,
                child: Opacity(
                  opacity: _wholeBodyOpacity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _topBar(),
                      Showcase(
                          key: _second,
                          description: Strings.second,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          child: Container()), //for weather
                      _middleContent(), //Expanded
                      !isKeyboardVisible
                          ? Visibility(
                              visible: _nameVisible,
                              //this opacity is used when flushbar comes from bottom
                              child: Opacity(
                                  opacity: _quoteOpacity,
                                  child: _buildQuoteStream()))
                          : Container(),
                    ],
                  ),
                )),
          ),
        )
      ],
    );
  }

  /// top bar
  Widget _topBar() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
      color: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
      child: Column(
        children: <Widget>[
          MyTopSizedBox(),
          SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: _showTopSheet,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: _resultView(),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _resultView() => _state == CurrentWeatherState.FINISHED_DOWNLOADING
      ? _contentFinished()
      : _state == CurrentWeatherState.DOWNLOADING
          ? Center(child: CircularProgressIndicator(strokeWidth: 5))
          : Container();

  Widget _contentFinished() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    //because we call fetch weather again after changing, so listen can be false
    final metricNotifier = Provider.of<MetricNotifier>(context, listen: false);
    bool _metricUnitOn = metricNotifier.getMetric();
    return Showcase(
      key: _first,
      description: Strings.first,
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
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
                  color: _darkTheme ? darkThemeWords : lightThemeWords,
                  fontSize: 15.0),
            ),
          ]),
          Text(
            '$cityName',
            style: TextStyle(
                color: _darkTheme ? darkThemeWords : lightThemeWords,
                fontSize: 15.0),
          ),
        ],
      ),
    );
  }

  /// middle content
  int _current = 0; // for the dot
  StreamBuilder<List<Todo>> _middleContent() {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Todo>>(
      stream: database.todosStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Todo> todos = snapshot.data;
          if (todos.isNotEmpty) {
            final todayTodosNotDone = _getTodayNotDone(todos);
            if (todayTodosNotDone.length > 0) {
              return _todoItemContent(database, todayTodosNotDone); //Expanded
            } else {
              return _emptyListQuestionContent(); //if todayTodosNotDone is empty //Expanded
            }
          } else {
            return _emptyListQuestionContent(); // if todos is empty //Expanded
          }
        } else if (snapshot.hasError) {
          ///Todo: onTap contact us
          return _errorScreen(
              text: Strings.textError,
              textTap: 'Or contact us'); //if error  //Expanded
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Expanded _todoItemContent(Database database, List<Todo> todayTodosNotDone) {
    //we can not set this to listen: false, otherwise the screen will not update immediately
    final focusNotifier = Provider.of<FocusNotifier>(context);
    bool _focusModeOn = focusNotifier.getFocus();
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Spacer(flex: _focusModeOn ? 2 : 1),
          Column(
            children: <Widget>[
              _buildMantraStream(),
              Visibility(
                visible: _focusModeOn ? true : false,
                child: Column(
                  children: <Widget>[
                    MyHomeMiddleSpaceSizedBox(), //space between mantra and Today's Todos
                    _buildTaskCarouselSlider(database, todayTodosNotDone),
                  ],
                ),
              ),
            ],
          ),
          Spacer()
        ],
      ),
    );
  }

  Column _buildTaskCarouselSlider(
      Database database, List<Todo> todayTodosNotDone) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            //height: 250.0, //default height is good enough
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('TODAY', style: KHomeToday),
                    SizedBox(height: 5),
                    HomeTodoListTile(
                      todo: todo,
                      onChangedCheckbox: (newValue) =>
                          _onChangedCheckbox(newValue, database, todo),
                      onTap: () => _onTapTodo(database, todo),
                      onPressed: () => _delete(database, todo),
                    ),
                    SizedBox(height: 10),
                    MyToolTip(
                      message: Strings.focusButtonTip,
                      child: MyFlatButton(
                        onPressed: () => _focusButton(database, todo),
                        text: 'Focus Mode',
                        bkgdColor: Colors.transparent,
                      ),
                    ),
                  ],
                );
              },
            );
          }).toList(),
        ),
        _sliderDot(todayTodosNotDone, _current, 8.0),
      ],
    );
  }

  Row _sliderDot(List list, int current, double size) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list.length < 11
            ? list.map((todo) {
                int index = list.indexOf(todo);
                return list.length > 1
                    ? MyDotContainer(
                        size: size,
                        color:
                            current == index ? Colors.white70 : Colors.white38)
                    : Container();
              }).toList()
            : list.take(10).map((todo) {
                int index = list.indexOf(todo);
                return list.length > 1
                    ? MyDotContainer(
                        size: size,
                        color:
                            current == index ? Colors.white70 : Colors.white38)
                    : Container();
              }).toList());
  }

  /// middle content Question, this means if there is no data from TodoStream, then we display question.
  Expanded _emptyListQuestionContent() {
    final focusNotifier = Provider.of<FocusNotifier>(context);
    bool _focusModeOn = (focusNotifier.getFocus() == true);
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Spacer(),
          _focusModeOn
              ? _buildGreetingAndQuestionColumn()
              : _buildMantraStream(),
          Spacer(),
        ],
      ),
    );
  }

  Column _buildGreetingAndQuestionColumn() {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: getFirstGreetings,
        ), //first greetings
        !isKeyboardVisible //this is to prevent no space when adding task
            ? Visibility(
                //this is to edit name without running out of space, add this visibility, including quote
                visible: _nameVisible,
                child: MyHomeMiddleSpaceSizedBox())
            : SizedBox(height: 10),
        Visibility(
          visible: _nameVisible,
          child: _questionAndTextField(),
        ),
      ],
    );
  }

  Column _questionAndTextField() {
    return Column(
      children: <Widget>[
        Text('$dayOfWeek, $formattedDate ', style: KHomeDate),
        SizedBox(height: 15),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _buildQuestion(),
            ), //33
            Showcase(
                key: _fourth,
                description: Strings.fourth,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: _buildHomeTextField()),
          ],
        ),
      ],
    );
  }

  // todo: make user schedule
  Widget _buildQuestion() {
    final int hour = int.parse(DateFormat('kk').format(DateTime.now()));
    if ((hour >= 6) & (hour < 20)) {
      return TypewriterAnimatedTextKit(
        isRepeatingAnimation: false,
        text: ['What is your main focus today?'],
        textAlign: TextAlign.center,
        textStyle: KHomeQuestion,
      );
    } //8pm
    else if ((hour >= 20) & (hour < 23)) {
      return Visibility(
        //after submitTomorrow,  _questionVisible is false;
        visible: _questionVisible,
        child: TypewriterAnimatedTextKit(
          isRepeatingAnimation: false,
          text: ['What is your plan tomorrow?'],
          textAlign: TextAlign.center,
          textStyle: KHomeQuestion,
        ),
      );
    } else //after 11pm
      return ShowUp(
        delay: 500,
        child: Text('Have a good night sleep.', style: KHomeQuestion2),
      );
  }

  Widget _buildHomeTextField() {
    final int hour = int.parse(DateFormat('kk').format(DateTime.now()));
    if ((hour >= 6) & (hour < 20)) {
      return HomeTextField(onSubmitted: _onSubmitted);
    } //8pm
    else if ((hour >= 20) & (hour < 23)) {
      // 8pm-11pm
      return Visibility(
          //after submitTomorrow,  _questionVisible is false;
          visible: _questionVisible,
          child: HomeTextField(onSubmitted: _onSubmittedTomorrow));
    } else //after 11pm, and on question will becomes good night
      return Container();
  }

  ///error screen
  Expanded _errorScreen({String text = '', textTap = '', onTap}) {
    final focusNotifier = Provider.of<FocusNotifier>(context);
    bool _focusModeOn = (focusNotifier.getFocus() == true);
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Spacer(),
          _focusModeOn
              ? Column(
                  children: [
                    _buildGreetingAndQuestionColumn(),
                    SizedBox(height: 10),
                    HomeErrorMessage(text: text, textTap: textTap, onTap: onTap)
                  ],
                )
              : _buildMantraStream(),
          Spacer(),
        ],
      ),
    );
  }

  ///mantra stream
  StreamBuilder<List<MantraModel>> _buildMantraStream() {
    final database = Provider.of<Database>(context, listen: false);
    //because we will pop back after change setting, so it will update
    final mantraNotifier = Provider.of<MantraNotifier>(context, listen: false);
    bool _useMyMantra = mantraNotifier.getMantra();
    return StreamBuilder<List<MantraModel>>(
      stream: database.mantrasStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<MantraModel> mantras = snapshot.data;
          if (mantras.isNotEmpty) {
            if (_useMyMantra == true) {
              return _mantraCarousel(mantras, database);
            } else {
              return getDefaultMantra;
            }
          } else {
            return getDefaultMantra;
          }
        } else if (snapshot.hasError) {
          return getDefaultMantra;
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  ShowUp _mantraCarousel(List<MantraModel> mantras, Database database) {
    return ShowUp(
      delay: 500,
      child: CarouselSlider(
        options: CarouselOptions(
          height:
              120.0, //if we don't give it a height, it will set as default height which is higher
          viewportFraction: 1,
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
      ),
    );
  }

  Widget get getDefaultMantra {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ShowUp(
        delay: 500,
        child: Text(
          _defaultMantra, //SecondGreetings().showGreetings().body
          textAlign: TextAlign.center,
          style: KHomeGreeting,
        ),
      ),
    );
  }

  ///quote stream
  StreamBuilder<List<QuoteModel>> _buildQuoteStream() {
    final database = Provider.of<Database>(context, listen: false);
    final quoteNotifier = Provider.of<QuoteNotifier>(context, listen: false);
    bool _useMyQuote = quoteNotifier.getQuote();
    return StreamBuilder<List<QuoteModel>>(
      stream: database.quotesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<QuoteModel> quotes = snapshot.data;
          if (quotes.isNotEmpty) {
            if (_useMyQuote == true) {
              return _quoteCarousel(quotes, database);
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

  CarouselSlider _quoteCarousel(List<QuoteModel> quotes, Database database) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 50.0,
        viewportFraction: 1,
      ),
      items: quotes.map((quote) {
        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () => _onTapQuote(database, quote),
              child: Center(
                child: QuoteUI(
                  title: quote.title,
                  author: quote.author,
                  key: GlobalKey(),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  ///all function on task:
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

  void _onSubmitted(newText) async {
    final database = Provider.of<Database>(context, listen: false);
    if (newText.isNotEmpty) {
      FocusScope.of(context).unfocus();
      try {
        final todo = Todo(
          id: documentIdFromCurrentDate(),
          title: newText,
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

  void _onSubmittedTomorrow(newText) async {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final database = Provider.of<Database>(context, listen: false);
    if (newText.isNotEmpty) {
      FocusScope.of(context).unfocus();
      try {
        final todo = Todo(
          id: documentIdFromCurrentDate(),
          title: newText,
          date: tomorrow,
          isDone: false,
          category: 0,
          hasReminder: false,
        );
        await database.setTodo(todo);
        setState(() {
          _questionVisible = false;
        });
        _showGoodNightFlushBar();
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  void _showGoodNightFlushBar() {
    _showNoActionFlushbar(
        icon: EvaIcons.moon,
        title: 'Task has been added to calendar.',
        subtitle: 'Have a good evening.');
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
    await _showDeleteFlushbar(database, todo);
  }

  Future<void> _onChangedCheckbox(
      newValue, Database database, Todo todo) async {
    setState(() {
      _quoteOpacity = 0.0;
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
    _showNoActionFlushbar(
        icon: Icons.check, title: _congrats, subtitle: todo.title);
  }

  /// update & at the same time update _selectedList
  void _onTapTodo(Database database, Todo todo) async {
    setState(() {
      _wholeBodyOpacity = 0.0;
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
        //we get the id from job in the firebase, if the job.id is null, we create a new one, otherwise we use the existing job.id
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
      _wholeBodyOpacity = 1.0;
    });
  }

  void _onTapMantra(Database database, MantraModel mantra) async {
    setState(() {
      _wholeBodyOpacity = 0.0;
    });
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => AddMantraScreen(
              database: database,
              mantra: mantra,
            ));
    setState(() {
      _wholeBodyOpacity = 1.0;
    });
  }

  void _onTapQuote(Database database, QuoteModel quote) async {
    setState(() {
      _wholeBodyOpacity = 0.0;
    });
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => AddQuoteScreen(
              database: database,
              quote: quote,
            ));
    setState(() {
      _wholeBodyOpacity = 1.0;
    });
  }

  /// first Greetings
  get getFirstGreetings {
    final User user = FirebaseAuth.instance.currentUser;
    // user.reload();
    // String userName;
    if (user.displayName != null && user.displayName.isNotEmpty) {
      // user.displayName.contains(' ')
      //     ? userName = user.displayName
      //         .substring(0, user.displayName.indexOf(' '))
      //         .firstCaps
      //     :
      final userName = user.displayName.firstCaps;
      if (userName.length < 5) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///AutoSizeText not useful here
                Text('${FirstGreetings().showGreetings()}, ',
                    style: KHomeGreeting),
                Showcase(
                    key: _third,
                    description: Strings.third,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: name(userName)),
              ],
            ),
            nameTextField()
          ],
        );
      } else if (userName.length > 4) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${FirstGreetings().showGreetings()}',
                style: KHomeGreeting, textAlign: TextAlign.center),
            Visibility(
              visible: _nameVisible,
              child: GestureDetector(
                onTap: _onTapName,
                child: Text(
                  '$userName',
                  style: KHomeGreeting,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            nameTextField()
          ],
        );
      }
    }
    // if (user.displayName == null || user.displayName.isEmpty)
    else {
      return Text('${FirstGreetings().showGreetings()}', style: KHomeGreeting);
    }
  }

  Visibility name(String userName) {
    return Visibility(
      visible: _nameVisible,
      child: GestureDetector(
        onTap: _onTapName,
        child: Text(
          '$userName',
          style: KHomeGreeting,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Visibility nameTextField() {
    return Visibility(
      visible: !_nameVisible,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HomeTextField(
            onSubmitted: _editName,
            width: 200,
            max: 20,
            autofocus: true,
          ),
          InkWell(
              onTap: _onTapName,
              child: Icon(Icons.clear, color: darkThemeHint2))
        ],
      ),
    );
  }

  void _onTapName() {
    setState(() {
      _nameVisible = !_nameVisible;
    });
  }

  void _editName(String value) async {
    final FirebaseAuthService auth =
        Provider.of<FirebaseAuthService>(context, listen: false);
    final ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
    );
    _progressDialogStyle(pr);
    await pr.show();
    await auth.updateUserName(value);
    await pr.hide();
    setState(() {
      _nameVisible = !_nameVisible;
    });
  }

  void _progressDialogStyle(ProgressDialog pr) {
    return pr.style(
      message: 'Please wait',
      borderRadius: 20.0,
      backgroundColor: darkThemeNoPhotoColor,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      progressWidgetAlignment: Alignment.center,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
  }

  Future<Flushbar> _showNoActionFlushbar({icon, title, subtitle}) async {
    return Flushbar(
      isDismissible: true,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(8),
      borderRadius: 15,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundGradient: KFlushBarGradient,
      duration: Duration(seconds: 3),
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      titleText: Text(title, style: KFlushBarTitle),
      messageText: Text(subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: KFlushBarMessage),
    )..show(context).then((value) => setState(() {
          _quoteOpacity = 1.0;
        }));
  }

  Future<Flushbar> _showDeleteFlushbar(Database database, Todo todo) async {
    return Flushbar(
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
            // Navigator.pop(context);
          },
          child: FlushBarButtonChild(title: 'UNDO')),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(8),
      borderRadius: 15,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundGradient: KFlushBarGradient,
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
          _quoteOpacity = 1.0;
        }));
  }
}

///this code getUserName will not run in initState when coming to home screen from sign in
// String userName;
// void getUserName() {
//   final User user = FirebaseAuth.instance.currentUser;
//   String userName;
//   if (user.displayName != null && user.displayName.isNotEmpty) {
//     // user.displayName.contains(' ')
//     //     ? userName = user.displayName
//     //         .substring(0, user.displayName.indexOf(' '))
//     //         .firstCaps
//     //     :
//     userName = user.displayName.firstCaps;
//     print('userName in home screen initState: $userName');
//   }
// }
