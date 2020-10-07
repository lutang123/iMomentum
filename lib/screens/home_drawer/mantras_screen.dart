import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_fab.dart';
import 'package:iMomentum/app/common_widgets/my_list_tile.dart';
import 'package:iMomentum/app/common_widgets/my_stack_screen.dart';
import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/setting_switch.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/my_strings.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/mantra_model.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/home_drawer/top_title.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_mantra_screen.dart';
import 'empty_or_error_mantra.dart';

class MyMantras extends StatefulWidget {
  final Database database;

  const MyMantras({Key key, this.database}) : super(key: key);
  @override
  _MyMantrasState createState() => _MyMantrasState();
}

class _MyMantrasState extends State<MyMantras> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    ///for mantra
    final mantraNotifier = Provider.of<MantraNotifier>(context);
    bool _mantraOn = mantraNotifier.getMantra();
    return MyStackScreen(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: CustomizedContainerNew(
          color: _darkTheme ? darkThemeSurface : lightThemeSurface,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                MantraTopTitle(
                  title: 'Mantras',
                  subtitle: 'Simple phrases to build positive mental habits.',
                  onPressed: _showTipDialog,
                  darkTheme: _darkTheme,
                ),
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
                                SizedBox(
                                  width: 320,
                                  child: SettingSwitchNoIcon(
                                    title: 'Apply Your Own Mantras',
                                    value:
                                        mantras.length > 0 ? _mantraOn : false,
                                    onChanged: (val) {
                                      _mantraOn = val;
                                      onMantraChanged(val, mantraNotifier);
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: _hideMantras,
                                  child: Expanded(
                                    child: buildListView(
                                      widget.database,
                                      mantras,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return EmptyOrErrorMantra(
                            hideEmptyMessage: _hideEmptyMessage,
                            text1: Strings.textMantra1,
                            text2: Strings.textMantra2,
                          );
                        }
                      } else if (snapshot.hasError) {
                        return EmptyOrErrorMantra(
                          hideEmptyMessage: _hideEmptyMessage,
                          text1: Strings.textMantra1,
                          text2: Strings.textError,
                        );
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
        child: MyFAB(onPressed: () => _add(widget.database)),
      ),
    ));
  }

  Future<void> _showTipDialog() async {
    await PlatformAlertDialog(
      title: 'Tips',
      content: Strings.tipsOnMantraScreen,
      defaultActionText: 'OK.',
    ).show(context);
  }

  Future<void> onMantraChanged(
      bool value, MantraNotifier mantraNotifier) async {
    //save settings
    mantraNotifier.setMantra(value);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('useMyMantras', value);
  }

  /// all the context outside of build method is from previous page (HomeDrawer)
  ListView buildListView(Database database, List<MantraModel> mantras) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return ListView.separated(
        itemCount: mantras.length + 2,
        separatorBuilder: (context, index) => Divider(
              indent: 15,
              endIndent: 15,
              height: 0.5,
              color: _darkTheme ? Colors.white70 : Colors.black38,
            ),
        itemBuilder: (context, index) {
          if (index == 0 || index == mantras.length + 1) {
            return Container();
          }
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
                color: _darkTheme ? Colors.black12 : lightThemeNoPhotoColor,
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
                color: _darkTheme ? Colors.black12 : lightThemeNoPhotoColor,
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
    setState(() {
      _fabVisible = false;
    });
    try {
      await widget.database.deleteMantra(mantra);
      //PlatformException is from import 'package:flutter/services.dart';
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }

    ///must not add BuildContext context in the function, context should be red color

    /// all the context outside of build method is from previous page (HomeDrawer)
    Flushbar(
      isDismissible: true,
      mainButton: FlatButton(
          onPressed: () {
            setState(() {
              _fabVisible = false;
            });
            widget.database.setMantra(mantra);

            ///must remove
            // Navigator.pop(context);
          },
          child: FlushBarButtonChild(
            title: 'UNDO',
          )),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(8),
      borderRadius: 10,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundGradient: KFlushBarGradient,
      duration: Duration(seconds: 5),
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

    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => AddMantraScreen(
              database: database,
              mantra: mantra,
            ));

    setState(() {
      _hideMantras = true;
      _fabVisible = true;
    });
  }
}
