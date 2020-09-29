import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
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

  ///Todo: need to add
//  bool processing;

  String title;
  String comment;
  DateTime dateNew;

  String formattedToday = DateFormat('M/d/y').format(DateTime.now());
  String formattedDate;
  String formattedDateIfNull;

  Todo get todo => widget.todo;
  Database get database => widget.database;

  TextEditingController _dateController;

  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _textFocusNode = FocusNode();

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCategory;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();

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
        //RangeError (index): Invalid value: Not in inclusive range 0..4: -1
        //add this the range error will be gone
        todo.category < 0
            ? _currentCategory = _categories[todo.category + 1]
            : _currentCategory =
                _categories[todo.category]; //todocategory is a number (index)
      } else {
        //if category is null, we assign a default value
        _currentCategory = _categories[0];
      }
    } else {
      //if task is null
      dateNew = widget.pickedDate;
//      print(
//          'dateNew in init if task is null: $dateNew'); //if task is null, we used pickedDate which we passed by
      //this gives an initial value;
      formattedDateIfNull = DateFormat('M/d/y').format(dateNew);
      formattedDateIfNull == formattedToday
          ? _dateController.text = 'Today'
          : _dateController.text = _dateFormatter.format(dateNew);

      //need to give it a value;
      _currentCategory = _dropDownMenuItems[0].value;
    }
    super.initState();
  }

  List _categories = [
    'Focus', //0, default
    'Work', //1
    'Home', //2
    'Shopping', //3
    'Others' //4
  ];

  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentCategory = selectedCity;
    });

    ///tried to make sure keyboard stay pop up, but this does not work
//    _dropDownFocusNode.unfocus();
//    FocusScope.of(context).requestFocus(_dropDownFocusNode);
  }

  // here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = List();
    for (String category in _categories) {
      items.add(DropdownMenuItem(
          value: category,
          child: Text(
            category,
            // style: TextStyle(color: darkThemeWords),
          )));
    }
    return items;
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
              backgroundColor: darkThemeNoPhotoColor,
              dialogBackgroundColor: darkThemeNoPhotoColor,

              primaryColor: const Color(0xFF0f4c75), //header, no chang
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
      _dateController.text =

          ///add this so that if we picked today, it shows today.
          DateFormat('M/d/y').format(date) == formattedToday
              ? 'Today'
              : _dateFormatter.format(date);
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
    // double height = MediaQuery.of(context).size.height;
    // print('height: $height'); //height: 683.4285714285714; height: 896
    // double width = MediaQuery.of(context).size.width;
    // print('width: $width'); //width: 411.42857142857144; width: 414
    return SingleChildScrollView(
      child: CustomizedBottomSheet(
        color: _darkTheme ? darkThemeAdd : lightThemeNoPhotoColor,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Row(
                children: [
                  Opacity(
                    opacity: 0.0,
                    child: IconButton(onPressed: null, icon: Icon(Icons.clear)),
                  ),
                  Spacer(),
                  Text(todo != null ? 'Edit Task' : 'Add Task',
                      style: TextStyle(
                        fontSize: 23,
                        color: _darkTheme ? darkThemeWords : lightThemeWords,
                        fontWeight: FontWeight.w600,
                      )),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.clear),
                        color: _darkTheme ? darkThemeHint : lightThemeHint),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 65, //width / 6,
                    child: Center(
                      child: TextFormField(
                        controller:
                            _dateController, //this is TextEditingController
                        focusNode: _dateFocusNode,
                        readOnly: true,
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: _darkTheme ? darkThemeWords : lightThemeWords,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                        ),
                        onTap: _handleDatePicker,
                      ),
                    ),
                  ),
                  SizedBox(width: 3),
                  InkWell(
                    onTap: _handleDatePicker,
                    child: Icon(EvaIcons.calendarOutline,
                        color: _darkTheme ? darkThemeButton : lightThemeButton),
                  ),
                  // IconButton(
                  //     padding: const EdgeInsets.all(0.0),
                  //     icon:
                  //     onPressed: _handleDatePicker),
                ],
              ),
              SizedBox(
                width: 350, //width * 0.85,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    keyboardAppearance:
                        _darkTheme ? Brightness.dark : Brightness.light,
                    initialValue: title,
                    focusNode: _textFocusNode,
//                    textInputAction: TextInputAction.done, //we can not have this
                    validator: (value) =>
                        value.isNotEmpty ? null : 'Task title can\'t be empty',
                    onSaved: (value) => title = value,
                    //if submit successfully, we pop this page and go to home page
                    // onEditingComplete: () => _textFocusNode.nextFocus(), //no use
                    style: TextStyle(
                        color: _darkTheme ? darkThemeWords : lightThemeWords,
                        fontSize: 16.0),
                    autofocus: true,
                    cursorColor:
                        _darkTheme ? darkThemeButton : lightThemeButton,
                    // can not remove this
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: 100,
                    decoration: InputDecoration(
                      ///https://stackoverflow.com/questions/51893926/how-can-i-hide-letter-counter-from-bottom-of-textfield-in-flutter#:~:text=To%20hide%20counter%20value%20from,InputDecoration%20property%20with%20empty%20value.
                      counterText: "",
                      hintText: 'Title',
                      hintStyle: TextStyle(
                          fontSize: 15,
                          color: _darkTheme ? darkThemeHint : lightThemeHint),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: _darkTheme
                                  ? darkThemeDivider
                                  : lightThemeDivider)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: _darkTheme
                                  ? darkThemeDivider
                                  : lightThemeDivider)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    keyboardAppearance:
                        _darkTheme ? Brightness.dark : Brightness.light,
                    initialValue: comment,
