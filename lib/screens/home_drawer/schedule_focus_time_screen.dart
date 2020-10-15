import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_stack_screen.dart';
import 'package:iMomentum/app/common_widgets/setting_switch.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/home_drawer/mantra_top_title.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleFocusTime extends StatefulWidget {
  @override
  _ScheduleFocusTimeState createState() => _ScheduleFocusTimeState();
}

class _ScheduleFocusTimeState extends State<ScheduleFocusTime> {
  final now = DateTime.now();
  int startHour;
  int endHour;
  int newStartHour;
  int newEndHour;
  bool isBalance;
  // bool isWeekDay;
  // bool isSelected;

  @override
  void initState() {
    final startHourNotifier =
        Provider.of<StartHourNotifier>(context, listen: false);
    startHour = startHourNotifier.getStartHour();
    final endHourNotifier =
        Provider.of<EndHourNotifier>(context, listen: false);
    endHour = endHourNotifier.getEndHour();
    final balanceNotifier =
        Provider.of<BalanceNotifier>(context, listen: false);
    isBalance = balanceNotifier.getBalance();
    // final weekdayNotifier =
    //     Provider.of<WeekDayNotifier>(context, listen: false);
    // isWeekDay = weekdayNotifier.getWeekDay();
    // isSelected = isWeekDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return MyStackScreen(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: CustomizedContainerNew(
          color: _darkTheme ? darkThemeSurface : lightThemeSurface,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      MantraTopTitle(
                        title: 'Balance',
                        subtitle:
                            'Balance your day with periods of uptime and downtime.',
                        flatButtonText: '',
                        onPressed: null,
                        darkTheme: _darkTheme,
                      ),
                      buildContent(_darkTheme),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget buildContent(bool _darkTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
              color: _darkTheme ? darkThemeDivider : lightThemeDivider,
              thickness: 1),
          SettingSwitchNoIcon(
            title: 'Enable Balance Mode',
            value: isBalance ? true : false,
            onChanged: (val) {
              isBalance = val;
              _onBalanceChanged(val);
            },
          ),
          Text('Hide productivity features during downtime'),
          Divider(
              color: _darkTheme ? darkThemeDivider : lightThemeDivider,
              thickness: 1),
          SizedBox(height: 15),
          Text('UPTIME SCHEDULE',
              style: TextStyle(
                  fontSize: 25,
                  color: _darkTheme ? darkThemeWords : lightThemeWords,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          Text(
            'Times when productivity features are active',
            style: GoogleFonts.varelaRound(
              fontSize: 18,
              color: _darkTheme
                  ? darkThemeWords.withOpacity(0.9)
                  : lightThemeWords.withOpacity(0.9),
              // fontStyle: FontStyle.italic,
            ),
          ),
          Divider(
              color: _darkTheme ? darkThemeDivider : lightThemeDivider,
              thickness: 1),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Hours of the day', style: buildTextStyle(_darkTheme)),
              IconButton(
                  icon: Icon(
                    EvaIcons.edit2Outline,
                    size: 26,
                    color: _darkTheme ? darkThemeButton : lightThemeButton,
                  ),
                  onPressed: showEditDialog //_toggleVisibility,
                  ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                'Morning Start Time: ',
                style: _darkTheme ? KDialogContent : KDialogContentLight,
              ),
              SizedBox(width: 30),
              Text(
                '${startHour.toString()} AM',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Text(
                'Evening End Time: ',
                style: _darkTheme ? KDialogContent : KDialogContentLight,
              ),
              SizedBox(width: 37),
              Text(
                '${endHour.toString()} PM',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ],
          ),
          // Divider(
          //     color: _darkTheme ? darkThemeDivider : lightThemeDivider,
          //     thickness: 1),
          // SizedBox(height: 15),
          // Text('Days of the week', style: buildTextStyle(_darkTheme)),
          // SizedBox(height: 15),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     InkWell(
          //         onTap: _onTapWeekdays,
          //         child: Text('Weekdays',
          //             style: isWeekDayStyle(_darkTheme, isWeekDay))),
          //     InkWell(
          //         onTap: _onTapEveryday,
          //         child: Text('Everyday',
          //             style: isWeekendStyle(_darkTheme, isWeekDay))),
          //   ],
          // ),
        ],
      ),
    );
  }

  // TextStyle isWeekDayStyle(bool _darkTheme, bool isWeekDay) {
  //   return TextStyle(
  //       fontSize: 16,
  //       color: _darkTheme
  //           ? isSelected
  //               ? darkThemeButton
  //               : darkThemeWords
  //           : isSelected
  //               ? lightThemeButton
  //               : lightThemeWords);
  // }
  //
  // TextStyle isWeekendStyle(bool _darkTheme, bool isWeekDay) {
  //   return TextStyle(
  //       fontSize: 16,
  //       color: _darkTheme
  //           ? !isSelected
  //               ? darkThemeButton
  //               : darkThemeWords
  //           : !isSelected
  //               ? lightThemeButton
  //               : lightThemeWords);
  // }

  TextStyle buildTextStyle(bool _darkTheme) {
    return TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _darkTheme ? darkThemeWords : lightThemeWords);
  }

  final _formKey = GlobalKey<FormState>();
  // bool _isDifferentLength = false; //this is for changing duration.
  void showEditDialog() async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    await showDialog(
      context: context,
      builder: (BuildContext _) {
        ///cancel and done button all have context from here
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(top: 10.0),
            backgroundColor:
                _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Change Uptime Schedule",
                textAlign: TextAlign.center,
                style: _darkTheme ? KDialogTitle : KDialogTitleLight),
            content: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    rowFocusLength(_darkTheme, setState),
                    rowRestLength(_darkTheme, setState),
                    SizedBox(height: 5),
                    rowButton(_darkTheme, context),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Row rowFocusLength(bool _darkTheme, StateSetter setState) {
    // final startHourNotifier = Provider.of<StartHourNotifier>(context);
    // int startHour = startHourNotifier.getStartHour();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Morning Start Time',
          style: _darkTheme ? KDialogContent : KDialogContentLight,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 70,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    initialValue: startHour.toString(),

                    ///int.tryParse returns a null on an invalid number;
                    ///int.parse returns an exception on an invalid number;
                    //it does not matter in this case, because it's always number
                    validator: (value) {
                      return (value.isNotEmpty) &&
                              (int.parse(value) > 0) &&
                              (int.parse(value) <= 12)
                          ? null
                          : 'Error';
                    },
                    // onChanged: (value) {
                    //   setState(() {
                    //     startHour != int.tryParse(value)
                    //         ? _isDifferentLength = true
                    //         : _isDifferentLength = false;
                    //   });
                    // },
                    onChanged: (value) => newStartHour = int.tryParse(value),
                    onSaved: (value) => newStartHour = int.tryParse(value),
                    keyboardType: TextInputType.number,
                    style: _darkTheme ? KDialogContent : KDialogContentLight,
                    autofocus: true,
                    cursorColor: _darkTheme ? darkThemeWords : lightThemeWords,
                    decoration: _darkTheme
                        ? KTextFieldInputDecorationDark
                        : KTextFieldInputDecorationLight),
              ),
            ),
            Text('AM',
                style: _darkTheme ? KDialogContent : KDialogContentLight),
          ],
        ),
      ],
    );
  }

  Row rowRestLength(bool _darkTheme, StateSetter setState) {
    // final endHourNotifier = Provider.of<EndHourNotifier>(context);
    // int endHour = endHourNotifier.getEndHour();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Evening End Time',
            style: _darkTheme ? KDialogContent : KDialogContentLight),
        Row(
          children: <Widget>[
            SizedBox(
              width: 70,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    initialValue: endHour.toString(),
                    validator: (value) =>
                        (value.isNotEmpty) && (int.parse(value) > 0)
                            ? null
                            : 'error',
                    onChanged: (value) {
                      newEndHour = int.parse(value);
                    },
                    onSaved: (value) async {
                      newEndHour = int.parse(value);
                      // print('endHour in onSaved: $newEndHour');
                    },
                    keyboardType: TextInputType.number,
                    style: _darkTheme ? KDialogContent : KDialogContentLight,
                    cursorColor: _darkTheme ? darkThemeWords : lightThemeWords,
                    decoration: _darkTheme
                        ? KTextFieldInputDecorationDark
                        : KTextFieldInputDecorationLight),
              ),
            ),
            Text('PM',
                style: _darkTheme ? KDialogContent : KDialogContentLight),
          ],
        ),
      ],
    );
  }

  Padding rowButton(bool _darkTheme, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlatButton(
              child: Text(
                'Cancel',
                style: _darkTheme ? KDialogButton : KDialogButtonLight,
              ),
              shape:

                  ///can't make this change in this case
                  // _isDifferentLength == false
                  //     ? null
                  //     :
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(68.0),
                      side: BorderSide(
                          // color: _darkTheme ? darkThemeHint : lightThemeHint,
                          color: Colors.red,
                          width: 1.0)),
              onPressed: () {
                // setState(() {
                //   _topOpacity = 1.0;
                // });
                Navigator.of(context).pop();
              }),
          FlatButton(
              child: Text(
                'Done',
                style: _darkTheme ? KDialogButton : KDialogButtonLight,
              ),
              shape:
                  // _isDifferentLength == false
                  //     ?
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(68.0),
                      side: BorderSide(
                          // color: _darkTheme ? darkThemeHint : lightThemeHint,
                          color:
                              _darkTheme ? darkThemeButton : lightThemeButton,
                          width: 1.0)),
              // : null,

              ///_done must have a BuildContext, so that it will
              ///use the same context as cancel button, which is all from StatefulBuilder
              onPressed: () => _done(context)),
        ],
      ),
    );
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState; //validate
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  ///when we don't have BuildContext context, we used a wrong context and it popped to home screen
  Future<void> _done(BuildContext context) async {
    print('newStartHour: $newStartHour'); //
    print('newEndHour: $newEndHour'); //
    if (_validateAndSaveForm()) {
      var prefs = await SharedPreferences.getInstance(); //save settings
      prefs.setInt('startHour', newStartHour);
      prefs.setInt('endHour', newEndHour);
      setState(() {
        startHour = newStartHour;
        endHour = newEndHour;
      });
      Navigator.of(context).pop();
    }
  }

  Future<void> _onBalanceChanged(bool value) async {
    final balanceNotifier = Provider.of<BalanceNotifier>(context);
    balanceNotifier.setBalance(value); //change the value
    var prefs = await SharedPreferences.getInstance(); //save settings
    prefs.setBool('isBalance', value);
  }

  // Future<void> _onTapWeekdays() async {
  //   setState(() {
  //     isSelected = !isSelected;
  //   });
  //   final weekDayNotifier = Provider.of<WeekDayNotifier>(context);
  //   weekDayNotifier.setWeekDay(true);
  //   var prefs = await SharedPreferences.getInstance(); //save settings
  //   prefs.setBool('isWeekday', true);
  // }
  //
  // Future<void> _onTapEveryday() async {
  //   setState(() {
  //     isSelected = !isSelected;
  //   });
  //   final weekDayNotifier = Provider.of<WeekDayNotifier>(context);
  //   weekDayNotifier.setWeekDay(false);
  //   var prefs = await SharedPreferences.getInstance(); //save settings
  //   prefs.setBool('isWeekday', false);
  // }
}

