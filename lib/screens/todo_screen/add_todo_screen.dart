import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:intl/intl.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:provider/provider.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({
    this.database,
    this.todo,
    this.pickedDate,
  });
  final Todo todo;
  final Database database;
  final DateTime pickedDate;

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final DateFormat _dateFormatter = DateFormat('MMM dd');
  final _formKey = GlobalKey<FormState>();

  ///need to add
//  bool processing;

  String title;
  String comment;
  DateTime dateNew;

  String formattedToday;
  String formattedDate;

  Todo get todo => widget.todo;
  Database get database => widget.database;

  TextEditingController _dateController;
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _textFocusNode = FocusNode();
//  final FocusNode _dropDownFocusNode = FocusNode();

  List _categories = [
    'Focus', //0
    'Work', //1
    'Home', //2
    'Shopping', //3
    'Others' //4
  ];

  List _projects = [
    'Project 1', //0
    'Project 2', //1
    'Others' //4
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCategory;

  List<DropdownMenuItem<String>> _dropDownMenuItemsProjects;
  String _currentProject;

  ///TODO
  void changedDropDownItem(String selectedCity) {
//    print("Selected city $selectedCity, we are going to refresh the UI");
    setState(() {
      _currentCategory = selectedCity;
    });
//    _dropDownFocusNode.unfocus();
//    FocusScope.of(context).requestFocus(_dropDownFocusNode);
  }

  // here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = List();
    for (String city in _categories) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(DropdownMenuItem(value: city, child: Text(city)));
    }
    return items;
  }

  void changedDropDownItemProjects(String selectedCity) {
//    print("Selected city $selectedCity, we are going to refresh the UI");
    setState(() {
      _currentProject = selectedCity;
    });
//    _dropDownFocusNode.unfocus();
//    FocusScope.of(context).requestFocus(_dropDownFocusNode);
  }

  // here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<String>> getDropDownMenuItemsProjects() {
    List<DropdownMenuItem<String>> items = List();
    for (String city in _projects) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(DropdownMenuItem(value: city, child: Text(city)));
    }
    return items;
  }

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _dropDownMenuItemsProjects = getDropDownMenuItemsProjects();

    formattedToday = DateFormat('M/d/y').format(DateTime.now());
    _dateController = TextEditingController();

    if (todo != null) {
      title = todo.title;
      comment = todo.comment;
      dateNew = todo.date;
//      print('dateNew if NOT null: $dateNew');
      formattedDate = DateFormat('M/d/y').format(dateNew);
      //this gives an initial value;
      formattedDate == formattedToday
          ? _dateController.text = 'Today'
          : _dateController.text = _dateFormatter.format(dateNew);
//      print('widget.dateController.text if NOT null: ${_dateController.text}');
      if (todo.category != null) {
        _currentCategory =
            _categories[todo.category]; //todo.category is a number (index)
      }

      if (todo.project != null) {
        _currentProject = todo.project; //this is a String
      }
    } else {
      //if todo is null
      dateNew = widget.pickedDate;
//      print(
//          'dateNew in init if null: $dateNew'); //if todo is null, we used pickedDate which we passed by
      //this gives an initial value;
      formattedDate == formattedToday
          ? _dateController.text = 'Today'
          : _dateController.text = _dateFormatter.format(dateNew);
      //need to give it a value;
      _currentCategory = _dropDownMenuItems[0].value;

      _currentProject = _dropDownMenuItemsProjects[0].value;
//      print('widget.dateController.text if null: ${_dateController.text}');
    }
    super.initState();
  }

  Future<void> _handleDatePicker() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: dateNew,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 5),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              backgroundColor: darkBkgdColor,
              dialogBackgroundColor: darkBkgdColor,
              primaryColor: const Color(0xFF0f4c75), //header
              accentColor: const Color(0xFFbbe1fa), //selection color
