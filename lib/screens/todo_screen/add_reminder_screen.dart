import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iMomentum/app/common_widgets/date_time_picker.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/sign_in/auth_service.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({
    this.todo,
    this.user,
    this.database,
  });
  final Todo todo;
  final User user;
  final Database database;

  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  // final DateFormat _dateFormatter = DateFormat('MMM dd');
  // final _formKey = GlobalKey<FormState>();

  /// for local notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final now = DateTime.now();
  DateTime
      _reminderEnd; //we will get after after user choose a _reminderDate and _reminderTime;

  DateTime
      _reminderDate; //we assign an initial value as now, and the assign new picked value
  TimeOfDay _reminderTime;

  // String formattedToday = DateFormat('M/d/y').format(DateTime.now());

  Todo get todo => widget.todo;
  User get user => widget.user;
  Database get database => widget.database;

  String firstName;

  String formattedToday = DateFormat('M/d/y').format(DateTime.now());

  @override
  void initState() {
    // _reminderStart = DateTime(now.year, now.month, now.day,
    //     TimeOfDay.fromDateTime(now).hour, TimeOfDay.fromDateTime(now).minute);

    /// previous make it add/edit just like in addTodoScreen, but then when we are
    /// about to change, it still show the current time unless we save the reminder date, to make it simple, just to cancel reminder in TodoScreen
    _reminderDate = todo.hasReminder == null || todo.hasReminder == false
        ? DateTime(now.year, now.month, now.day)
        : DateTime(todo.reminderDate.year, todo.reminderDate.month,
            todo.reminderDate.day);

    _reminderTime = todo.hasReminder == null || todo.hasReminder == false
        ? TimeOfDay.fromDateTime(now)
        : TimeOfDay.fromDateTime(todo.reminderDate);

    firstName = user.displayName == null
        ? ''
        : user.displayName.substring(0, user.displayName.indexOf(' '));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SingleChildScrollView(
      child: CustomizedBottomSheet(
        color: _darkTheme ? darkThemeAdd : lightThemeAdd,
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Text(
                todo.hasReminder == null || todo.hasReminder == false
                    ? 'Add Reminder'
                    : 'Change Reminder',
                style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 15),
            Text(
              'Remind me for this task at: ',
              style: TextStyle(
                  fontSize: 16,
                  color: _darkTheme ? Colors.white60 : Colors.black54,
                  fontStyle: FontStyle.italic),
//                  style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(height: 20),
            _buildReminderDate(todo),
            SizedBox(height: 10),
            Visibility(
              visible: _errorMessageVisible,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Reminder time must be a time later than current time.',
                  style:
                      TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
                ),
              ),
            ),
            SizedBox(height: 20),
            todo.hasReminder == null || todo.hasReminder == false
                ? MyFlatButton(
                    onPressed: _scheduleNotification,
                    text: 'SAVE',
                    bkgdColor: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
                    color: _darkTheme ? Colors.white : lightThemeButton)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //add SizedBox to make sure this row and the above row has same position
                      SizedBox(
                        width: 150,
                        child: FlatButton(
                          child: Text('Cancel Reminder',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.redAccent)),
                          onPressed: () => _cancelReminder(todo),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: MyFlatButton(
                            onPressed: _scheduleNotification,
                            text: 'SAVE',
                            bkgdColor:
                                _darkTheme ? darkThemeAppBar : lightThemeAppBar,
                            color:
                                _darkTheme ? Colors.white : lightThemeButton),
                      )
                    ],
                  ),
            SizedBox(height: 100)
          ],
        ),
      ),
    );
  }

  Widget _buildReminderDate(Todo todo) {
    return
        // DateFormat('M/d/y').format(todo.date) == formattedToday
        //   ? TimePicker(
        //       selectedTime: _reminderTime,
        //       onSelectedTime: (time) => setState(() => _reminderTime = time),
        //     )
        //   :

        DateTimePicker(
      selectedDate: _reminderDate,
      selectedTime: _reminderTime,
      onSelectedDate: (date) => setState(() => _reminderDate = date),
      onSelectedTime: (time) => setState(() => _reminderTime = time),
    );
  }

  ///can be used in count down
  //
  // double durationInHours(DateTime start, DateTime end) =>
  //     end.difference(start).inMinutes.toDouble() / 60.0;
  //
  // ///
  // //  //the birthday's date
  // //  final birthday = DateTime(1967, 10, 12);
  // //  final date2 = DateTime.now();
  // //  final difference = date2.difference(birthday).inDays;
  // ///this can be used in count down;
  // Widget _buildDuration() {
  //   _reminderEnd = DateTime(_reminderDate.year, _reminderDate.month,
  //       _reminderDate.day, _reminderTime.hour, _reminderTime.minute);
  //
  //   final durationFormatted =
  //       Format.hours(durationInHours(_reminderStart, _reminderEnd));
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: <Widget>[
  //       Text(
  //         'Duration: $durationFormatted',
  //         style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
  //         maxLines: 1,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //     ],
  //   );
  // }
  bool _errorMessageVisible = false;

  /// Schedules a notification that specifies a different icon, sound and vibration pattern
  Future<void> _scheduleNotification() async {
    _reminderEnd = DateTime(_reminderDate.year, _reminderDate.month,
        _reminderDate.day, _reminderTime.hour, _reminderTime.minute);

    final difference =
        _reminderEnd.difference(DateTime.now()); //type is Duration
    // print("difference: $difference");

    if (difference.inSeconds > 0) {
      var scheduledNotificationDateTime = DateTime.now().add(difference);
      var vibrationPattern = Int64List(4); //from library typed_data
      vibrationPattern[0] = 0;
      vibrationPattern[1] = 1000;
      vibrationPattern[2] = 5000;
      vibrationPattern[3] = 2000;

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'your other channel id',
          'your other channel name',
          'your other channel description',
          importance: Importance.Max,
          priority: Priority.High,
          ticker: 'ticker',
          icon: 'secondary_icon',
          sound: RawResourceAndroidNotificationSound('slow_spring_board'),
          largeIcon: DrawableResourceAndroidBitmap('sample_large_icon'),
          vibrationPattern: vibrationPattern,
          enableLights: true,
          color: const Color.fromARGB(255, 255, 0, 0),
          ledColor: const Color.fromARGB(255, 255, 0, 0),
          ledOnMs: 1000,
          ledOffMs: 500);

      var iOSPlatformChannelSpecifics =
          IOSNotificationDetails(sound: 'slow_spring_board.aiff');

      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      var stringIdOriginal = DateTime.parse(todo.id)
          .millisecondsSinceEpoch
          .toString(); // eg. 1598740081263
      var intIdShort =
          int.parse(stringIdOriginal.substring(0, stringIdOriginal.length - 3));

      await flutterLocalNotificationsPlugin.schedule(
        intIdShort,
        'Hey, $firstName, this is a reminder for this task: ',
        todo.title.length < 30
            ? '${todo.title}'
            : '${todo.title.substring(0, 30)}...',
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: 'item x', //?
      );

      try {
        todo.hasReminder = true;
        todo.reminderDate = _reminderEnd;
        await database.setTodo(todo);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }

      Navigator.of(context).pop();
    } else {
      setState(() {
        _errorMessageVisible = true;
      });
    }
  }

  Future<void> _cancelReminder(Todo todo) async {
    var stringIdOriginal = DateTime.parse(todo.id)
        .millisecondsSinceEpoch
        .toString(); // eg. 1598740081263
    var intIdShort =
        int.parse(stringIdOriginal.substring(0, stringIdOriginal.length - 3));

    await flutterLocalNotificationsPlugin.cancel(intIdShort);

    try {
      todo.hasReminder = false;
      await database.setTodo(todo);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }

    Navigator.of(context).pop();
  }
}
