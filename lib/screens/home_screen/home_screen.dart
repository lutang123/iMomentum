import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iMomentum/app/common_widgets/linear_gradient_container.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/transparent_flat_button.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/data/greetings_list.dart';
import 'package:iMomentum/app/models/todo_model.dart';
import 'package:iMomentum/app/services/auth.dart';
import 'package:iMomentum/app/services/network_service/quote_service/fetch_quote.dart';
import 'package:iMomentum/app/services/network_service/weather_service/weather.dart';
import 'package:iMomentum/screens/home_screen/home_top_bar.dart';
import 'package:iMomentum/screens/home_screen/question_typewriter.dart';
import 'package:iMomentum/app/common_widgets/my_todo_list_tile.dart';
import 'package:iMomentum/screens/iPomodoro/clock_begin_screen.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/screens/iTodo/todo_screen/add_todo_screen.dart';
import 'package:iMomentum/screens/jobs/empty_content.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../app/common_widgets/my_text_field.dart';
import 'daily_quote.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int temperature;
  String cityName;
  String weatherIcon;
  String dailyQuote;
  String _focusAnswer;

//  final String formattedTime = DateFormat('kk:mm').format(DateTime.now());
  final String dayOfWeek = DateFormat.E().format(DateTime.now());
  final String formattedDate = DateFormat.MMMd().format(DateTime.now());
  String _secondGreetings;
  @override
  void initState() {
    super.initState();
    fetchWeather();
    fetchQuote();
    _secondGreetings = SecondGreetings().showGreetings().body;
  }

  void fetchWeather() async {
    var weatherData = await WeatherModel().getLocationWeather();
    setState(() {
      if (weatherData == null) {
        weatherIcon = '';
        temperature = 0;
        cityName = 'Unknown';
        return;
      }
      weatherIcon = weatherData['weather'][0]['icon'];
      temperature = weatherData['main']['temp'].toInt();
      cityName = weatherData['name'];
    });
  }

  void fetchQuote() async {
    var quote = await FetchQuote().fetchQuote();
    if (quote == null) {
      dailyQuote =
          '“Always do your best. What you plant now, you will harvest later.” --Og Mandino';
      return;
    }
    setState(() {
      dailyQuote = quote;
    });
  }

