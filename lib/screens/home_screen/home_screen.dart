import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_stack_screen.dart';
import 'package:iMomentum/app/common_widgets/my_text_field.dart';
import 'package:iMomentum/app/common_widgets/my_tooltip.dart';
import 'package:iMomentum/app/common_widgets/my_sizedbox.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
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
  double _wholeBodyOpacity =
      1.0; //used when edit or show top sheet, used with _visibleWhenEdit
  bool _nameVisible = true; //used when edit name
  bool _questionVisible =
      true; //used when changing question from main to tomorro
  bool _visibleWhenEdit =
      true; ////to prevent not enough space when keyboard is up when edit

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
          _fetchWeather(); //call again to refresh the weather on home screen, this is useful when user changed metric
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

  Widget _getWeatherIconImage(String weatherIcon, {double size = 18}) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    if (weatherIcon == '01n') {
      return Icon(EvaIcons.moonOutline,
          color: _darkTheme ? darkThemeWords : lightThemeWords, size: size);
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
  DateTime _date = DateTime.now(); //this is default date when adding a task

  @override
  void initState() {
    _defaultMantra = DefaultMantraList().showMantra().body;
    _fetchWeather();
    final startHourNotifier =
        Provider.of<StartHourNotifier>(context, listen: false);
    startHour = startHourNotifier.getStartHour();
    final endHourNotifier =
        Provider.of<EndHourNotifier>(context, listen: false);
    endHour = endHourNotifier.getEndHour();
    finalEndHour = endHour + 12;
    final balanceNotifier =
        Provider.of<BalanceNotifier>(context, listen: false);
    isBalance = balanceNotifier.getBalance();
    // final weekdayNotifier =
    //     Provider.of<WeekDayNotifier>(context, listen: false);
    // isWeekDay = weekdayNotifier.getWeekDay();
    super.initState();
  }

  ///notes on showcase view
  BuildContext myContext;
  GlobalKey _first = GlobalKey();
  GlobalKey _second = GlobalKey();
  GlobalKey _third = GlobalKey();
  GlobalKey _fourth = GlobalKey();
  GlobalKey _fifth = GlobalKey();

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
        // // print('first');
        // if (!mounted) return; //not making any difference
        // // print('second');
        if (result)
          ShowCaseWidget.of(myContext)
              .startShowCase([_first, _second, _third, _fourth, _fifth]);
      });
    });
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);

    ///Dart Unhandled Exception: NoSuchMethodError: The method 'findAncestorStateOfType' was called on null.
    ///https://stackoverflow.com/questions/52130648/nosuchmethoderror-the-method-ancestorstateoftype-was-called-on-null
    ///https://stackoverflow.com/questions/49373774/inheritedwidget-with-scaffold-as-child-doesnt-seem-to-be-working
    ///https://stackoverflow.com/questions/60930636/how-can-i-use-show-case-view-in-flutter
    return ShowCaseWidget(builder: Builder(builder: (context) {
      myContext = context;
      return MyStackScreen(
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
      );
    }));
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(children: [
            SizedBox(
              // decoration: BoxDecoration(
              //     color: _darkTheme ? Colors.transparent : Colors.transparent,
              //     shape: BoxShape.circle),
              height: 25,
              width: 25,
              child: _getWeatherIconImage(weatherIcon),
            ),
            SizedBox(width: 3.0),
            Text(
              _metricUnitOn ? '$temperature°C' : '$temperature°F',
              style: textStyleWeatherText(_darkTheme),
            ),
          ]),
          Text(
            '$cityName',
            style: textStyleWeatherText(_darkTheme),
          ),
        ],
      ),
    );
  }

  TextStyle textStyleWeatherText(bool _darkTheme) {
    return TextStyle(
        color: _darkTheme ? darkThemeWords : Colors.black, fontSize: 15.0);
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
              return _emptyListQuestionContent(); //Expanded //if todayTodosNotDone is empty
            }
          } else {
            return _emptyListQuestionContent(); //Expanded //if todos is empty
          }
        } else if (snapshot.hasError) {
          ///Todo: onTap contact us
          return _errorScreen(
              text: Strings.streamErrorMessage,
              textTap: ''); //Expanded //if error
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
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Visibility(
              visible:
                  _visibleWhenEdit, //add this to prevent keyboard pop up and no space
              child: Column(
                children: <Widget>[
                  MyHomeSecondSpaceSizedBox(),
                  // Spacer(flex: _focusModeOn ? 2 : 1), //can not have this
                  _buildMantraStream(),
                  MyHomeMiddleSpaceSizedBox(), //space between mantra and Today's Todos
                  Visibility(
                    visible: _focusModeOn ? true : false,
                    child:
                        _buildTaskCarouselSlider(database, todayTodosNotDone),
                  ),
                  // Spacer()
                ],
              ),
            ),
          ),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: <Widget>[
            Spacer(),
            _focusModeOn ? _questionAndTextField() : _buildMantraStream(),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Column _questionAndTextField() {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    return Column(
      children: [
        Showcase(
          key: _fourth,
          description: Strings.fourth,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: isBalance
              ? _buildScheduledQuestion(isKeyboardVisible)
              : mainQuestionWhenTaskEmpty(isKeyboardVisible),
        ), //33
        Showcase(
            key: _fifth,
            description: Strings.fifth,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: isBalance
                ? _buildScheduledHomeTextField()
                : nameVisibilityHomeTextField(_onSubmitted)),
      ],
    );
  }

  int startHour;
  int endHour;
  int finalEndHour;
  bool isBalance;
  // bool isWeekDay; //not in use

  Widget _buildScheduledQuestion(bool isKeyboardVisible) {
    final int hour = int.parse(DateFormat('kk').format(DateTime.now()));
    // final int dayOfWeek = DateTime.now().weekday;
    // isWeekDay //if this is true
    // ? if ((dayOfWeek <= 5) & (dayOfWeek >= 0)) {
    if ((hour >= startHour) & (hour < finalEndHour)) {
      return mainQuestionWhenTaskEmpty(isKeyboardVisible);
    } //8pm
    else if ((hour >= finalEndHour) & (hour < finalEndHour + 3)) {
      return tomorrowQuestionWhenTaskEmpty(isKeyboardVisible);
    } else
      return _buildMantraStream();
  }

  Column mainQuestionWhenTaskEmpty(bool isKeyboardVisible) {
    return Column(
      children: [
        // when keyboard is up, we can not hide greeting otherwise we can't edit name
        greetingsAndSpace(isKeyboardVisible), //first greetings
        nameVisibilityMainQuestion(),
      ],
    );
  }

  Visibility tomorrowQuestionWhenTaskEmpty(bool isKeyboardVisible) {
    return Visibility(
      //after submitTomorrow,  _questionVisible is false;
      visible: _questionVisible,
      child: Column(
        children: [
          greetingsAndSpace(isKeyboardVisible), //first greetings
          nameVisibilityTomorrowQuestion(),
        ],
      ),
    );
  }

  Visibility nameVisibilityTomorrowQuestion() {
    return Visibility(
      visible: _nameVisible,
      child: Column(
        children: [
          Text('$dayOfWeek, $formattedDate ', style: KHomeDate),
          SizedBox(height: 15),
          TypewriterAnimatedTextKit(
            isRepeatingAnimation: false,
            text: ['What is your plan tomorrow?'],
            textAlign: TextAlign.center,
            textStyle: KHomeQuestion,
          ),
        ],
      ),
    );
  }

  Column greetingsAndSpace(bool isKeyboardVisible) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: getFirstGreetings,
        ),
        !isKeyboardVisible //this is to prevent no space when adding task
            ? MyHomeMiddleSpaceSizedBox()
            : SizedBox(height: 10),
      ],
    );
  }

  Visibility nameVisibilityMainQuestion() {
    return Visibility(
      visible: _nameVisible,
      child: Column(
        children: [
          Text('$dayOfWeek, $formattedDate ', style: KHomeDate),
          SizedBox(height: 15),
          TypewriterAnimatedTextKit(
            isRepeatingAnimation: false,
            text: ['What is your main focus today?'],
            textAlign: TextAlign.center,
            textStyle: KHomeQuestion,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduledHomeTextField() {
    final int hour = int.parse(DateFormat('kk').format(DateTime.now()));
    if ((hour >= startHour) & (hour < finalEndHour)) {
      return nameVisibilityHomeTextField(_onSubmitted);
    } //8pm
    else if ((hour >= finalEndHour) & (hour < finalEndHour + 2)) {
      // 8pm-11pm
      return _questionVisible
          ? nameVisibilityHomeTextField(_onSubmittedTomorrow)
          : _buildMantraStream();
    } else //after 11pm, and on question will becomes good night
      return Container();
  }

  Visibility nameVisibilityHomeTextField(_onSubmitted) {
    return Visibility(
        visible: _nameVisible, child: HomeTextField(onSubmitted: _onSubmitted));
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
          Column(
            children: [
              _focusModeOn ? _questionAndTextField() : _buildMantraStream(),
              SizedBox(height: 10),
              HomeErrorMessage(text: text, textTap: textTap, onTap: onTap)
            ],
          ),
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
              130.0, //if we don't give it a height, it will set as default height which is higher
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

  int lengthLimit = 65;
  void getLengthLimit(double height) {
    if (height >= 850) {
      lengthLimit = 75;
    } else if ((height < 850) && (height > 700)) {
      lengthLimit = 70;
    } else if (height < 700) {
      lengthLimit = 65;
    }
  }

  CarouselSlider _quoteCarousel(List<QuoteModel> quotes, Database database) {
    double height = MediaQuery.of(context).size.height;
    getLengthLimit(height);
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
                child: DailyQuoteUI(
                  lengthLimit: lengthLimit,
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
          _quoteOpacity = 0.0;
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
        subtitle: 'Have a good evening, .');
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
      _visibleWhenEdit =
          false; //to prevent not enough space when keyboard is up when edit
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
      _visibleWhenEdit = true;
    });
  }

  void _onTapMantra(Database database, MantraModel mantra) async {
    setState(() {
      _wholeBodyOpacity = 0.0;
      _visibleWhenEdit = false;
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
      _visibleWhenEdit = true;
    });
  }

  void _onTapQuote(Database database, QuoteModel quote) async {
    setState(() {
      _wholeBodyOpacity = 0.0;
      _visibleWhenEdit = false;
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
      _visibleWhenEdit = true;
    });
  }

  String getUserFirstName(User user) {
    String userFirstName;
    if (user.displayName != null && user.displayName.isNotEmpty) {
      user.displayName.contains(' ')
          ? userFirstName = user.displayName
              .substring(0, user.displayName.indexOf(' '))
              .firstCaps
          : userFirstName = user.displayName.firstCaps;
    }
    return userFirstName;
  }

  int nameLengthLimit;
  void getNameLengthLimit(double width) {
    if (width >= 410) {
      nameLengthLimit = 12;
    } else if ((width >= 390) && (width < 410)) {
      nameLengthLimit = 9;
    } else if (width < 390) {
      nameLengthLimit = 6;
    }
  }

  /// first Greetings
  get getFirstGreetings {
    final User user = FirebaseAuth.instance.currentUser;
    double width = MediaQuery.of(context).size.width;
    getNameLengthLimit(width);

    // user.reload();
    // String userName;
    if (user.displayName != null && user.displayName.isNotEmpty) {
      // user.displayName.contains(' ')
      //     ? userName = user.displayName
      //         .substring(0, user.displayName.indexOf(' '))
      //         .firstCaps
      //     :
      final userName = user.displayName.firstCaps;
      if (userName.length < nameLengthLimit) {
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
                name(userName),
              ],
            ),
            nameTextField()
          ],
        );
      } else if (userName.length > nameLengthLimit - 1) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${FirstGreetings().showGreetings()}',
                style: KHomeGreeting, textAlign: TextAlign.center),
            name(userName),
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

  Showcase name(String userName) {
    return Showcase(
      key: _third,
      description: Strings.third,
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Visibility(
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
            max: 15,
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
      duration: Duration(seconds: 4),
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      titleText: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(title, style: KFlushBarTitle),
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(left: 3.0),
        child: Text(subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: KFlushBarMessage),
      ),
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
      duration: Duration(seconds: 4),
      icon: Icon(
        EvaIcons.trash2Outline,
        color: Colors.white,
      ),
      titleText: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(Strings.deleteTaskWarning, style: KFlushBarTitle),
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(left: 3.0),
        child: Text(todo.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: KFlushBarMessage),
      ),
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
