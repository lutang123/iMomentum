//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:iMomentum/app/common_widgets/customized_bottom_sheet.dart';
//import 'package:iMomentum/app/common_widgets/date_time_picker.dart';
//import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
//import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
//import 'package:iMomentum/app/models/entry.dart';
//import 'package:iMomentum/app/models/todo.dart';
//import 'package:iMomentum/app/services/database.dart';
//
//import 'format.dart';
//
//class EntryPage extends StatefulWidget {
//  const EntryPage({@required this.database, @required this.job, this.entry});
//  final TodoModel job;
//  final Duration entry;
//  final Database database;
//
////  static Future<void> show(
////      {BuildContext context, Database database, Job job, Entry entry}) async {
////    await Navigator.of(context, rootNavigator: true).push(
////      MaterialPageRoute(
////        builder: (context) =>
////            EntryPage(database: database, job: job, entry: entry),
////        fullscreenDialog: true,
////      ),
////    );
////  }
//
//  @override
//  State<StatefulWidget> createState() => _EntryPageState();
//}
//
//class _EntryPageState extends State<EntryPage> {
//  DateTime _startDate;
//  TimeOfDay _startTime;
//  DateTime _endDate;
//  TimeOfDay _endTime;
//  String _comment;
//
//  @override
//  void initState() {
//    super.initState();
//    final start = widget.entry?.start ?? DateTime.now();
//    _startDate = DateTime(start.year, start.month, start.day);
//    _startTime = TimeOfDay.fromDateTime(start);
//
//    final end = widget.entry?.end ?? DateTime.now();
//    _endDate = DateTime(end.year, end.month, end.day);
//    _endTime = TimeOfDay.fromDateTime(end);
//
//    _comment = widget.entry?.comment ?? '';
//  }
//
//  Duration _entryFromState() {
//    final start = DateTime(_startDate.year, _startDate.month, _startDate.day,
//        _startTime.hour, _startTime.minute);
//    final end = DateTime(_endDate.year, _endDate.month, _endDate.day,
//        _endTime.hour, _endTime.minute);
//    final id = widget.entry?.id ?? documentIdFromCurrentDate();
//    return Duration(
//      id: id,
//      jobId: widget.job.id,
//      start: start,
//      end: end,
//      comment: _comment,
//    );
//  }
//
//  Future<void> _setEntryAndDismiss(BuildContext context) async {
//    try {
//      final entry = _entryFromState();
//      await widget.database.setEntry(entry);
//      Navigator.of(context).pop();
//    } on PlatformException catch (e) {
//      PlatformExceptionAlertDialog(
//        title: 'Operation failed',
//        exception: e,
//      ).show(context);
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return CustomizedBottomSheet(
//      child: SingleChildScrollView(
//        child: Container(
//          padding: EdgeInsets.all(16.0),
//          child: Column(
//            mainAxisSize: MainAxisSize.min,
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              _buildStartDate(),
//              _buildEndDate(),
//              SizedBox(height: 8.0),
//              _buildDuration(),
//              SizedBox(height: 8.0),
//              _buildComment(),
//              MyFlatButton(
//                text: 'save',
//                onPressed: () => _setEntryAndDismiss(context),
//              )
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget _buildStartDate() {
//    return DateTimePicker(
//      labelText: 'Start',
//      selectedDate: _startDate,
//      selectedTime: _startTime,
//      onSelectedDate: (date) => setState(() => _startDate = date),
//      onSelectedTime: (time) => setState(() => _startTime = time),
//    );
//  }
//
//  Widget _buildEndDate() {
//    return DateTimePicker(
//      labelText: 'End',
//      selectedDate: _endDate,
//      selectedTime: _endTime,
//      onSelectedDate: (date) => setState(() => _endDate = date),
//      onSelectedTime: (time) => setState(() => _endTime = time),
//    );
//  }
//
//  Widget _buildDuration() {
//    final currentEntry = _entryFromState();
//    final durationFormatted = Format.hours(currentEntry.durationInHours);
//    return Row(
//      mainAxisAlignment: MainAxisAlignment.end,
//      children: <Widget>[
//        Text(
//          'Duration: $durationFormatted',
//          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
//          maxLines: 1,
//          overflow: TextOverflow.ellipsis,
//        ),
//      ],
//    );
//  }
//
//  Widget _buildComment() {
//    return TextField(
//      keyboardType: TextInputType.text,
//      maxLength: 50,
//      controller: TextEditingController(text: _comment),
//      decoration: InputDecoration(
//        labelText: 'Comment',
//        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
//      ),
//      style: TextStyle(fontSize: 20.0, color: Colors.black),
//      maxLines: null,
//      onChanged: (comment) => _comment = comment,
//    );
//  }
//}