//                    focusNode: _textFocusNode, //no need
                    ///we need to keep keyboard open, can not have .done
//                    textInputAction: TextInputAction.done,
                    onSaved: (value) => comment = value,
                    style: TextStyle(
                        color: _darkTheme
                            ? darkThemeWords.withOpacity(0.8)
                            : lightThemeWords.withOpacity(0.8),
                        fontSize: 14.0),
                    cursorColor:
                        _darkTheme ? darkThemeButton : lightThemeButton,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Comment (optional)',
                      hintStyle: TextStyle(
                          fontSize: 13,
                          color: _darkTheme ? darkThemeHint : lightThemeHint),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: _darkTheme
                                  ? darkThemeDivider
                                  : lightThemeDivider)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: _darkTheme
                                  ? darkThemeDivider
                                  : lightThemeDivider)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: 350,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Task Category',
                        style: TextStyle(
                            fontSize: 13,
                            color: _darkTheme ? darkThemeHint : lightThemeHint),
                      ),
                      Theme(
                        //backgroundColor will match the canvasColor in your ThemeData clas
                        data: _darkTheme
                            ? Theme.of(context).copyWith(
                                canvasColor: darkThemeAdd,
                              )
                            : Theme.of(context).copyWith(
                                canvasColor: lightThemeNoPhotoColor,
                              ),
                        child: DropdownButton(
                          value: _currentCategory,
                          items: _dropDownMenuItems,
                          onChanged: changedDropDownItem,
                          // dropdownColor: darkThemeAdd,
//                          focusColor: Colors.orangeAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 15),
              MyFlatButton(
                  onPressed: _save,
                  text: 'SAVE',
                  bkgdColor: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
                  color: _darkTheme ? darkThemeButton : lightThemeButton),
              SizedBox(height: 20)
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
    // print('_currentCategory: $_currentCategory');
    final index = _categories.indexOf(_currentCategory);
    // print('index: $index');
//    print('index: $index');
    if (_validateAndSaveForm()) {
      //pop to previous page
      Navigator.of(context).pop([title, comment, dateNew, index]);
    }
  }
}
