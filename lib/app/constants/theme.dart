import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// switch active color Color(0xFFade498)a2de96
const Color switchActiveColor = Color(0xFF006a71); //Color(0xFF206a5d);
//const Color switchTrackColor = Color(0xFFffffdd);

//f6f5f5
//Drawer Icon and other Icons
const Color lightButton = Colors.black54; //button. icon
const Color darkButton = Color(0xFFE7E7E8); //same as app bar color

const Color lightHint = Colors.black38;
const Color darkHint = Colors.white54;

const Color lightTabContainer = Colors.white24;
const Color darkTabContainer = Color(0xF0F9F9F9);

const Color darkAppBar = Colors.black12;
//calendar
//drawer
const Color darkDrawer = Colors.black38;

//todo list and pie chart, note bkgd
const Color lightSurface = Color(0xF0F9F9F9);
const Color darkSurface = Color(0xFF333333);
const Color darkSurfaceTodo = Colors.black54;

const Color lightSurfaceMantras = Colors.white54;

//add todo and note
const Color lightAdd = Color(0xFFf5f5f6);
//const Color darkAdd = Color(0xFF333333);
///use in all modal bottom
const Color darkAdd = Colors.black45; //Color(0xf01b262c) : Colors.grey[50]

///image gallary, alert dialog, calendar bkgd
const Color darkBkgdColor = Color(0xf01b262c);

final ThemeData lightTheme = ThemeData.light().copyWith(
  // This makes the visual density adapt to the platform that you run
  // the app on. For desktop platforms, the controls will be smaller and
  // closer together (more dense) than on mobile platforms.
  visualDensity: VisualDensity.adaptivePlatformDensity,
  unselectedWidgetColor: Colors.black54,
//  disabledColor: Color(0xFFd0d0d1),
  canvasColor: Colors
      .transparent, //e.g. container box decoration, //primary color: e.g. app bar color
  accentColor: Colors.transparent, //e.g. button color
//  bottomSheetTheme: BottomSheetThemeData(
//    backgroundColor: Colors.transparent,
//  ),
//  splashColor: Colors.transparent,
  iconTheme: IconThemeData(color: lightButton),
//  buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
//NAME         SIZE  WEIGHT  SPACING
//headline1    96.0  light   -1.5
//headline2    60.0  light   -0.5
//headline3    48.0  regular  0.0
//headline4    34.0  regular  0.25
//headline5    24.0  regular  0.0
//headline6    20.0  medium   0.15
//subtitle1    16.0  regular  0.15
//subtitle2    14.0  medium   0.1
//body1        16.0  regular  0.5   (bodyText1)
//body2        14.0  regular  0.25  (bodyText2)
//button       14.0  medium   1.25
//caption      12.0  regular  0.4
//overline     10.0  regular  1.5

  textTheme: TextTheme(
    //todo title, add todo title
    headline5: TextStyle(
      //24
      color: Color(0xF0323232),
      fontWeight: FontWeight.w400,
    ),
    //pie chart subtitle
    headline6: GoogleFonts.varelaRound(
      //20
      color: Color(0xF0323232),
      fontWeight: FontWeight.w600,
    ),
    //calendar month
    subtitle1: TextStyle(
      color: Color(0xF03f3f44),
      fontWeight: FontWeight.w400,
      fontSize: 18.0,
    ),
    //Empty message
    subtitle2: TextStyle(
        color: Colors.black38, fontStyle: FontStyle.italic, fontSize: 15),
    //calendar date
    bodyText1: TextStyle(
      //16
      color: Colors.black38,
    ),
    bodyText2: TextStyle(color: Colors.black38), //14
  ),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  // This makes the visual density adapt to the platform that you run
  // the app on. For desktop platforms, the controls will be smaller and
  // closer together (more dense) than on mobile platforms.
  visualDensity: VisualDensity.adaptivePlatformDensity,
  unselectedWidgetColor: Colors.white,
  accentColor: Colors.transparent, //e.g. container box decoration
  canvasColor: Colors.transparent, //e.g. button color
  iconTheme: IconThemeData(color: darkButton),
  appBarTheme: AppBarTheme(color: Color(0xf01b262c)),
  textTheme: TextTheme(
    //todo title, add todo title
    headline5: TextStyle(
      //24
//      color: Color(0xF0323232),
      fontWeight: FontWeight.w400,
    ),
    //pie chart subtitle
    headline6: GoogleFonts.varelaRound(
      //20
//      color: Color(0xF0323232),
      fontWeight: FontWeight.w600,
    ),
    //calendar month
    subtitle1: TextStyle(
//      color: Color(0xF03f3f44),
      fontWeight: FontWeight.w400,
      fontSize: 18.0,
    ),
    //Empty message
    subtitle2: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
    //calendar date
//    bodyText1: TextStyle(
//      //16
//      color: Colors.black38,
//    ),
//    bodyText2: TextStyle(color: Colors.black38), //14
  ),
  dialogBackgroundColor: darkBkgdColor,
  dialogTheme: DialogTheme(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)))),
);
