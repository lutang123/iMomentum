import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/utils/format.dart';
import 'package:provider/provider.dart';

import 'input_dropdown.dart';

class ReminderTimePicker extends StatelessWidget {
  const ReminderTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.onSelectedDate,
    this.onSelectedTime,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> onSelectedDate;
  final ValueChanged<TimeOfDay> onSelectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate, //now
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (BuildContext context, Widget child) {
        return _darkTheme
            ? Theme(
                data: ThemeData.dark().copyWith(
                  backgroundColor: darkThemeNoPhotoColor,
                  dialogBackgroundColor: darkThemeNoPhotoColor,

                  primaryColor: const Color(0xFF0f4c75), //header, no chang
                  accentColor: const Color(0xFFbbe1fa), //selection color
//              colorScheme: ColorScheme.light(primary: const Color(0xFF0f4c75)),
                  buttonTheme:
                      ButtonThemeData(textTheme: ButtonTextTheme.accent),
                  dialogTheme: DialogTheme(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0)))),
                ),
                child: child,
              )
            : Theme(
                data: ThemeData.light().copyWith(
                  backgroundColor: lightThemeNoPhotoColor,
                  dialogBackgroundColor: lightThemeNoPhotoColor,

                  primaryColor: const Color(0xFF0f4c75), //header, no change
                  accentColor: const Color(0xFFbbe1fa), //selection color
//              colorScheme: ColorScheme.light(primary: const Color(0xFF0f4c75)), //not sure what is this, but no changes
                  buttonTheme:
                      ButtonThemeData(textTheme: ButtonTextTheme.accent),
                  dialogTheme: DialogTheme(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0)))),
                ),
                child: child,
              );
      },
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      onSelectedDate(pickedDate);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget child) {
        return _darkTheme
            ? Theme(
                data: ThemeData.dark().copyWith(
                  backgroundColor: darkThemeNoPhotoColor,
                  dialogBackgroundColor: darkThemeNoPhotoColor,

                  primaryColor: const Color(0xFF0f4c75), //header, no chang
                  accentColor: const Color(0xFFbbe1fa), //selection color
//              colorScheme: ColorScheme.light(primary: const Color(0xFF0f4c75)),
                  buttonTheme:
                      ButtonThemeData(textTheme: ButtonTextTheme.accent),
                  dialogTheme: DialogTheme(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0)))),
                ),
                child: child,
              )
            : Theme(
                data: ThemeData.light().copyWith(
                  backgroundColor: lightThemeNoPhotoColor,
                  dialogBackgroundColor: lightThemeNoPhotoColor,

                  primaryColor: const Color(0xFF0f4c75), //header, no change
                  accentColor: const Color(0xFFbbe1fa), //selection color
//              colorScheme: ColorScheme.light(primary: const Color(0xFF0f4c75)), //not sure what is this, but no changes
                  buttonTheme:
                      ButtonThemeData(textTheme: ButtonTextTheme.accent),
                  dialogTheme: DialogTheme(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0)))),
                ),
                child: child,
              );
      },
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      onSelectedTime(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.subtitle1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          width: 150,
          child: InputDropdown(
            valueText: Format.date(selectedDate),
            valueStyle: valueStyle,
            onPressed: () => _selectDate(context),
          ),
        ),
        SizedBox(
          width: 150,
          child: InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () => _selectTime(context),
          ),
        ),
      ],
    );
  }
}

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    Key key,
    this.labelTextStart,
    this.selectedTimeStart,
    this.onSelectedTimeStart,
    this.labelText,
    this.selectedTime,
    this.onSelectedTime,
  }) : super(key: key);

  final String labelTextStart;
  final TimeOfDay selectedTimeStart;
  final ValueChanged<TimeOfDay> onSelectedTimeStart;

  final String labelText;
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> onSelectedTime;

  Future<void> _selectTimeStart(BuildContext context) async {
    final pickedTime =
        await showTimePicker(context: context, initialTime: selectedTimeStart);
    if (pickedTime != null && pickedTime != selectedTimeStart) {
      onSelectedTimeStart(pickedTime);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (pickedTime != null && pickedTime != selectedTime) {
      onSelectedTime(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.headline6;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          width: 300,
          child: InputDropdown(
            labelText: labelTextStart,
            valueText: selectedTimeStart.format(context),
            valueStyle: valueStyle,
            onPressed: () => _selectTimeStart(context),
          ),
        ),
        SizedBox(
          width: 300,
          child: InputDropdown(
            labelText: labelText,
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () => _selectTime(context),
          ),
        ),
      ],
    );
  }
}