//              colorScheme: ColorScheme.light(primary: const Color(0xFF0f4c75)),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
              dialogTheme: DialogTheme(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)))),
            ),
            child: child,
          );
        });
    if (date != null && date != dateNew) {
//    if (date != null) {
      setState(() {
        dateNew = date; //give task date a new value and also update the screen
      }); //DateFormat('MMM dd, yyyy');
      //this is the date we picked
      _dateController.text = _dateFormatter.format(date);
//      print('_dateController.text: ${_dateController.text}');
    }

    _dateFocusNode.unfocus();
    FocusScope.of(context).requestFocus(_textFocusNode);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _dateFocusNode.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SingleChildScrollView(
      child: CustomizedBottomSheet(
        color: _darkTheme ? darkAdd : lightAdd,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Text(todo != null ? 'Edit Task' : 'Add Task',
                  style: Theme.of(context).textTheme.headline5),
              SizedBox(
                height: 10,
              ),
//              todo != null
//                  ? Container() //MEANS WE ARE EDITING, ONLY EDIT TITLE
//                  :
//
//              Text(
//                      formattedDate == formattedToday
//                          ? 'Today'
//                          : _dateFormatter.format(dateNew),
//                      style: Theme.of(context).textTheme.headline6),
              Container(
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
//                    initialValue: formattedDate == formattedToday
//                        ? 'Today'
//                        : _dateFormatter.format(dateNew),
                    focusNode: _dateFocusNode,
//                    textInputAction: TextInputAction.next,
//                    onEditingComplete: () => _dateEditingComplete(),
                    validator: (value) =>
                        value.isNotEmpty ? null : 'Date can\'t be empty',
                    textAlign: TextAlign.center,
                    //no need validation because there always a data
                    //When a [controller] is specified, [initialValue] must be null (the default). If [controller] is null, then a [TextEditingController] will be constructed automatically and its text will be initialized to [initialValue] or the empty string.
                    readOnly: true,
                    controller: _dateController, //this is TextEditingController
                    style: Theme.of(context).textTheme.headline6,
                    cursorColor: _darkTheme ? Colors.white : lightButton,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                    ),
//                    //not sure how this works if without controller
//                    onSaved: (value) => _dateFormatter.format(dateNew) = value,
//                    onTap: widget.onTap,
                    onTap: () => _handleDatePicker(),
                  ),
                ),
              ),
              Container(
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    initialValue: title,
                    focusNode: _textFocusNode,
//                    textInputAction: TextInputAction.done,
                    validator: (value) =>
                        value.isNotEmpty ? null : 'Task title can\'t be empty',
                    onSaved: (value) => title = value,
                    //if submit successfully, we pop this page and go to home page
//                    onEditingComplete: _submit,
                    style: TextStyle(
                        color: _darkTheme ? Colors.white : Color(0xF01b262c),
                        fontSize: 16.0),
                    autofocus: true,
//                    textAlign: TextAlign.center,
                    cursorColor: _darkTheme ? Colors.white : lightButton,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: 100,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                          fontSize: 15,
                          color: _darkTheme ? Colors.white54 : Colors.black38),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: _darkTheme ? Colors.white : lightButton)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: _darkTheme ? Colors.white : lightButton)),
                    ),
                  ),
                ),
              ),
              Container(
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    initialValue: comment,
//                    focusNode: _textFocusNode,
//                    textInputAction: TextInputAction.done,
                    onSaved: (value) => comment = value,
                    //if submit successfully, we pop this page and go to home page
//                    onEditingComplete: _submit,
                    style: TextStyle(
                        color: _darkTheme ? Colors.white70 : Color(0xF01b262c),
                        fontSize: 14.0),
//                    autofocus: true,
//                    textAlign: TextAlign.center,
                    cursorColor: _darkTheme ? Colors.white : lightButton,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Comment (optional)',
                      hintStyle: TextStyle(
                          fontSize: 13,
                          color: _darkTheme ? Colors.white54 : Colors.black38),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: _darkTheme ? Colors.white : lightButton)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: _darkTheme ? Colors.white : lightButton)),
                    ),
                  ),
                ),
              ),
              Container(
                width: 350,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Task Category',
                        style: TextStyle(
                            fontSize: 13,
                            color:
                                _darkTheme ? Colors.white54 : Colors.black38),
                      ),
                      DropdownButton(
                        value: _currentCategory,
                        items: _dropDownMenuItems,
                        onChanged: changedDropDownItem,
                        dropdownColor: darkAdd,
//                        focusNode: _dropDownFocusNode,
                      ),
                    ],
                  ),

