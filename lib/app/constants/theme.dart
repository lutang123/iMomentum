import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color switchActiveColorLight = Color(0xFF006a71); //Color(0xFF206a5d);
const Color switchActiveColorUseInDark = Color(0xf0ffcb74); //Color(0xFF206a5d);

//f6f5f5
//Drawer Icon and other Icons
const Color darkThemeButton = Color(0xf0ffcb74);
const Color darkThemeButton2 = Color(0xf0ffcb74);
const Color darkThemeButton3 = Color(0xf0cffffe);
const Color darkThemeButton4 = Color(0xf040a8c4);
const Color lightThemeButton = Color(0xf0086972); //button. icon

const Color darkThemeHint = Colors.white60;
const Color lightThemeHint = Colors.black54;

const Color darkThemeHint2 = Colors.white70;
const Color lightThemeHint2 = Colors.black54;

const Color darkThemeWords = Colors.white;
const Color lightThemeWords = Colors.black87;

// app bar
const Color darkThemeAppBar = Colors.black12;
final Color lightThemeAppBar = Colors.white.withOpacity(0.5);

//drawer and NoteFolder
//also in photo Preview and ImagePage, and NotesInFolderScreen as AppBar color
const Color darkThemeDrawer = Colors.black26;

///used in EmptyContent in folder and notes screen, folder search bar and folder bottom row and folder container
final Color lightThemeDrawer = Colors.white.withOpacity(0.7);

//calendar, todoList and pie chart,
const Color darkThemeSurface = Colors.black38;
//used in TodoScreen for calendar and list, MyMantra and MyQuote
final Color lightThemeSurface = Colors.white.withOpacity(0.75);

const Color darkThemeDivider = Colors.white38;
const Color lightThemeDivider = Colors.black45;

///use in all modal bottom
const Color darkThemeAdd = Colors.black38; //Color(0xf01b262c) : Colors.grey[50]
//we can not use .withOpacity in const
final Color lightThemeAdd = Colors.white.withOpacity(0.7);

///image gallary, alert dialog, search photo
// const Color darkThemeNoPhotoBkgdColor = Color(0xf01b262c);
const Color darkThemeNoPhotoColor = Color(0xFF2D2F41); //f4f9f4
const Color lightThemeNoPhotoColor = Color(0xfff4f9f4); //Color(0xfffffafa)

///calendar
const Color darkThemeCalendarSelectedDay =
    Color(0xFF40a8c4); //Color(0xFF3282b8);
const Color lightThemeCalendarSelectedDay = Color(0xf0086972);

///Light theme
final ThemeData lightTheme = ThemeData.light().copyWith(
  // textSelectionColor:
  // This makes the visual density adapt to the platform that you run
  // the app on. For desktop platforms, the controls will be smaller and
  // closer together (more dense) than on mobile platforms.
  appBarTheme: AppBarTheme(color: lightThemeAppBar),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  unselectedWidgetColor: Colors.black54,
//  disabledColor: Color(0xFFd0d0d1),
  accentColor: Colors.transparent, //e.g. container box decoration
  canvasColor: Colors.transparent, //e.g. button color //e.g. button color
//  bottomSheetTheme: BottomSheetThemeData(
//    backgroundColor: Colors.transparent,
//  ),
//  splashColor: Colors.transparent,
  iconTheme: IconThemeData(color: lightThemeButton),
//  buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),

  textTheme: TextTheme(
    //todoList title,
    headline5: TextStyle(
      //24
      color: Color(0xF0323232),
      fontWeight: FontWeight.w400,
    ),

    ///pieChart and todoList subtitle
    headline6: GoogleFonts.varelaRound(
      //20
      color: Color(0xF0323232),
      fontWeight: FontWeight.w600,
    ),

    ///calendar month
    subtitle1: TextStyle(
      color: Color(0xF03f3f44),
      fontWeight: FontWeight.w400,
      fontSize: 18.0,
    ),

    ///Empty message
    subtitle2: TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.black.withOpacity(0.7),
        fontStyle: FontStyle.italic,
        fontSize: 17),

    ///calendar date
    bodyText1: TextStyle(color: Colors.black54, fontSize: 16), //16

    ///  Used in mantra empty message
    bodyText2: TextStyle(color: Colors.black87, fontSize: 18), //14
  ),
  dialogBackgroundColor: lightThemeNoPhotoColor,
  dialogTheme: DialogTheme(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)))),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  ///https://stackoverflow.com/questions/54656386/change-the-highlight-color-of-selected-text
  textSelectionColor: darkThemeNoPhotoColor,
  // This makes the visual density adapt to the platform that you run
  // the app on. For desktop platforms, the controls will be smaller and
  // closer together (more dense) than on mobile platforms.
  visualDensity: VisualDensity.adaptivePlatformDensity,
  unselectedWidgetColor: Colors.white,
  accentColor: Colors.transparent, //e.g. container box decoration
  canvasColor: Colors.transparent, //e.g. button color
  iconTheme: IconThemeData(color: darkThemeButton),
  appBarTheme: AppBarTheme(color: darkThemeNoPhotoColor),
  textTheme: TextTheme(
    ///todoList title, add todo title
    headline5: TextStyle(
      //24
      color: Colors.white,
      fontWeight: FontWeight.w400,
    ),

    ///pie chart subtitle
    // can not have GoogleFonts.varelaRound this as const
    headline6: GoogleFonts.varelaRound(
      //20
      color: Colors.white,
//      color: Color(0xF0323232),
      fontWeight: FontWeight.w600,
    ),

    ///calendar month
    subtitle1: TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontSize: 18.0,
    ),

    ///Empty message
    subtitle2: TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.white.withOpacity(0.8),
        fontStyle: FontStyle.italic,
        fontSize: 17),

    ///calendar date
    bodyText1: TextStyle(fontSize: 16, color: Colors.white), //16

    /// empty message
    bodyText2: TextStyle(fontSize: 18, color: Colors.white70), //14
  ),
  dialogBackgroundColor: darkThemeNoPhotoColor,
  dialogTheme: DialogTheme(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)))),
);

//NAME         SIZE  WEIGHT  SPACING
//headline1    96.0  light   -1.5
//headline2    60.0  light   -0.5
//headline3    48.0  regular  0.0
//headline4    34.0  regular  0.25
//headline5    24.0  regular  0.0
//headline6    20.0  medium   0.15
//subtitle1    16.0  regular  0.15
//subtitle2    14.0  medium   0.1
//bodyText1    16.0  regular  0.5
//bodyText2    14.0  regular  0.25
//button       14.0  medium   1.25
//caption      12.0  regular  0.4
//overline     10.0  regular  1.5
