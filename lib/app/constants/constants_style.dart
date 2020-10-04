import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/constants/theme.dart';

/// Gradient
const KBackgroundGradient = LinearGradient(
  colors: [
    Colors.transparent, //we can not add with opacity
    Colors.black12,
  ],
  stops: [0.5, 1.0],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  tileMode: TileMode.repeated,
);

/// InputDecoration
//in HomeTextField (home and name)
const KHomeTextFieldInputDecoration = InputDecoration(
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
    color: Colors.white,
  )),

  ///validator can't show when over the max length
  // counterText: "",
);

//in AddTodo calendar
const KTransparentInputDecoration = InputDecoration(
  focusedBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
  enabledBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
);

//in pomodoro screen
const KTextFieldInputDecorationLight = InputDecoration(
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: lightThemeDivider),
  ),
  enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
    color: lightThemeDivider,
  )),
  // counterText: "",
);
const KTextFieldInputDecorationDark = InputDecoration(
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: darkThemeDivider),
  ),
  enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
    color: darkThemeDivider,
  )),
  // counterText: "",
);

/// TextStyle
// Home and Pomodoro Screen
const KHomeToday =
    TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold);

const KHomeDate = TextStyle(
  color: Colors.white,
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

const KHomeQuestion =
    TextStyle(color: Colors.white, fontSize: 33.0, fontWeight: FontWeight.bold);

const KHomeQuestion2 =
    TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold);

const KHomeGreeting =
    TextStyle(fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold);

const KTimer = TextStyle(
  fontSize: 55.0,
  color: Colors.white,
  fontWeight: FontWeight.w600,
);

const KTimerBeginSubtitle = TextStyle(
  fontSize: 22.0,
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontFamily: "varelaRound",
);

const KTimerSubtitle = TextStyle(
  fontSize: 35.0,
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontFamily: "varelaRound",
);

const KPomodoroTitle =
    TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold);

const KPomodoroSubtitle = TextStyle(
  fontSize: 20.0,
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontStyle: FontStyle.italic,
  fontFamily: "varelaRound",
);

/// for all dialog:
const KDialogTitle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20);

const KDialogContent = TextStyle(color: Colors.white, fontSize: 18);

const KDialogButton =
    TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20);

const KDialogTitleLight = TextStyle(
    color: lightThemeWords, fontWeight: FontWeight.w600, fontSize: 20);

const KDialogContentLight = TextStyle(color: lightThemeWords, fontSize: 18);

const KDialogButtonLight = TextStyle(
    color: lightThemeWords, fontWeight: FontWeight.w600, fontSize: 20);

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
    fontSize: 16,
    fontStyle: FontStyle.italic);

const KQuoteDot = TextStyle(
    color: Colors.lightBlueAccent, fontSize: 18, fontStyle: FontStyle.italic);

const KEmptyContent = TextStyle(
    fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400);

/// for start screen
const KWelcome = TextStyle(
  fontSize: 30,
  fontFamily: "Billy",
  color: Colors.white,
  fontWeight: FontWeight.w600,
);

///in landing swipe
const KLandingTitleD = TextStyle(
  fontSize: 25,
  color: darkThemeWords,
  fontWeight: FontWeight.w600,
);

const KLandingTitleL = TextStyle(
  fontSize: 25,
  color: lightThemeWords,
  fontWeight: FontWeight.w600,
);

const KLandingTitleHighlight = TextStyle(
  fontSize: 25,
  color: lightThemeButton,
  fontWeight: FontWeight.w600,
);

const KLandingSubtitleD = TextStyle(
  fontSize: 20,
  color: darkThemeWords,
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.w400,
);

const KLandingSubtitleL = TextStyle(
  fontSize: 20,
  color: lightThemeWords,
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.w400,
);

const KFeatureL =
    TextStyle(color: lightThemeWords, fontWeight: FontWeight.w400);

const KSignInButtonTextD = TextStyle(
  fontSize: 18,
  color: darkThemeWords,
  fontWeight: FontWeight.w500,
);

const KSignInButtonTextL = TextStyle(
  fontSize: 18,
  color: lightThemeWords,
  fontWeight: FontWeight.w500,
);

const KSignInSecondButtonD = TextStyle(
    fontSize: 18,
    color: Color(0xf0fafafa),
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    decoration: TextDecoration.underline);

const KSignInSecondButtonL = TextStyle(
    fontSize: 18,
    color: Color(0xf01a1a2e),
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    decoration: TextDecoration.underline);

const KSignInButtonOrL = TextStyle(
    fontSize: 14,
    color: signInOr,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic);

const KTopFlatButtonText =
    TextStyle(color: topFlatButton, fontStyle: FontStyle.italic);

///why sign in
const KWhySignInTitleL = TextStyle(
    fontSize: 22, color: lightThemeWords, fontWeight: FontWeight.w600);

const KSignInReason = TextStyle(color: lightThemeWords, fontSize: 17);

const KSignInReasonDetail = TextStyle(
    color: Color(0xf01a1a2e), fontSize: 15, fontStyle: FontStyle.italic);

const KPrivacyL = TextStyle(fontSize: 14, color: lightThemeHint2);

const KPrivacyTapL = TextStyle(
  color: lightThemeHint2,
  fontSize: 14,
  decoration: TextDecoration.underline,
);
