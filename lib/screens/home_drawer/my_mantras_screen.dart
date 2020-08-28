import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/empty_content.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_fab.dart';
import 'package:iMomentum/app/common_widgets/my_list_tile.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/setting_switch.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/mantra_model.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/iPomodoro/clock_title.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_mantra.dart';

class MyMantras extends StatefulWidget {
  final Database database;

  const MyMantras({Key key, this.database}) : super(key: key);
  @override
  _MyMantrasState createState() => _MyMantrasState();
}

class _MyMantrasState extends State<MyMantras> {
  int counter = 0;
  void _onDoubleTap() {
    setState(() {
      ImageUrl.randomImageUrl =
          'https://source.unsplash.com/random?nature/$counter';
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final randomNotifier = Provider.of<RandomNotifier>(context);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context);

    ///for mantra
    final mantraNotifier = Provider.of<MantraNotifier>(context);
    bool _mantraOn = mantraNotifier.getMantra();
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        BuildPhotoView(
          imageUrl:
              _randomOn ? ImageUrl.randomImageUrl : imageNotifier.getImage(),
        ),
        ContainerLinearGradient(),
        GestureDetector(
          onDoubleTap: _onDoubleTap,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              bottom: false,
              child: CustomizedContainerNew(
                color: _darkTheme ? darkThemeSurfaceTodo : lightThemeSurface,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _topRow(),
                      StreamBuilder<List<MantraModel>>(
                          stream: widget.database
                              .mantrasStream(), //print: flutter: Instance of '_MapStream<List<TodoDuration>, dynamic>'
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final List<MantraModel> mantras = snapshot
                                  .data; //print('x: $entries'); //x: [Instance of 'TodoDuration', Instance of 'TodoDuration']
                              if (mantras.isNotEmpty) {
                                return Expanded(
                                  child: Column(
                                    children: <Widget>[
//                                            SizedBox(height: 30),
//                                            Text(
//                                              'Get inspired by adding your personal mantras.',
//                                              style: Theme.of(context)
//                                                  .textTheme
//                                                  .headline5,
//                                              textAlign: TextAlign.center,
//                                            ),
                                      SizedBox(
                                        width: 320,
                                        child: SettingSwitchNoIcon(
                                          title: 'Apply Your Own Mantras',
                                          value: mantras.length > 0
                                              ? _mantraOn
                                              : false,
                                          onChanged: (val) {
                                            _mantraOn = val;
                                            onMantraChanged(
                                                val, mantraNotifier);
                                          },
                                        ),
                                      ),
                                      Visibility(
                                        visible: _hideMantras,
                                        child: Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: buildListView(
                                              widget.database,
                                              mantras,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return _noMantraOrErrorContent();
                              }
                            } else if (snapshot.hasError) {
                              return _noMantraOrErrorContent();
                            }
                            return Center(child: CircularProgressIndicator());
                          }),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: Visibility(
              visible: _fabVisible,
              child: MyFAB(
                  onPressed: () => _add(widget.database),
                  child: Icon(Icons.add, size: 30, color: Colors.white)),
            ),
          ),
        )
      ],
    );
  }

  Widget _topRow() {
    return MantraTopBar(
      title: 'Mantras',
      subtitle: 'Simple phrases to build positive mental habits.',
    );
  }

  Widget _noMantraOrErrorContent() {
    return Expanded(
      child: Column(
        children: <Widget>[
          Spacer(),
          //Text(
          //'Power up your day with your favorite quotes.',)
          Visibility(
            visible: _hideEmptyMessage,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  // Text(
//                                            'Center yourself with friendly reminders, reinforce new thought patterns, and bring attention to the values or principles that are most important to you.',
//                                            style: KEmptyContent,
//                                            textAlign: TextAlign.center,
//                                          ),
//                                        Text(
//                                                      'Get inspired by adding your personal mantras. ',
//                                                      style: KEmptyContent,
//                                                      textAlign:
//                                                          TextAlign.center,
//                                                    ),
//                                                    SizedBox(height: 5),
                  Text(
                    'By default, Mantras from our curated feed will appear on Home screen.',
                    style: KEmptyContent,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                      'You can add your own mantras to personalize your experience.',
                      style: KEmptyContent,
                      textAlign: TextAlign.center)
                ],
              ),
            ),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }

  Future<void> onMantraChanged(
      bool value, MantraNotifier mantraNotifier) async {
    //save settings
    mantraNotifier.setMantra(value);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('useMyMantras', value);
  }

  ListView buildListView(Database database, List<MantraModel> mantras) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return ListView.separated(
        itemCount: mantras.length + 2,
        separatorBuilder: (context, index) => Divider(
              indent: 15,
              endIndent: 15,
              height: 0.5,
              color: _darkTheme ? Colors.white70 : Colors.black38,
            ),
//        shrinkWrap: true,
//        itemCount: anyList.length, //The getter 'length' was called on null.
        itemBuilder: (context, index) {
          //or index == 0 or index == the last, we return an empty container
          if (index == 0 || index == mantras.length + 1) {
            return Container();
          }
          //itemBuilder(context, items[index - 1]);
          return Slidable(
            key: UniqueKey(),
            closeOnScroll: true,
            actionPane: SlidableDrawerActionPane(),
            // dismissal: SlidableDismissal(
            //   child: SlidableDrawerDismissal(),
            //   onDismissed: (actionType) {
            //     _delete(mantras[index - 1]);
            //   },
            // ),
            actionExtentRatio: 0.25,
            child: MantraListTile(
              mantra: mantras[index - 1],
              onTap: () => _update(database, mantras[index - 1]),
            ),
            actions: <Widget>[
              IconSlideAction(
                caption: 'Edit',
                foregroundColor: Colors.blue,
                color: Colors.black12,
                iconWidget: FaIcon(
                  EvaIcons.edit2Outline,
                  color: Colors.blue,
                ),
                onTap: () => _update(database, mantras[index - 1]),
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                foregroundColor: Colors.red,
                color: Colors.black12,
                iconWidget: Icon(
                  EvaIcons.trash2Outline,
                  color: Colors.red,
                ),
                onTap: () => _delete(mantras[index - 1]),
              ),
            ],
          );
        });
  }

  bool _fabVisible = true;
  Future<void> _delete(MantraModel mantra) async {
    try {
      await widget.database.deleteMantra(mantra);
      //PlatformException is from import 'package:flutter/services.dart';
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }

    Flushbar(
      isDismissible: true,
      mainButton: FlatButton(
          onPressed: () {
            setState(() {
              _fabVisible = false;
            });
            widget.database.setMantra(mantra);
          },
          child: FlushBarButtonChild(
            title: 'UNDO',
          )),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(left: 10),
      borderRadius: 10,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundGradient: LinearGradient(colors: [
        Color(0xF0888888).withOpacity(0.85),
        Colors.black54,
      ]),
      duration: Duration(seconds: 3),
      titleText: Text(
        'Deleted',
        style: KFlushBarTitle,
      ),
      messageText: Text(
        mantra.title,
        style: KFlushBarMessage,
      ),
    )..show(context).then((value) => setState(() => _fabVisible = true));
  }

  bool _hideEmptyMessage = true;
  bool _hideMantras = true;

  ///we didn't write add and update into one function because FAB don't have access on a specific mantra data
  Future<void> _add(Database database) async {
    setState(() {
      _hideEmptyMessage = false;
      _hideMantras = false;
      _fabVisible = false;
    });
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => AddMantraScreen(
              database: database,
            ));
    setState(() {
      _hideEmptyMessage = true;
      _hideMantras = true;
      _fabVisible = true;
    });
  }

  void _update(Database database, MantraModel mantra) async {
    setState(() {
      _hideMantras = false;
      _fabVisible = false;
    });

    var _typedTitle = await showModalBottomSheet(
//        useRootNavigator: true,
        context: context,
        isScrollControlled: true,
        builder: (context) => AddMantraScreen(
              database: database,
              mantra: mantra,
            ));
    if (_typedTitle != null) {
      try {
        //we get the id from job in the firebase, if the job.id is null,
        //we create a new one, otherwise we use the existing job.id
        final id = mantra?.id ?? documentIdFromCurrentDate();

        ///first we find this specific Todo item that we want to update
        final newMantra =
            MantraModel(id: id, title: _typedTitle, date: DateTime.now());
        //add newTodo to database
        await database.setMantra(newMantra);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }

    setState(() {
      _hideMantras = true;
      _fabVisible = true;
    });
  }
}
