import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/models/mantra_model.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:provider/provider.dart';

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
        color: _darkTheme ? darkAdd : lightAdd,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Text(mantra != null ? 'Edit Mantra' : 'Add Mantra',
                  style: Theme.of(context).textTheme.headline5),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    initialValue: title,
                    validator: (value) =>
                        value.isNotEmpty ? null : 'Mantra can\'t be empty',
                    onSaved: (value) => title = value,
                    style: TextStyle(
                        color: _darkTheme ? Colors.white : Color(0xF01b262c),
                        fontSize: 20.0),
                    autofocus: true,
                    textAlign: TextAlign.center,
                    cursorColor: _darkTheme ? Colors.white : lightButton,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: 60,
                    decoration: InputDecoration(
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
//              SizedBox(height: 20),
              MyFlatButton(
                  onPressed: _save,
                  text: 'SAVE',
                  color: _darkTheme ? Colors.white : lightButton),
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
//      //pop to previous page
      Navigator.of(context).pop();
//      int count = 0;
//      Navigator.popUntil(context, (route) {
//        return count++ == 2;
//      });
    }
  }
}