/// tried to make it like changing use name, but don't know how to save the value
/// because it's all numbers and not done button
// bool _amVisible = true;
// bool _pmVisible = true;
//
// Row timeRow(bool _darkTheme, String text1, String initialValue, onSaved,
//     String text2, visible, onPressed) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Row(
//         children: <Widget>[
//           Text(
//             text1,
//             style: _darkTheme ? KDialogContent : KDialogContentLight,
//           ),
//           SizedBox(width: 20),
//           Visibility(
//               visible: visible,
//               child: Text(
//                 '$initialValue $text2',
//                 style: TextStyle(decoration: TextDecoration.underline),
//               )),
//           // Visibility(
//           //     visible: !visible,
//           //     child:
//           //         rowTextFormField(initialValue, onSaved, _darkTheme, text2)),
//         ],
//       ),
//       // IconButton(
//       //     icon: Icon(
//       //       visible ? EvaIcons.edit2Outline : Icons.clear,
//       //       size: 26,
//       //       color: _darkTheme ? darkThemeButton : lightThemeButton,
//       //     ),
//       //     onPressed: onPressed //_toggleVisibility,
//       //     ),
//     ],
//   );
// }

// timeRow(_darkTheme, 'Start Time: ','' ,
//     (value) async {
//   startHour = int.tryParse(value);
//   var prefs = await SharedPreferences.getInstance(); //save settings
//   prefs.setInt('startHour', startHour);
// }, 'AM', _amVisible, _toggleVisibilityAM),
// timeRow(_darkTheme, 'End Time: ', endHour.toString(), (value) async {
//   endHour = int.tryParse(value);
//   var prefs = await SharedPreferences.getInstance(); //save settings
//   prefs.setInt('endHour', endHour);
// }, 'PM', _pmVisible, _toggleVisibilityPM),

// Row rowTextFormField(
//     String initialValue, onSaved, bool _darkTheme, String text2) {
//   return Row(
//     children: <Widget>[
//       SizedBox(
//         width: 70,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: textFormField(initialValue, onSaved, _darkTheme),
//         ),
//       ),
//       Text(text2, style: _darkTheme ? KDialogContent : KDialogContentLight),
//     ],
//   );
// }
//
// TextFormField textFormField(String initialValue, onSaved, bool _darkTheme) {
//   return TextFormField(
//       initialValue: initialValue,
//
//       ///int.tryParse returns a null on an invalid number;
//       ///int.parse returns an exception on an invalid number;
//       //it does not matter in this case, because it's always number
//       validator: (value) =>
//       (value.isNotEmpty) && (int.parse(value) > 0) ? null : 'error',
//       onSaved: onSaved,
//       keyboardType: TextInputType.number,
//       style: _darkTheme ? KDialogContent : KDialogContentLight,
//       autofocus: true,
//       cursorColor: _darkTheme ? darkThemeWords : lightThemeWords,
//       decoration: _darkTheme
//           ? KTextFieldInputDecorationDark
//           : KTextFieldInputDecorationLight);
// }
