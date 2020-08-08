import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/common_widgets/shared_axis.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/data/congrats_list.dart';
import 'package:iMomentum/app/models/data/mantras_list.dart';
import 'package:iMomentum/app/models/mantra_model.dart';
import 'package:iMomentum/app/models/quote_model.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/services/auth.dart';
import 'package:iMomentum/app/services/network_service/quote_service/fetch_quote.dart';
import 'package:iMomentum/app/services/network_service/weather_service/weather.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/home_drawer/add_mantra.dart';
import 'package:iMomentum/screens/home_drawer/add_quote.dart';
import 'package:iMomentum/screens/home_screen/home_top_bar.dart';
import 'package:iMomentum/app/common_widgets/my_list_tile.dart';
import 'package:iMomentum/screens/iPomodoro/clock_begin_screen.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/screens/todo_screen/add_todo_screen.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import '../../app/common_widgets/my_text_field.dart';
import 'daily_quote.dart';
import 'package:flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedAxisTransitionType _transitionType = SharedAxisTransitionType.scaled;

  void _focusButton(Database database, Todo todo) {
    final route = SharedAxisPageRoute(
        page: ClockBeginScreen(database: database, todo: todo),
        transitionType: _transitionType);
    Navigator.of(context).push(route);

//    Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
//      builder: (context) => ,
//      fullscreenDialog: true,
//    ));
  }

  int temperature;
  String cityName;
  String weatherIcon;
  String dailyQuote;
  String author;

//  final String formattedTime = DateFormat('kk:mm').format(DateTime.now());
  final String dayOfWeek = DateFormat.E().format(DateTime.now());
  final String formattedDate = DateFormat.MMMd().format(DateTime.now());
  String _secondGreetings;
  String _focusAnswer = '';

  @override
  void initState() {
    super.initState();
//    image = widget.images[0];
//    fetchImage();
    fetchWeather();
    fetchQuote();
    _secondGreetings = MantraOriginalList().showMantra().body;
  }

//  void getRandomOn() async {
//    final prefs = await SharedPreferences.getInstance();
//  }

//  UnsplashImage image;

