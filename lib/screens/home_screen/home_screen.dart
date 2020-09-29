import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_text_field.dart';
import 'package:iMomentum/app/common_widgets/my_tooltip.dart';
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
import 'package:showcaseview/showcase_widget.dart';
import 'daily_quote.dart';
import 'package:flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:iMomentum/app/utils/extension_firstCaps.dart';
import 'dart:io' show Platform;

class HomeScreen extends StatefulWidget {
  static const PREFERENCES_IS_FIRST_LAUNCH_STRING =
      "HOME_IS_FIRST_LAUNCH_STRING";
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
    ///because we call fetch weather again after changing, so listen can be false
    final metricNotifier = Provider.of<MetricNotifier>(context, listen: false);
    bool _metricUnitOn = metricNotifier.getMetric();
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
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

  final String dayOfWeek = DateFormat.E().format(DateTime.now());
  final String formattedDate = DateFormat.MMMd().format(DateTime.now());
  final String _congrats = CongratsList().getCongrats().body;
  String _defaultMantra;

  bool _middleColumnVisible = true;

  /// change visible to opacity, otherwise, quote always updates.
  double _quoteOpacity = 1.0;

  DateTime _date = DateTime.now();

  @override
  void initState() {
    _defaultMantra = DefaultMantraList().showMantra().body;
    _fetchWeather();
    super.initState();
  }

  ///this code will not sun when coming to home screen from sign in
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
  //
  //     userName = user.displayName.firstCaps;
  //
  //     print('userName in home screen initState: $userName');
  //   }
  // }

  int counter = 0;
  void _onDoubleTap() {
    setState(() {
      ImageUrl.randomImageUrl = '${ImageUrl.randomImageUrlFirstPart}$counter';
      counter++;
    });
  }

  ///notes on showcase view
  GlobalKey _oneShowcase = GlobalKey();
  GlobalKey _twoShowcase = GlobalKey();
  GlobalKey _threeShowcase = GlobalKey();

  Future<bool> _isFirstLaunch() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    bool isFirstLaunch = sharedPreferences
            .getBool(HomeScreen.PREFERENCES_IS_FIRST_LAUNCH_STRING) ??
        true;

    if (isFirstLaunch)
      sharedPreferences.setBool(
          HomeScreen.PREFERENCES_IS_FIRST_LAUNCH_STRING, false);

