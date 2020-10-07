import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/add_screen_top_row.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/my_strings.dart';
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
      // print('dateNew if NOT null: $dateNew');
      formattedDate = DateFormat('M/d/y').format(dateNew);
      //this gives an initial value;
      formattedDate == formattedToday
          ? _dateController.text = 'Today'
          : _dateController.text = _dateFormatter.format(dateNew);
      // print('widget.dateController.text if NOT null: ${_dateController.text}');
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
      // print('dateNew in init if task is null: $dateNew'); //if task is null, we used pickedDate which we passed by
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
      items.add(DropdownMenuItem(value: category, child: Text(category)));
    }
    return items;
  }

  ///Todo: change design
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
    double width = MediaQuery.of(context).size.width;
    // print('height: $height'); //
    // Android: height: 683.4285714285714;
    // iPhone large: height: 896,
    // iPhone small: height: 667.0
    // print('width: $width'); //width: 411.42857142857144; width: 414, width: 375.0
    return SingleChildScrollView(
      child: CustomizedBottomSheet(
        color: _darkTheme ? darkThemeAdd : lightThemeNoPhotoColor,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: <Widget>[
                AddScreenTopRow(
                  title: todo != null ? 'Edit Task' : 'Add Task',
                ),
                buildDateRow(width, _darkTheme),
                buildSizedBoxTitle(_darkTheme), //title
                buildSizedBoxComment(_darkTheme), //comment
                SizedBox(height: 8),
                buildSizedBoxCategory(_darkTheme, context), //category
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
      ),
    );
  }

  Row buildDateRow(double width, bool _darkTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width * 0.15, //width / 6,
          child: Center(
            child: TextFormField(
              controller: _dateController, //this is TextEditingController
              focusNode: _dateFocusNode,
              readOnly: true,
              style: TextStyle(
                fontSize: 17,
                fontStyle: FontStyle.italic,
                color: _darkTheme ? darkThemeWords : lightThemeWords,
                // fontWeight: FontWeight.w600,
              ),
              decoration: KTransparentInputDecoration,
              onTap: _handleDatePicker,
            ),
          ),
        ),
        InkWell(
          onTap: _handleDatePicker,
          child: Icon(EvaIcons.calendarOutline,
              color: _darkTheme ? darkThemeButton : lightThemeButton),
        ),
      ],
    );
  }

  Row buildDateRowText(double width, bool _darkTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width * 0.15, //width / 6,
          child: Center(
            child: TextFormField(
              controller: _dateController, //this is TextEditingController
              focusNode: _dateFocusNode,
              readOnly: true,
              style: TextStyle(
                fontSize: 17,
                fontStyle: FontStyle.italic,
                color: _darkTheme ? darkThemeWords : lightThemeWords,
                // fontWeight: FontWeight.w600,
              ),
              decoration: KTransparentInputDecoration,
              onTap: _handleDatePicker,
            ),
          ),
        ),
        InkWell(
          onTap: _handleDatePicker,
          child: Icon(EvaIcons.calendarOutline,
              color: _darkTheme ? darkThemeButton : lightThemeButton),
        ),
      ],
    );
  }

  SizedBox buildSizedBoxCategory(bool _darkTheme, BuildContext context) {
    return SizedBox(
      width: 350,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Task Category',
            style: buildTextStyleCommentHint(_darkTheme),
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
                iconEnabledColor:
                    _darkTheme ? darkThemeButton : lightThemeButton
                // dropdownColor: darkThemeAdd,
//                          focusColor: Colors.orangeAccent,
                ),
          ),
        ],
      ),
    );
  }

  SizedBox buildSizedBoxComment(bool _darkTheme) {
    return SizedBox(
      width: 350,
      child: TextFormField(
        keyboardAppearance: _darkTheme ? Brightness.dark : Brightness.light,
        initialValue: comment,
//                    focusNode: _textFocusNode, //no need
        ///we need to keep keyboard open, can not have .done
//                    textInputAction: TextInputAction.done,
        onSaved: (value) => comment = value,
        style: buildTextStyleComment(_darkTheme),
        cursorColor: _darkTheme ? darkThemeButton : lightThemeButton,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'Comment (optional)',
          hintStyle: buildTextStyleCommentHint(_darkTheme),
          focusedBorder: buildUnderlineInputBorder(_darkTheme),
          enabledBorder: buildUnderlineInputBorder(_darkTheme),
        ),
      ),
    );
  }

  SizedBox buildSizedBoxTitle(bool _darkTheme) {
    return SizedBox(
      width: 350, //width * 0.85,
      child: TextFormField(
        keyboardAppearance: _darkTheme ? Brightness.dark : Brightness.light,
        initialValue: title,
        focusNode: _textFocusNode,
        // textInputAction: TextInputAction.done, //we can not have this
        validator: (value) {
          if (value.isNotEmpty) {
            return null;
          } else if (value.length > 100) {
            return Strings.over100MaxWarning;
          } else {
            return 'Task title can\'t be empty';
          }
        },
        onSaved: (value) => title = value,
        onFieldSubmitted: (value) {
          title = value;
          _save();
        },
        style: buildTextStyleTitle(_darkTheme),
        autofocus: true,
        cursorColor: _darkTheme ? darkThemeButton : lightThemeButton,
        // can not remove this
        // keyboardType: TextInputType.multiline,
        // maxLines: null,
        maxLength: 100,
        decoration: InputDecoration(
          ///https://stackoverflow.com/questions/51893926/how-can-i-hide-letter-counter-from-bottom-of-textfield-in-flutter#:~:text=To%20hide%20counter%20value%20from,InputDecoration%20property%20with%20empty%20value.
          counterText: "",
          hintText: 'Title',
          hintStyle: buildTextStyleTitleHint(_darkTheme),
          focusedBorder: buildUnderlineInputBorder(_darkTheme),
          enabledBorder: buildUnderlineInputBorder(_darkTheme),
        ),
      ),
    );
  }

  TextStyle buildTextStyleCommentHint(bool _darkTheme) {
    return TextStyle(
        fontSize: 13, color: _darkTheme ? darkThemeHint : lightThemeHint);
  }

  TextStyle buildTextStyleComment(bool _darkTheme) {
    return TextStyle(
        color: _darkTheme
            ? darkThemeWords.withOpacity(0.8)
            : lightThemeWords.withOpacity(0.8),
        fontSize: 14.0);
  }

  TextStyle buildTextStyleTitleHint(bool _darkTheme) {
    return TextStyle(
        fontSize: 15, color: _darkTheme ? darkThemeHint : lightThemeHint);
  }

  TextStyle buildTextStyleTitle(bool _darkTheme) {
    return TextStyle(
        fontSize: 18.0, color: _darkTheme ? darkThemeWords : lightThemeWords);
  }

  UnderlineInputBorder buildUnderlineInputBorder(bool _darkTheme) {
    return UnderlineInputBorder(
        borderSide: BorderSide(
            color: _darkTheme ? darkThemeDivider : lightThemeDivider));
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      //validate
      form.save(); //save
      return true;
    }
    return false;
  }

  Future<void> _save() async {
    final index = _categories.indexOf(_currentCategory);
    if (_validateAndSaveForm()) {
      Navigator.of(context).pop([title, comment, dateNew, index]);
    }
  }
}
