import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTextField extends StatelessWidget {
  const HomeTextField({
    Key key,
    this.onSubmitted,
  }) : super(key: key);

  final Function onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      child: TextField(
        style: GoogleFonts.varelaRound(
          fontWeight: FontWeight.w600,
          fontSize: 30.0,
        ),
        autofocus: true,
        textAlign: TextAlign.center,
        onSubmitted: onSubmitted,
        cursorColor: Colors.white,
        maxLength: 50,
        decoration: InputDecoration(
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
      ),
    );
  }
}

class AddTodoTextField extends StatelessWidget {
  const AddTodoTextField({
    Key key,
    this.controller,
  }) : super(key: key);

  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      child: TextField(
        onChanged: (content) => todoTitle = content,
        controller: controller,
        style: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
        ),
        autofocus: true,
        textAlign: TextAlign.center,
        cursorColor: Colors.white,
        maxLength: 50,
        decoration: InputDecoration(
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
      ),
    );
  }
}

String todoTitle;

//Widget _buildComment() {
//  return TextField(
//    keyboardType: TextInputType.text,
//    maxLength: 50,
//    controller: TextEditingController(text: todoTitle),
//    decoration: InputDecoration(
//      labelText: 'TODO',
//      labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
//    ),
//    style: TextStyle(fontSize: 20.0),
//    maxLines: null,
//    onChanged: (content) => todoTitle = content,
//  );
//}