    print('$isFirstLaunch');
    return isFirstLaunch;
  }

  @override
  Widget build(BuildContext context) {
    /// add showcase only if first launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isFirstLaunch().then((result) {
        print('First Launch: $result');
        if (result)
          ShowCaseWidget.of(context)
              .startShowCase([_oneShowcase, _twoShowcase, _threeShowcase]);
      });
    });

    /// in homepage this can not have listen to false (same as HomeDrawer) otherwise the screen photo
    /// not immediately updates, but in other screen it can have listen to false
    /// because it only need to get the value when we fist come to the page.
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
              _randomOn ? ImageUrl.randomImageUrl : imageNotifier.getImage(),
        ),
        ContainerLinearGradient(),
        GestureDetector(
          onDoubleTap: _onDoubleTap,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                        opacity: _topBarOpacity,
                        child: _topBar()), //for weather
                    Visibility(
                        visible: _middleColumnVisible,
                        child: _middleContent()), //Expanded
                    isKeyboardVisible
                        ? Container()
                        : Opacity(
                            opacity: _quoteOpacity,
                            child: _buildQuoteStream(),
                          ),
                  ],
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
      ? contentFinishedDownload()
      : _state == CurrentWeatherState.DOWNLOADING
          ? Center(child: CircularProgressIndicator(strokeWidth: 5))
          : Container();
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

  Widget contentFinishedDownload() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    ///because we call fetch weather again after changing, so listen can be false
    final metricNotifier = Provider.of<MetricNotifier>(context, listen: false);
    bool _metricUnitOn = metricNotifier.getMetric();
    return Column(
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
              color: _darkTheme ? darkThemeWords : lightThemeWords,
              fontSize: 15.0),
        ),
      ],
    );
  }

  /// middle content
  int _current = 0; // for the dot
  Widget _middleContent() {
    final database = Provider.of<Database>(context, listen: false);

    ///we can not set this to listen: false, otherwise the screen will not update immediately
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
              return Expanded(
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
                                SizedBox(
                                    height:
                                        50), //space between mantra and Today's Todos
                                _buildTaskCarouselSlider(
                                    database, todayTodosNotDone),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer()
                  ],
                ),
              );
            } else {
              return _emptyListScreen(); //if todayTodosNotDone is empty
            }
          } else {
            return _emptyListScreen(); // if todos is empty
          }
        } else if (snapshot.hasError) {
          ///Todo: onTap contact us
          return _errorScreen(
              text: Strings.textError, textTap: 'Or contact us'); //if error
        }
        return Center(child: CircularProgressIndicator());
      },
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

  Widget _buildTaskCarouselSlider(
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
                      message:
                          'This button takes you to Pomodoro Timer Screen.',
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
        _sliderDot(todayTodosNotDone),
      ],
    );
  }

  Widget _sliderDot(List list) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list.length < 11
            ? list.map((todo) {
                int index = list.indexOf(todo);
                return list.length > 1
                    ? MyDotContainer(
                        color:
                            _current == index ? Colors.white70 : Colors.white38)
                    : Container();
              }).toList()
            : list.take(10).map((todo) {
                int index = list.indexOf(todo);
                return list.length > 1
                    ? MyDotContainer(
                        color:
                            _current == index ? Colors.white70 : Colors.white38)
                    : Container();
              }).toList());
  }

  /// middle content Question, this means if there is no data from TodoStream, then we display question.
  Widget _emptyListScreen() {
    final focusNotifier = Provider.of<FocusNotifier>(context);
    bool _focusModeOn = (focusNotifier.getFocus() == true);

    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    return _focusModeOn
        ? Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Spacer(),
                Opacity(
                  opacity: _mantraOpacity,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: getFirstGreetings,
                      ), //first greetings
                      isKeyboardVisible
                          ? SizedBox(height: 20)
                          : SizedBox(height: Platform.isIOS ? 70 : 50),
                      Visibility(
                          visible: _nameVisible, child: questionColumn()),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          )
        : Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Spacer(),
                Opacity(
                  opacity: _mantraOpacity,
                  child: _buildMantraStream(),
                ),
                Spacer(),
              ],
            ),
          );
  }

  bool _questionVisible = true;
  Column questionColumn() {
    return Column(
      children: <Widget>[
        Text('$dayOfWeek, $formattedDate ', style: KHomeDate),
        SizedBox(height: 15),
        Column(
          children: [
            buildQuestion(), //33
            buildHomeTextField(),
          ],
        ),
        Visibility(
          visible: !_questionVisible,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ShowUp(
              child: Text('Have a good night sleep.', style: KHomeQuestion2),
            ),
          ),
        )
      ],
    );
  }

  Widget buildQuestion() {
    final int hour = int.parse(DateFormat('kk').format(DateTime.now()));
    print(hour);

    if ((hour >= 6) & (hour < 21)) {
      return TypewriterAnimatedTextKit(
        isRepeatingAnimation: false,
        text: ['What is your main focus today?'],
        textAlign: TextAlign.center,
        textStyle: KHomeQuestion,
      );
    } //8pm
    else if ((hour >= 21) & (hour < 23)) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TypewriterAnimatedTextKit(
          isRepeatingAnimation: false,
          text: ['What is your plan tomorrow?'],
          textAlign: TextAlign.center,
          textStyle: KHomeQuestion,
        ),
      );
    } else
      return Visibility(
        visible:
            _questionVisible, //after submit, this becomes false, and we have question that already shows good night
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ShowUp(
            child: Text('Have a good night sleep.', style: KHomeQuestion2),
          ),
        ),
      );
  }

  Widget buildHomeTextField() {
    final int hour = int.parse(DateFormat('kk').format(DateTime.now()));

    if ((hour >= 6) & (hour < 21)) {
      return HomeTextField(onSubmitted: _onSubmitted);
    } //8pm
    else if ((hour >= 21) & (hour < 23)) {
      return Visibility(
          visible: _questionVisible,
          child: HomeTextField(onSubmitted: _onSubmittedTomorrow));
    } else
      return Container();
  }

  Widget _errorScreen({String text = '', textTap = '', onTap}) {
    final focusNotifier = Provider.of<FocusNotifier>(context);
    bool _focusModeOn = (focusNotifier.getFocus() == true);

    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    return _focusModeOn
        ? Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Spacer(),
                Opacity(
                  opacity: _mantraOpacity,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: getFirstGreetings,
                      ), //first greetings
                      isKeyboardVisible
                          ? SizedBox(height: 20)
                          : SizedBox(height: Platform.isIOS ? 70 : 50),
                      Column(
                        children: <Widget>[
                          questionColumn(),
                          SizedBox(height: 10),
                          errorMessage(_darkTheme, text, textTap,
                              onTap) // default is empty, but if error, we show error message
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          )
        : Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Spacer(),
                Opacity(
                  opacity: _mantraOpacity,
                  child: _buildMantraStream(),
                ),
                Spacer(),
              ],
            ),
          );
  }

  MyContainerWithDarkMode errorMessage(
      bool _darkTheme, String text, textTap, onTap) {
    return MyContainerWithDarkMode(
        child: RichText(
      text: TextSpan(
        style: TextStyle(
            color: _darkTheme
                ? darkThemeWords.withOpacity(0.85)
                : lightThemeWords.withOpacity(0.85),
            fontStyle: FontStyle.italic,
            fontSize: 16),
        children: [
          TextSpan(
            text: text,
          ),
          TextSpan(
            text: textTap,
            recognizer: TapGestureRecognizer()..onTap = onTap,
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: _darkTheme
                    ? darkThemeWords.withOpacity(0.85)
                    : lightThemeWords.withOpacity(0.85),
                fontStyle: FontStyle.italic,
                fontSize: 16),
          ),
        ],
      ),
    ));
  }

  ///mantra stream
  Widget _buildMantraStream() {
    final database = Provider.of<Database>(context, listen: false);
    //for mantra
    ///because we will pop back, so it will update
    final mantraNotifier = Provider.of<MantraNotifier>(context, listen: false);
    bool _useMyMantra = mantraNotifier.getMantra();
    return StreamBuilder<List<MantraModel>>(
      stream: database.mantrasStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<MantraModel> mantras = snapshot.data;
          if (mantras.isNotEmpty) {
            if (_useMyMantra == true) {
//              final mantra = mantras[mantras.length - 1]; //changed to CarouselSlider
              return Column(
                children: [
                  ShowUp(
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
                  ),
                  _sliderDot(mantras),
                ],
              );
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

  ///quote stream
  Widget _buildQuoteStream() {
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
              return Column(
                children: [
                  CarouselSlider(
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
                              child: DailyQuote(
                                  title: quote.title,
                                  author: quote.author,
                                  bottomPadding: _useMyQuote ? 0 : 15),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  _sliderDot(quotes),
                ],
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

  ///all function on task:
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
    Flushbar(
      isDismissible: true,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(8),
      borderRadius: 15,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundGradient: KFlushBarGradient,
      duration: Duration(seconds: 3),
      icon: Icon(
        EvaIcons.moon,
        color: Colors.white,
      ),
      titleText:
          Text('Task has been added to calendar.', style: KFlushBarTitle),
      messageText: Text('Have a good evening.',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: KFlushBarMessage),
    )..show(context);
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

    Flushbar(
      isDismissible: true,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(8),
      borderRadius: 15,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundGradient: KFlushBarGradient,
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
          _quoteOpacity = 1.0;
        }));
  }

  /// update & at the same time update _selectedList
  void _onTapTodo(Database database, Todo todo) async {
    setState(() {
      _middleColumnVisible = false;
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
      _quoteOpacity = 1.0;
    });
  }

  void _onTapMantra(Database database, MantraModel mantra) async {
    setState(() {
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
      _quoteOpacity = 1.0;
      _middleColumnVisible = true;
    });
  }

  void _onTapQuote(Database database, QuoteModel quote) async {
    setState(() {
      _middleColumnVisible = false;
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
      _quoteOpacity = 1.0;
    });
  }

  /// first Greetings
  bool _nameVisible = true;

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

      print('userName in home screen: $userName');

      if (userName.length < 6) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///AutoSizeText not useful here
                Text('${FirstGreetings().showGreetings()}',
                    style: KHomeGreeting),
                name(userName),
              ],
            ),
            nameTextField()
          ],
        );
      } else if (userName.length > 6) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${FirstGreetings().showGreetings()}',
                style: KHomeGreeting, textAlign: TextAlign.center),
            Visibility(
              visible: _nameVisible,
              child: GestureDetector(
                onTap: _onTapName,
                child: AutoSizeText(
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
        child: AutoSizeText(
          ', $userName',
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
    //from ProgressDialog plugin
    final ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      // textDirection: TextDirection.rtl,
      isDismissible: true,
    );
    pr.style(
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

    await pr.show();

    await auth.updateUserName(value);

    ///because it takes a while to update name
    await pr.hide();

    setState(() {
      _nameVisible = !_nameVisible;
    });
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
}
