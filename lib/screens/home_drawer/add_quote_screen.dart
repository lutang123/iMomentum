import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iMomentum/app/common_widgets/add_screen_top_row.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/models/quote_model.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/screens/todo_screen/add_todo_screen.dart';
import 'package:provider/provider.dart';
import 'package:iMomentum/app/utils/extension_firstCaps.dart';

class AddQuoteScreen extends StatefulWidget {
  const AddQuoteScreen({this.database, this.quote});
  final QuoteModel quote;
  final Database database;

  @override
  _AddQuoteScreenState createState() => _AddQuoteScreenState();
}

class _AddQuoteScreenState extends State<AddQuoteScreen> {
  final _formKey = GlobalKey<FormState>();

  ///need to add
//  bool processing;

  String title;
  String author;

  QuoteModel get quote => widget.quote;
  Database get database => widget.database;

  @override
  void initState() {
    if (quote != null) {
      title = quote.title;
      author = quote.author;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SingleChildScrollView(
      child: CustomizedBottomSheet(
        color: _darkTheme ? darkThemeAdd : lightThemeAdd,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              AddScreenTopRow(
                  title: quote != null ? 'Edit Quote' : 'Add Quote'),
              SizedBox(
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    initialValue: title,
                    validator: (value) =>
                        value.isNotEmpty ? null : 'Quote can\'t be empty',
                    onSaved: (value) =>
                        title = value.firstCaps, //for save button
                    onFieldSubmitted: (value) {
                      title = value.firstCaps;
                      _save();
                    },
                    maxLength: 120,
                    style: TextStyle(
                        color: _darkTheme ? darkThemeWords : lightThemeWords,
                        fontSize: 18.0),
                    autofocus: true,
                    cursorColor:
                        _darkTheme ? darkThemeButton : lightThemeButton,
                    // keyboardType: TextInputType.multiline,
                    // maxLines: null,
                    keyboardAppearance:
                        _darkTheme ? Brightness.dark : Brightness.light,
                    decoration: InputDecoration(
                      hintText: 'Your favorite quote.',
                      hintStyle: TextStyle(
                          fontSize: 15,
                          color: _darkTheme ? Colors.white54 : Colors.black38),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  _darkTheme ? darkThemeHint : lightThemeHint)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  _darkTheme ? darkThemeHint : lightThemeHint)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    initialValue: author,
                    onSaved: (value) => author = value,
                    onEditingComplete: _save,
                    // maxLines: 1,
                    maxLength: 20,
                    style: TextStyle(
                        color: _darkTheme ? darkThemeWords : lightThemeWords,
                        fontSize: 18.0),
                    autofocus: true,
                    cursorColor:
                        _darkTheme ? darkThemeButton : lightThemeButton,
                    keyboardAppearance:
                        _darkTheme ? Brightness.dark : Brightness.light,
                    decoration: InputDecoration(
                      hintText: 'Author (optional)',
                      hintStyle: TextStyle(
                          fontSize: 15,
                          color: _darkTheme ? Colors.white54 : Colors.black38),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  _darkTheme ? darkThemeHint : lightThemeHint)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  _darkTheme ? darkThemeHint : lightThemeHint)),
                    ),
                  ),
                ),
              ),
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
    if (_validateAndSaveForm()) {
      try {
        final id = quote?.id ?? documentIdFromCurrentDate();

        final newQuote = QuoteModel(
            id: id, title: title, author: author, date: DateTime.now());
        //add newTodo to database
        await database.setQuote(newQuote);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
      Navigator.of(context).pop();
    }
  }
}
