import 'package:flutter/material.dart';

// https://source.unsplash.com/daily?nature
//'https://source.unsplash.com/random?nature'
//https://source.unsplash.com/random?nature/$counter

class ImageUrl {
  ///todo: how to filter good photo, order_by=popular seems no use
  static String randomImageUrl =
      'https://source.unsplash.com/random?nature&wallpaper&travel&landscape/';
  static String randomImageUrlFirstPart =
      'https://source.unsplash.com/random?nature&wallpaper&travel&landscape/';

  static String fixedImageUrl =
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2706&q=80';
}

const String textTodoList1 = "Do you have any tasks to complete today? "
    "\n"
    "\n"
    "We have 5 categories "
    "(Focus, Work, Home, Shopping and Others) "
    "to help you organize your daily tasks. Tasks in Focus category will show "
    "on Home screen to enable Focus Mode to for these tasks. "
    "\n"
    "\n"
    "Tap the plus button to enter your first task today!";

const String textTodoList2 = 'Tips: '
    'You can also tap on any date on calendar and long press on the date to add a task on a specific day.'
    ' After entering a task, you can add a reminder by swiping right on the task item.';

const String textPieChart1 = 'You have not done any focused task on this day.'
    '\n'
    '\n'
    'Enter a task from Home screen (or from Todo screen and choose task category as Focus), then you will see Focus Mode button on Home screen.'
    '\n'
    '\n'
    'When you complete a focus session, you will see a pie chart showing your daily focus summary on this screen.';

const String textPieTip =
    'Our Focus Mode uses Pomodoro Technique to help you focus. ';

const String textPieTap = 'Learn more.';

///Todo: add contact us
const String textError =
    'Oops, something went wrong, please check your internet connection and come back later.';
const String textError2 = '';

const textMantra1 =
    'Center yourself with friendly reminders, reinforce new thought patterns, and bring attention to the values or principles that are most important to you. \n'
    '\n'
    'By default, every time when you enter or complete a task, a new Mantra from our curated feed will appear on Home screen.';
const textMantra2 =
    'You can add your own mantras to personalize your experience.';
// 'Get inspired by adding your personal mantras. '

const textQuote1 =
    'By default, a daily quote will show on the bottom of Home screen.';
const textQuote2 =
    'You can add your own quotes to personalize your experience.';

const emptyNoteAndFolder =
    'Any thoughts or new ideas you want to write? Click the plus button to add a new note.'
    '\n'
    '\n'
    'By default, all notes are added to Notes folder. You can also create new folders and add notes in a specific folder to help you organize your notes. You can change the folder anytime. ';
const emptyNote =
    'No notes in this folder yet. Click the plus button to add a new note.';

/// Home and Pomodoro Screen
const KHomeToday =
    TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold);
// HomeTodoListTile used GoogleFonts.varelaRound, 25, bold

const KHomeDate = TextStyle(
  color: Colors.white,
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

const KHomeQuestion =
    TextStyle(color: Colors.white, fontSize: 33.0, fontWeight: FontWeight.bold);

const KHomeGreeting =
    TextStyle(fontSize: 35.0, color: Colors.white, fontWeight: FontWeight.bold);

const KTextFieldInputDecoration = InputDecoration(
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
    color: Colors.white,
  )),
);

const KToolTip = TextStyle(color: Colors.white);

/// for all dialog:
const KDialogTitle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20);

const KDialogContent = TextStyle(color: Colors.white, fontSize: 18);

const KDialogButton =
    TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20);
//    //Const variables must be initialized with a constant value
// GoogleFonts.varelaRound(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20);

const KFlushBarTitle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15.0,
    color: Colors.white,
    fontFamily: "ShadowsIntoLightTwo");

const KFlushBarEmphasis = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
    fontStyle: FontStyle.italic,
    color: Colors.white,
    fontFamily: "ShadowsIntoLightTwo");

const KFlushBarMessage = TextStyle(
    fontSize: 15.0,
    color: Colors.white,
    fontStyle: FontStyle.italic,
    fontFamily: "ShadowsIntoLightTwo");

const KFlushBarGradient =
    LinearGradient(colors: [Color(0xF00f4c75), Color(0xF03282b8)]);

// const KTextButton ('Learn more') = used google font varelaRound
const KTextButton = TextStyle(
    fontSize: 16.0,
    color: Colors.white,
    fontStyle: FontStyle.italic,
    decoration: TextDecoration.underline,
    fontFamily: "varelaRound");

const KQuote = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 15,
    fontStyle: FontStyle.italic);

const KQuoteDot = TextStyle(
    color: Colors.lightBlueAccent, fontSize: 18, fontStyle: FontStyle.italic);

const KEmptyContent = TextStyle(
    fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400);

// for landing screen
const KLandingTitle = TextStyle(
  fontSize: 30,
  fontFamily: "Billy",
  color: Colors.white,
  fontWeight: FontWeight.w600,
);
const KLandingSubtitle = TextStyle(
  fontSize: 22,
  color: Colors.white,
  fontFamily: "Billy",
  fontWeight: FontWeight.w400,
);