//                  DropdownButtonFormField(
//                    isDense: true,
//                    icon: Icon(Icons.arrow_drop_down_circle),
//                    iconSize: 22.0,
//                    iconEnabledColor: Theme.of(context).primaryColor,
//                    items: _priorities.map((String priority) {
//                      return DropdownMenuItem(
//                        value: priority,
//                        child: Text(
//                          priority,
//                          style: TextStyle(
//                            fontSize: 18.0,
//                          ),
//                        ),
//                      );
//                    }).toList(),
//                    style: TextStyle(
//                        color: _darkTheme ? Colors.white70 : Color(0xF01b262c),
//                        fontSize: 14.0),
//                    decoration: InputDecoration(
//                      hintText: 'Category',
//                      hintStyle: TextStyle(
//                          fontSize: 13,
//                          color: _darkTheme ? Colors.white54 : Colors.black38),
//                      focusedBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(
//                              color: _darkTheme ? Colors.white : lightButton)),
//                      enabledBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(
//                              color: _darkTheme ? Colors.white : lightButton)),
//                    ),
//                    onChanged: (value) {
//                      setState(() {
//                        _priority = value;
//                      });
//                    },
//                    value: _priority,
//                  ),
                ),
              ),
              _currentCategory == 'Focus'
                  ? Container(
                      width: 350,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Project name',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: _darkTheme
                                      ? Colors.white54
                                      : Colors.black38),
                            ),
                            DropdownButton(
                              value: _currentProject,
                              items: _dropDownMenuItemsProjects,
                              onChanged: changedDropDownItemProjects,
                              dropdownColor: darkAdd,
//                        focusNode: _dropDownFocusNode,
                            ),
                          ],
                        ),

//                  DropdownButtonFormField(
//                    isDense: true,
//                    icon: Icon(Icons.arrow_drop_down_circle),
//                    iconSize: 22.0,
//                    iconEnabledColor: Theme.of(context).primaryColor,
//                    items: _priorities.map((String priority) {
//                      return DropdownMenuItem(
//                        value: priority,
//                        child: Text(
//                          priority,
//                          style: TextStyle(
//                            fontSize: 18.0,
//                          ),
//                        ),
//                      );
//                    }).toList(),
//                    style: TextStyle(
//                        color: _darkTheme ? Colors.white70 : Color(0xF01b262c),
//                        fontSize: 14.0),
//                    decoration: InputDecoration(
//                      hintText: 'Category',
//                      hintStyle: TextStyle(
//                          fontSize: 13,
//                          color: _darkTheme ? Colors.white54 : Colors.black38),
//                      focusedBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(
//                              color: _darkTheme ? Colors.white : lightButton)),
//                      enabledBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(
//                              color: _darkTheme ? Colors.white : lightButton)),
//                    ),
//                    onChanged: (value) {
//                      setState(() {
//                        _priority = value;
//                      });
//                    },
//                    value: _priority,
//                  ),
                      ),
                    )
                  : Container(),
              SizedBox(height: 15),
              MyFlatButton(
                  onPressed: _save,
                  text: 'SAVE',
                  color: _darkTheme ? Colors.white : lightButton),
              SizedBox(height: 30)
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
    final index = _categories.indexOf(_currentCategory);
    print('index: $index');
    if (_validateAndSaveForm()) {
      //pop to previous page
      Navigator.of(context).pop([title, comment, dateNew, index]);
    }
  }
}

