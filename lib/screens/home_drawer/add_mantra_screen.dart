import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iMomentum/app/common_widgets/add_screen_top_row.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/models/mantra_model.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/screens/todo_screen/add_todo_screen.dart';
import 'package:provider/provider.dart';
import 'package:iMomentum/app/utils/extension_firstCaps.dart';

class AddMantraScreen extends StatefulWidget {
  const AddMantraScreen({this.database, this.mantra});
  final MantraModel mantra;
  final Database database;

  @override
  _AddMantraScreenState createState() => _AddMantraScreenState();
}

class _AddMantraScreenState extends State<AddMantraScreen> {
  final _formKey = GlobalKey<FormState>();

  ///need to add
//  bool processing;

  String title;

  MantraModel get mantra => widget.mantra;
  Database get database => widget.database;

  @override
  void initState() {
    if (mantra != null) {
      title = mantra.title;
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
                  title: mantra != null ? 'Edit Mantra' : 'Add Mantra'),
              buildSizedBoxMantra(_darkTheme),
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

  SizedBox buildSizedBoxMantra(bool _darkTheme) {
    return SizedBox(
      width: 350,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextFormField(
          initialValue: title,
          validator: (value) =>
              value.isNotEmpty ? null : 'Mantra can\'t be empty',
          onSaved: (value) => title = value.firstCaps,
          onFieldSubmitted: (value) {
            title = value.firstCaps;
            _save();
          },
          maxLength: 50,
          style: buildTextStyleMantra(_darkTheme),
          autofocus: true,
          cursorColor: _darkTheme ? darkThemeButton : lightThemeButton,
          // keyboardType: TextInputType.multiline,
          // maxLines: null,
          keyboardAppearance: _darkTheme ? Brightness.dark : Brightness.light,
          decoration: InputDecoration(
            hintText: 'Your favourite mantra',
            hintStyle: buildTextStyleMantraHint(_darkTheme),
            focusedBorder: buildUnderlineInputBorder(_darkTheme),
            enabledBorder: buildUnderlineInputBorder(_darkTheme),
          ),
        ),
      ),
    );
  }

  TextStyle buildTextStyleMantraHint(bool _darkTheme) {
    return TextStyle(
        fontSize: 15, color: _darkTheme ? darkThemeHint : lightThemeHint);
  }

  TextStyle buildTextStyleMantra(bool _darkTheme) {
    return TextStyle(
        fontSize: 18.0, color: _darkTheme ? darkThemeWords : lightThemeWords);
  }

  UnderlineInputBorder buildUnderlineInputBorder(bool _darkTheme) {
    return UnderlineInputBorder(
        borderSide:
            BorderSide(color: _darkTheme ? darkThemeHint : lightThemeHint));
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
        final id = mantra?.id ?? documentIdFromCurrentDate();

        ///first we find this specific Todo item that we want to update
        final newMantra = MantraModel(
          id: id,
          title: title,
          date: DateTime.now(),
        );
        //add newTodo to database
        await database.setMantra(newMantra);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
//      //close bottom modal
      Navigator.of(context).pop();
    }
  }
}
