import 'package:flutter/material.dart';

// TODO: Don't hardcode this; load it from a ENV or a build-specific file
// OPSEC: this is a public email
const devEmail = 'jethro.lorenzo.lising@gmail.com';

const productSite = 'justbreathe.lising.ca';

class Constants {
  static String todoImage = 'images/todo_image.jpg';
  static String homePageImage = 'https://source.unsplash.com/random?nature';
}

/// used in calendar
const KBoxDecorationCalendar = BoxDecoration(
    color: Colors.black26,
    borderRadius: BorderRadius.all(Radius.circular(20.0)));

//const KBoxDecorationNotes = BoxDecoration(
//  color: Colors.black26,
//  border: Border.all(width: 2, color: Colors.white),
//  borderRadius: BorderRadius.circular(10.0));

const KBoxDecorationNotes = BoxDecoration(
    color: Colors.black38,
    borderRadius: BorderRadius.all(Radius.circular(10.0)));

const KColorAppBar = Colors.black12;

const KColorIndicator = Colors.white70;

const KNoteTitle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

const KNoteDescription = TextStyle(fontSize: 20);

const KNoteDate = TextStyle(color: Colors.white70);

const KEmptyContent = TextStyle(
    fontSize: 25, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400);

const kTemTextStyle = TextStyle(
//  fontFamily: 'Spartan MB',
  fontSize: 30.0,
  color: Colors.white,
);

//FaIcon(FontAwesomeIcons.)

// Text(
//        text,
//        style: textStyle,
//        softWrap: false,
//        overflow: TextOverflow.clip,
//        maxLines: 1,
//      ),
