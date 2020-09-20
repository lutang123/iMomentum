import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';

// https://source.unsplash.com/daily?nature
//'https://source.unsplash.com/random?nature'
//https://source.unsplash.com/random?nature/$counter

class ImageUrl {
  ///todo: how to filter good photo, order_by=popular seems no use
  static String randomImageUrl =
      'https://source.unsplash.com/random?nature&wallpaper&travel&landscape/';
  static String randomImageUrlFirstPart =
      'https://source.unsplash.com/random?nature&wallpaper&travel&landscape/';

  // static String fixedImageUrl =
  //     'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2706&q=80';
  static String fixedImageUrl = 'assets/images/boat.jpg';
  static String startImage = 'assets/images/boat.jpg';
  static String startImage1 = 'assets/images/boat.jpg';
  static String startImage2 = 'assets/images/forest.jpg';
  static String startImage3 = 'assets/images/waterfall.jpg';
  static String startImage4 = 'assets/images/landscape2.jpg';
  static String signInImage = 'assets/images/mountain_new.jpg';
}

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

// Home and Pomodoro Screen
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

///in landing swipe
const KLandingSubtitleD = TextStyle(
  fontSize: 25,
  color: darkThemeWords,
  fontWeight: FontWeight.w600,
);

const KLandingSubtitleL = TextStyle(
  fontSize: 25,
  color: lightThemeWords,
  fontWeight: FontWeight.w600,
);

const KLandingSubtitle2D =
    TextStyle(fontSize: 20, color: darkThemeWords, fontStyle: FontStyle.italic
        // fontWeight: FontWeight.w600,
        );

const KLandingSubtitle2L =
    TextStyle(fontSize: 20, color: lightThemeWords, fontStyle: FontStyle.italic
        // fontWeight: FontWeight.w600,
        );

// const KTeddyD = TextStyle(
//   fontSize: 18,
//   color: darkThemeWords,
//   fontWeight: FontWeight.w400,
//   fontFamily: 'Architects Daughter',
// );
//
// const KTeddyL = TextStyle(
//   fontSize: 18,
//   color: lightThemeWords,
//   fontWeight: FontWeight.w400,
//   fontFamily: 'Architects Daughter',
// );

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

const KSignInButtonOrD = TextStyle(
    fontSize: 18,
    color: darkThemeHint2,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic);

const KSignInButtonOrL = TextStyle(
    fontSize: 18,
    color: lightThemeHint2,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic);

const KPrivacyD = TextStyle(
    color: Color(0xf0fafafa), fontSize: 15, fontStyle: FontStyle.italic);

const KPrivacyL = TextStyle(
    color: Color(0xf01a1a2e), fontSize: 15, fontStyle: FontStyle.italic);

const KPrivacyTapD = TextStyle(
  color: Color(0xf0fafafa),
  fontSize: 15,
  fontStyle: FontStyle.italic,
  decoration: TextDecoration.underline,
);

const KPrivacyTapL = TextStyle(
  color: Color(0xf01a1a2e),
  fontSize: 15,
  fontStyle: FontStyle.italic,
  decoration: TextDecoration.underline,
);
