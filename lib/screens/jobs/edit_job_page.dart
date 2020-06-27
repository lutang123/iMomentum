import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/models/todo_model.dart';
import 'package:iMomentum/app/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, @required this.database, @required this.job})
      : super(key: key);
  final Database database;
  final TodoModel job;

  static Future<void> show(
      //position argument
      BuildContext context,
      //named argument
      {Database database,
      TodoModel job}) async {
    //rootNavigator: true to ensure this page not have bottom nav bar
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(database: database, job: job),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  int _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.title;
    }
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

  //we can not directly save data into database because we don't have access
  // to database from this level, we have to pass it from its parent
  // which is job page

  //we should also add FocusNode and loading state just like the email sign in page
  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.todosStream().first;
        final allNames = jobs.map((job) => job.title).toList();
        //and this is to make sure when we edit job, we can keep the name
        if (widget.job != null) {
          allNames.remove(widget.job.title);
        }
        //this is to make sure when we create job, we do not write the same name
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          //we get the id from job in the firebase, if the job.id is null,
          //we create a new one, otherwise we use the existing job.id
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = TodoModel(id: id, title: _name);
          await widget.database.setTodo(job);
          //pop to previous page
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job name'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        //if we edit an existing job, initial value might be null, if we add new,
        // then no initial value
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        // ?? means if it's null, then return 0
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      ),
    ];
  }
}
