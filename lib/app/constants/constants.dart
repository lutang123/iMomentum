import 'package:flutter/material.dart';
import 'package:iMomentum/app/utils/tooltip_shape_border.dart';

class ImageUrl {
  static String randomImageUrl = 'https://source.unsplash.com/random?nature';
  static String fixedImageUrl =
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2706&q=80';
}

// start screen
const KStartTitle = TextStyle(
  fontSize: 30,
  fontFamily: "Billy",
  color: Colors.white,
  fontWeight: FontWeight.w600,
);

const KStartSubtitle = TextStyle(
  fontSize: 22,
  color: Colors.white,
  fontFamily: "Billy",
  fontWeight: FontWeight.w400,
);

const KFlushBarTitle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15.0,
    color: Colors.white,
    fontFamily: "ShadowsIntoLightTwo");

const KFlushBarMessage = TextStyle(
    fontSize: 15.0,
    color: Colors.white,
    fontStyle: FontStyle.italic,
    fontFamily: "ShadowsIntoLightTwo");

const KQuote =
    TextStyle(color: Colors.white, fontSize: 15, fontStyle: FontStyle.italic);
const KQuoteDot = TextStyle(
    color: Colors.lightBlueAccent, fontSize: 18, fontStyle: FontStyle.italic);

const KNoteTitle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

const KNoteDescription = TextStyle(fontSize: 17);

const KEmptyContent = TextStyle(
    fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400);