//  void _clear() {
//    setState(() {
//      _visibleQuestion = true;
//      _visibleAnswer = false;
//      _toggleCheckbox();
//      _toggleCongrats();
//    });
//    FocusScope.of(context).unfocus();
//  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.network(Constants.homePageImage, fit: BoxFit.cover),
        ContainerLinearGradient(),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HomeTopBar(
                      weatherIcon: weatherIcon,
                      temperature: temperature,
                      cityName: cityName),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStream(context),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: DailyQuote(dailyQuote: dailyQuote),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _focusButton(Database database, TodoModel todo) {
    Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
      builder: (context) => ClockBeginScreen(database: database, todo: todo),
      fullscreenDialog: true,
    ));
  }

  //add new todo
  void _onSubmitted(newText) async {
    final database = Provider.of<Database>(context, listen: false);
    if (newText.isNotEmpty) {
      setState(() {
        _focusAnswer = newText;
//        //change UI
//        _visibleQuestion = false;
//        _visibleAnswer = true;
      });
      FocusScope.of(context).unfocus();
      try {
//      final id = widget.todo?.id ?? documentIdFromCurrentDate();
        final todo = TodoModel(
          id: documentIdFromCurrentDate(),
          title: _focusAnswer,
          date: DateTime.now(),
          isDone: false,
        );
        await database.setTodo(todo);
//        TodoScreen().selectedList.add(todo);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  Future<void> _onChangedCheckbox(
      newValue, BuildContext context, TodoModel todo) async {
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
  }

  Future<void> _delete(BuildContext context, TodoModel todo) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteTodo(todo);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  /// update & at the same time update _selectedList
  void _onTap(Database database, TodoModel todo) async {
    var _typedTitle = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddTodoScreen(
        database: database,
        todo: todo,
//        onTap: _handleDatePicker,
        pickedDate: DateTime.now(),
      ),
    );

    if (_typedTitle != null) {
      try {
        //we get the id from job in the firebase, if the job.id is null,
        //we create a new one, otherwise we use the existing job.id
        final id = todo?.id ?? documentIdFromCurrentDate();
        final isDone = todo?.isDone ?? false;

        ///first we find this specific Todo item that we want to update
        final newTodo = TodoModel(
            id: id, title: _typedTitle, date: DateTime.now(), isDone: isDone);
        //add newTodo to database
        await database.setTodo(newTodo);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  List<TodoModel> _getTodayNotDone(List<TodoModel> todos) {
    List<TodoModel> todayTodos = [];
    todos.forEach((todo) {
      DateTime today = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      DateTime date = DateTime(todo.date.year, todo.date.month, todo.date.day);
      if ((date == today) && (todo.isDone == false)) {
        todayTodos.add(todo);
      }
    });
    return todayTodos;
  }

  Widget _buildStream(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<TodoModel>>(
      stream: database.todosStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<TodoModel> todos = snapshot.data;
          if (todos.isNotEmpty) {
            final todayTodosNotDone = _getTodayNotDone(todos);
            if (todayTodosNotDone.length > 0) {
              final todo = todayTodosNotDone.first;
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
//                        getFirstGreeting(),
                        SizedBox(height: 80),
                        SizedBox(height: 20),
                        getSecondGreetings,
                      ],
                    ), //40
//                  SizedBox(height: 30),
                    Column(
                      children: <Widget>[
                        getToday, //25
                        SizedBox(height: 5),
                        HomeTodoListTile(
                          todo: todo,
                          onChangedCheckbox: (newValue) =>
                              _onChangedCheckbox(newValue, context, todo),
                          onPressed: () => _delete(context, todo),
                          onTap: () => _onTap(database, todo),
                        ),
                        SizedBox(height: 30),
                        TransparentFlatButton(
                          color: Colors.white,
                          onPressed: () => _focusButton(database, todo),
                          text: 'Focus Mode',
                        ),
                      ],
                    )
                  ],
                ),
              );
            } else {
              return Column(
                children: <Widget>[
                  getFirstGreeting(),
                  SizedBox(height: 30),
                  getFormattedDate, //30
                  SizedBox(height: 30),
                  TypeWriterQuestion(
                      text: 'What is your main focus today?'), //40
                  HomeTextField(onSubmitted: _onSubmitted), //FocusQuestion
                  //Today
                ],
              );
            }
          } else {
            return EmptyContent();
          }
        } else if (snapshot.hasError) {
          return EmptyContent(
            title: 'Something went wrong',
            message: 'Can\'t load items right now',
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Text get getFormattedDate {
    return Text(
      '$dayOfWeek, $formattedDate ',
      style: TextStyle(
        color: Colors.white,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget getFirstGreeting() {
    final user = Provider.of<User>(context);
    return SizedBox(
      height: 80,
      child: FadeAnimatedTextKit(
          totalRepeatCount: 1,
          isRepeatingAnimation: false,
//          displayFullTextOnTap: true,
          //why not working?
//          onFinished: () {
//            getSecondGreetings;
//          },
//          stopPauseOnTap: true,
          duration: Duration(seconds: 3),
          onTap: () {
            print("Tap Event");
          },
          text: [
            '${FirstGreetings().showGreetings()}, ${user.displayName}',
//            SecondGreetings().showGreetings().body
          ],
          textAlign: TextAlign.center,
          textStyle: TextStyle(
              fontSize: 35.0, color: Colors.white, fontWeight: FontWeight.bold),
          alignment: AlignmentDirectional.topStart),
    );
  }

  Text get getSecondGreetings {
    return Text(
      _secondGreetings,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 40.0, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  Text get getToday {
    return Text(
      'TODAY',
      style: TextStyle(
          color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
    );
  }

  Text get getCongrats {
    return Text(
      'Congratulations!',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
