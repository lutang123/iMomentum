import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/customized_bottom_sheet.dart';
import 'package:iMomentum/app/common_widgets/my_transparent_flat_button.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:intl/intl.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({this.database, this.todo, this.pickedDate});
  final Todo todo;
  final Database database;
//  final VoidCallback onTap;
  final DateTime pickedDate;
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd');
  final _formKey = GlobalKey<FormState>();
  bool processing;

  String title;
  DateTime _date;
  String formattedToday;
  String formattedDate;

  Todo get todo => widget.todo;
  Database get database => widget.database;

  @override
  void initState() {
    if (widget.todo != null) {
      title = todo.title;
      _date = todo.date;
    }
    _date = widget.pickedDate;
//    _dateController.text = _dateFormatter.format(_date);
    formattedToday = DateFormat("yyyy-MM-dd").format(DateTime.now());
    formattedDate = DateFormat("yyyy-MM-dd").format(_date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CustomizedBottomSheet(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Text(todo != null ? 'Edit Todo' : 'Add Todo',
                  style: TextStyle(
//                    fontWeight: FontWeight.w600,
                    fontSize: 25.0,
                  )),
              SizedBox(
                height: 10,
              ),
              Text(
                  formattedDate == formattedToday
                      ? 'Today'
                      : _dateFormatter.format(_date),
                  style: TextStyle(
//                    fontWeight: FontWeight.w400,
                    fontSize: 20.0,
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                child: TextFormField(
                  initialValue: title,
                  validator: (value) =>
                      value.isNotEmpty ? null : 'TODO can\'t be empty',
                  onSaved: (value) => title = value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                  autofocus: true,
                  textAlign: TextAlign.center,
                  cursorColor: Colors.white,
                  maxLength: 100,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
              ),
//              SizedBox(height: 30.0),
              TransparentFlatButton(
                onPressed: _save,
                text: 'SAVE',
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    //validate
    if (form.validate()) {
      //save
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _save() async {
    if (_validateAndSaveForm()) {
//      widget.save();
      //pop to previous page
      Navigator.of(context).pop(title);
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}
