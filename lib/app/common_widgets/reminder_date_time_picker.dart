import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iMomentum/app/utils/format.dart';

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
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate, //now
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      onSelectedDate(pickedDate);
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