//class UpdateTodoScreen extends StatefulWidget {
//  const UpdateTodoScreen({
//    this.database,
//    this.todo,
//    this.pickedDate,
//    this.save,
//    this.mantraVisible
////      this.dateController,
//  });
//  final Todo todo;
//  final Database database;
//  final Function save;
//  final DateTime pickedDate;
//  final bool mantraVisible;
////  final TextEditingController dateController;
//  @override
//  _UpdateTodoScreenState createState() => _UpdateTodoScreenState();
//}
//
//class _UpdateTodoScreenState extends State<UpdateTodoScreen> {
//  final DateFormat _dateFormatter = DateFormat('MMM dd');
//  final _formKey = GlobalKey<FormState>();
//
//
//  String title;
//  DateTime dateNew;
//  String formattedToday;
//  String formattedDate;
//
//  Todo get todo => widget.todo;
//  Database get database => widget.database;
//
//  @override
//  void initState() {
//    if (todo != null) {
//      title = todo.title;
//      dateNew = todo.date;
//    }
//
//    dateNew = widget
//        .pickedDate; //if todo is null, we used pickedDate which we passed by
//    formattedToday = DateFormat('M/d/y').format(DateTime.now());
//    formattedDate = DateFormat('M/d/y').format(dateNew);
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//    return SingleChildScrollView(
//      child: CustomizedBottomSheet(
//        color: _darkTheme ? darkAdd : lightAdd,
//        child: Form(
//          key: _formKey,
//          child: Column(
//            children: <Widget>[
//              SizedBox(height: 20),
//              Text(todo != null ? 'Edit Task Title' : 'Add Task Title',
//                  style: Theme.of(context).textTheme.headline5),
//              SizedBox(
//                height: 10,
//              ),
//              todo != null
//                  ? Container() //MEANS WE ARE EDITING, ONLY EDIT TITLE
//                  : Text(
//                  formattedDate == formattedToday
//                      ? 'Today'
//                      : _dateFormatter.format(dateNew),
//                  style: Theme.of(context).textTheme.headline6),
//              Container(
//                width: 350,
//                child: Padding(
//                  padding: const EdgeInsets.symmetric(horizontal: 15),
//                  child: TextFormField(
//                    initialValue: title,
//                    validator: (value) =>
//                    value.isNotEmpty ? null : 'Task title can\'t be empty',
//                    onSaved: (value) => title = value,
//                    style: TextStyle(
//                        color: _darkTheme ? Colors.white : Color(0xF01b262c),
//                        fontSize: 20.0),
//                    autofocus: true,
//                    textAlign: TextAlign.center,
//                    cursorColor: _darkTheme ? Colors.white : lightButton,
//                    keyboardType: TextInputType.multiline,
//                    maxLines: null,
//                    maxLength: 100,
//                    decoration: InputDecoration(
//                      focusedBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(
//                              color: _darkTheme ? Colors.white : lightButton)),
//                      enabledBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(
//                              color: _darkTheme ? Colors.white : lightButton)),
//                    ),
//                  ),
//                ),
//              ),
////              SizedBox(height: 20),
//              MyFlatButton(
//                  onPressed: _save,
//                  text: 'SAVE',
//                  color: _darkTheme ? Colors.white : lightButton),
//              SizedBox(height: 20)
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  bool _validateAndSaveForm() {
//    final form = _formKey.currentState;
//    //validate
//    if (form.validate()) {
//      //save
//      form.save();
//      return true;
//    }
//    return false;
//  }
//
//  Future<void> _save() async {
//    if (_validateAndSaveForm()) {
//      //pop to previous page
//      Navigator.of(context).pop(title);
//    }
//
////    setState(() {
//      widget.mantraVisible = true;
////    });
//  }
//}