//  Future<void> fetchImage() async {
//    image = await UnsplashImageProvider.loadImagesRandom();
//    print('loaded');
//  }

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

  Future<void> _handleRefresh() async {
    int counter = 0;
    fetchWeather();
    fetchQuote();
    setState(() {
      ImageUrl.randomImageUrl =
          'https://source.unsplash.com/random?nature/$counter';
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
              child: LiquidPullToRefresh(
                onRefresh: _handleRefresh,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: _weatherVisible,
                      child: HomeTopBar(
                          weatherIcon: weatherIcon,
                          temperature: temperature,
                          cityName: cityName),
                    ),
                    _buildStream(context), //removed Expanded
                    Visibility(
                      visible: _quoteVisible,
                      child: Container(
//                      color: Colors.purpleAccent,
                          child: _buildQuoteStream(context)),
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

  bool _weatherVisible = true;

  void fetchWeather() async {
    var weatherData = await WeatherModel().getLocationWeather();
    setState(() {
      if (weatherData == null) {
        _weatherVisible = false;
        return;
      }
      weatherIcon = weatherData['weather'][0]['icon'];
      temperature = weatherData['main']['temp'].toInt();
      cityName = weatherData['name'];
    });
  }

  //todo
  void fetchQuote() async {
    var quote = await FetchQuote().fetchQuote();
    setState(() {
      if (quote == null) {
        dailyQuote =
            'Always do your best. What you plant now, you will harvest later.';
        return;
      }
      dailyQuote = quote;
    });
  }

  //add new todo
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

  Future<void> _delete(BuildContext context, Todo todo) async {
//    setState(() {
//      _quoteVisible = !_quoteVisible;
//    });

    final database = Provider.of<Database>(context, listen: false);
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
        onPressed: () {
          database.setTodo(todo);
        },
        child: Text(
          "UNDO",
          style: TextStyle(color: Colors.white),
        ),
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(left: 10),
      borderRadius: 10,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundGradient: LinearGradient(colors: [
        Color(0xF0888888).withOpacity(0.85),
        Colors.black54,
      ]),
      duration: Duration(seconds: 3),
      titleText: Text(
        'Deleted',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            color: Colors.white,
            fontFamily: "ShadowsIntoLightTwo"),
      ),
      messageText: Text(
        todo.title,
        style: TextStyle(
            fontSize: 12.0,
            color: Colors.white,
            fontFamily: "ShadowsIntoLightTwo"),
      ),
    )..show(context
//        myGlobals.scaffoldKey.currentContext,
        );

    ///removed this, then when we delete on homeScreen, todo screen also deleted
//        .then((value) => setState(() {
//              _quoteVisible = !_quoteVisible;
//            }));
  }

  final String _congrats = CongratsList().getCongrats().body;

  bool _middleColumnVisible = true;
  bool _quoteVisible = true;

  Future<void> _onChangedCheckbox(
      newValue, BuildContext context, Todo todo) async {
    setState(() {
      _quoteVisible = !_quoteVisible;
    });

    try {
      final database = Provider.of<Database>(context, listen: false);
      todo.isDone = true;
      await database.updateTodo(todo);
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
      borderRadius: 10,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundGradient: LinearGradient(colors: [
        Color(0xF0a2de96).withOpacity(0.85),
        Color(0xF03ca59d).withOpacity(0.85)
      ]),
      duration: Duration(seconds: 2),
      icon: Icon(
        Icons.check,
        color: Colors.white,
      ),
      titleText: Text(
        _congrats,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
            color: Colors.white,
            fontFamily: "ShadowsIntoLightTwo"),
      ),
      messageText: Text(
        todo.title,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.white,
            fontFamily: "ShadowsIntoLightTwo"),
      ),
    ).show(context).then((value) => setState(() {
          _quoteVisible = !_quoteVisible;
        }));
  }

  DateTime _date = DateTime.now();

  /// update & at the same time update _selectedList
  void _onTapTodo(Database database, Todo todo) async {
    setState(() {
      _middleColumnVisible = false;
      _quoteVisible = false;
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

        ///first we find this specific Todo item that we want to update
        final newTodo = Todo(
            id: id,
            title: _typedTitleAndComment[0],
            comment: _typedTitleAndComment[1],
            date: _typedTitleAndComment[2],
            isDone: isDone,
            category: _typedTitleAndComment[3]);
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
      _quoteVisible = true;
    });
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

  Widget _buildStream(BuildContext context) {
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
                      Column(
                        children: <Widget>[
                          Container(
//                            color: Colors.purpleAccent,
                              child: _buildMantraStream(context)),
                          Visibility(
                            visible: _focusModeOn ? true : false,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 50), //space between mantra
                                Container(
//                                color: Colors.orangeAccent,
                                  child: CarouselSlider(
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
                                              Container(
//                                                    color: Colors.blue,
                                                child: Center(
                                                  child: Slidable(
                                                    key: UniqueKey(),
                                                    closeOnScroll: true,
                                                    actionPane:
                                                        SlidableDrawerActionPane(),
                                                    dismissal:
                                                        SlidableDismissal(
                                                      child:
                                                          SlidableDrawerDismissal(),
                                                      onDismissed:
                                                          (actionType) {
                                                        _delete(context, todo);
                                                      },
                                                    ),
                                                    actionExtentRatio: 0.25,
                                                    secondaryActions: <Widget>[
                                                      IconSlideAction(
                                                        caption: 'Delete',
                                                        color: Colors.black12,
                                                        iconWidget: FaIcon(
                                                          FontAwesomeIcons
                                                              .trashAlt,
                                                          color: Colors.white,
                                                        ),
                                                        onTap: () => _delete(
                                                            context, todo),
                                                      ),
                                                    ],
                                                    child: HomeTodoListTile(
                                                      todo: todo,
                                                      onChangedCheckbox:
                                                          (newValue) =>
                                                              _onChangedCheckbox(
                                                                  newValue,
                                                                  context,
                                                                  todo),
                                                      onTap: () => _onTapTodo(
                                                          database,
//                                                      todayTodosNotDone,
                                                          todo),
                                                      onPressed: () =>
                                                          _onTapTodo(
                                                              database,
//                                                      todayTodosNotDone,
                                                              todo),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                child: MyFlatButton(
                                                  color: Colors.white,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  onPressed: () => _focusButton(
                                                      database, todo),
                                                  text: 'Focus Mode',
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                      Spacer()
                    ],
                  ),
                ),
              );
            } else {
              return _questionScreen();
            }
          } else {
            return _questionScreen();
          }
        } else if (snapshot.hasError) {
          return _questionScreen();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _questionScreen() {
    final User user = Provider.of<User>(context, listen: false);

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
                    Column(
                      children: <Widget>[
//                        SizedBox(height: 50),
                        _buildMantraStream(context),
                      ],
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
                  Column(
                    children: <Widget>[
                      Container(
//                        color: Colors.purple,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: AutoSizeText(
                            user.displayName == null
                                ? '${FirstGreetings().showGreetings()}'
                                : '${FirstGreetings().showGreetings()}, ${user.displayName.substring(0, user.displayName.indexOf(' '))}',
                            maxLines: 2,
                            maxFontSize: 35,
                            minFontSize: 30,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 35.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ), //first greetings
                      SizedBox(height: 100),
                      Container(
//                        color: Colors.lightBlueAccent,
                        child: Column(
                          children: <Widget>[
                            getFormattedDate, //30
                            SizedBox(height: 20),
                            getQuestion(), //33
                            HomeTextField(
                                onSubmitted: _onSubmitted), //FocusQuestion
                            //Today
                          ],
                        ),
                      ),
                    ],
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

  ///mantra stream
  Widget _buildMantraStream(BuildContext context) {
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
      _quoteVisible = false;
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
      _quoteVisible = true;
      _middleColumnVisible = true;
    });
  }

  ///quote stream
  Widget _buildQuoteStream(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    //for quote
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
//                  initialPage: quotes.length - 1,
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
              return DailyQuote(title: dailyQuote, author: author);
            }
          } else {
            return DailyQuote(title: dailyQuote, author: author);
          }
        } else if (snapshot.hasError) {
          return DailyQuote(title: dailyQuote, author: author);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void _onTapQuote(Database database, QuoteModel quote) async {
    setState(() {
      _middleColumnVisible = false;
      _quoteVisible = false;
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
      _quoteVisible = true;
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

//  Widget getFirstGreeting(BuildContext context) {
//    final user = Provider.of<User>(context, listen: false);
//    return SizedBox(
//      height: 80,
//      child: Column(
//        children: <Widget>[
//          FadeAnimatedTextKit(
//              totalRepeatCount: 1,
//              isRepeatingAnimation: false,
//              duration: Duration(seconds: 3),
//              text: ['${FirstGreetings().showGreetings()},'],
//              textAlign: TextAlign.center,
//              textStyle: TextStyle(
//                  fontSize: 35.0,
//                  color: Colors.white,
//                  fontWeight: FontWeight.bold),
//              alignment: AlignmentDirectional.topStart),
//          FadeAnimatedTextKit(
//              totalRepeatCount: 1,
//              isRepeatingAnimation: false,
//              duration: Duration(seconds: 3),
//              text: ['${user.displayName}'],
//              textAlign: TextAlign.center,
//              textStyle: TextStyle(
//                  fontSize: 30.0,
//                  color: Colors.white,
//                  fontWeight: FontWeight.bold),
//              alignment: AlignmentDirectional.topStart)
//        ],
//      ),
//    );
//  }

  Widget get getSecondGreetings {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        _secondGreetings, //SecondGreetings().showGreetings().body
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 35.0, color: Colors.white, fontWeight: FontWeight.bold),
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
