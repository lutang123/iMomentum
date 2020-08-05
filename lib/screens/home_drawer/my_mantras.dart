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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<List<MantraModel>>(
                        stream: widget.database
                            .mantrasStream(), //print: flutter: Instance of '_MapStream<List<TodoDuration>, dynamic>'
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final List<MantraModel> mantras = snapshot
                                .data; //print('x: $entries'); //x: [Instance of 'TodoDuration', Instance of 'TodoDuration']
                            if (mantras.isNotEmpty) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: CustomizedContainerNew(
                                      color: _darkTheme
                                          ? darkSurfaceTodo
                                          : lightSurface,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                IconButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  icon: Icon(
                                                      Icons.arrow_back_ios,
                                                      size: 30),
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                            MantraTopBar(
                                              title: 'Mantras',
                                              subtitle:
                                                  'Simple phrases to build positive mental habits.',
                                            ),
//                                            SizedBox(height: 30),
//                                            Text(
//                                              'Get inspired by adding your personal mantras.',
//                                              style: Theme.of(context)
//                                                  .textTheme
//                                                  .headline5,
//                                              textAlign: TextAlign.center,
//                                            ),
                                            SizedBox(
                                              width: 350,
                                              child: ListTile(
                                                title: Text(
                                                    'Apply Your Own Mantras'),
                                                trailing: Transform.scale(
                                                  scale: 0.9,
                                                  child: CupertinoSwitch(
                                                    activeColor:
                                                        switchActiveColor,
                                                    trackColor: Colors.grey,
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
                                              ),
                                            ),
                                            Visibility(
                                              visible: _hideMantras,
                                              child: Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: buildListView(
                                                    widget.database,
                                                    mantras,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: CustomizedContainerNew(
                                      color: _darkTheme
                                          ? darkSurfaceTodo
                                          : lightSurface,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                IconButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  icon: Icon(
                                                      Icons.arrow_back_ios,
                                                      size: 30),
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                            MantraTopBar(
                                              title: 'Mantras',
                                              subtitle:
                                                  'Simple phrases to build positive mental habits.',
                                            ),
                                            SizedBox(height: 5),
                                            Spacer(),
//                                          Text(
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
                                            Visibility(
                                              visible: _hideEmptyMessage,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text(
                                                  'By default, Mantras from our curated feed will appear on Home screen. You can add your own mantras to personalize your experience.',
                                                  style: KEmptyContent,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Spacer()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(snapshot.error.toString()),
                                  EmptyMessage(
                                    title: 'Something went wrong',
                                    message:
                                        'Can\'t load items right now, please try again later',
                                  )
                                ],
                              ),
                            );
                          }
                          return Center(child: CircularProgressIndicator());
                        }),
                  ),
//                  Spacer(), //clear icon
                ],
              ),
            ),
            floatingActionButton: MyFAB(
                onPressed: () => _add(widget.database),
                child: Icon(Icons.add, size: 30, color: Colors.white)),
          ),
        )
      ],
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
            dismissal: SlidableDismissal(
              child: SlidableDrawerDismissal(),
              onDismissed: (actionType) {
                _delete(context, mantras[index - 1]);
              },
            ),
            actionExtentRatio: 0.25,
            child: MantraListTile(
              mantra: mantras[index - 1],
              onTap: () => _update(database, mantras[index - 1]),
            ),
            actions: <Widget>[
              IconSlideAction(
                caption: 'Edit',
                color: Colors.black12,
                iconWidget: FaIcon(
                  FontAwesomeIcons.edit,
                  color: Colors.white,
                ),
                onTap: () => _update(database, mantras[index - 1]),
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: Colors.black12,
                iconWidget: FaIcon(
                  FontAwesomeIcons.trashAlt,
                  color: Colors.white,
                ),
                onTap: () => _delete(context, mantras[index - 1]),
              ),
//              IconSlideAction(
//                caption: 'Select',
//                color: Colors.black12,
//                iconWidget: FaIcon(
//                  FontAwesomeIcons.check,
//                  color: Colors.white,
//                ),
//                onTap: () => selectOneMantra(mantraNotifier, index - 1),
//              ),
            ],
          );
        });
  }

//  Future<void> selectOneMantra(MantraNotifier mantraNotifier, int index) async {
//    //save settings
//    mantraNotifier.setMantraIndex(index);
//    var prefs = await SharedPreferences.getInstance();
//    prefs.setInt('indexMantra', index);
//  }

  Future<void> _delete(BuildContext context, MantraModel mantra) async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
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
          widget.database.setMantra(mantra);
        },
        child: Text(
          "UNDO",
          style: TextStyle(color: _darkTheme ? Colors.white : Colors.black87),
        ),
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(left: 10),
      borderRadius: 10,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundGradient: _darkTheme
          ? LinearGradient(colors: [
              Color(0xF0888888).withOpacity(0.85),
              Colors.black54,
            ])
          : LinearGradient(
              colors: [Color(0xF0888888).withOpacity(0.85), lightSurface]),
      duration: Duration(seconds: 4),
      titleText: Text(
        'Deleted',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            color: _darkTheme ? Colors.white : Colors.black87,
            fontFamily: "ShadowsIntoLightTwo"),
      ),
      messageText: Text(
        mantra.title,
        style: TextStyle(
            fontSize: 12.0,
            color: _darkTheme ? Colors.white : Colors.black87,
            fontFamily: "ShadowsIntoLightTwo"),
      ),
    )..show(context);
  }

  bool _hideEmptyMessage = true;
  bool _hideMantras = true;

  ///we didn't write add and update into one function because FAB don't have access on a specific mantra data
  Future<void> _add(Database database) async {
    setState(() {
      _hideEmptyMessage = false;
      _hideMantras = false;
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
    });
  }

  void _update(Database database, MantraModel mantra) async {
    setState(() {
      _hideMantras = false;
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
    });
  }

  Container deleteContainer() {
    return Container(
      color: Colors.black38,
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FaIcon(FontAwesomeIcons.trashAlt),
                Text(
                  'Delete',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
