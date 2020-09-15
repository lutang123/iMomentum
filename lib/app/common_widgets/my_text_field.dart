import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTextField extends StatelessWidget {
  const HomeTextField({
    Key key,
    this.onSubmitted,
    this.icon,
    this.onPressed,
    this.textEditingController,
    this.onChanged,
    this.max = 100,
  }) : super(key: key);

  final Function onSubmitted;
  final IconData icon;
  final Function onPressed;
  final TextEditingController textEditingController;
  final Function onChanged;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onChanged,
              controller: textEditingController,
              style:
                  GoogleFonts.varelaRound(fontSize: 25.0, color: Colors.white),
              textAlign: TextAlign.center,
              onSubmitted: onSubmitted,
              cursorColor: Colors.white,
              maxLength: max,

              ///no save button, can not do multiline
//        keyboardType: TextInputType.multiline,
//        maxLines: null,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//String todoTitle;

//class AddTodoTextField extends StatelessWidget {
//  const AddTodoTextField({
//    Key key,
//    this.controller,
//  }) : super(key: key);
//
//  final TextEditingController controller;
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      width: 280,
//      child: TextField(
//        onChanged: (content) => todoTitle = content,
//        controller: controller,
//        style: TextStyle(
//          color: Colors.white,
//          fontSize: 30.0,
//        ),
//        autofocus: true,
//        textAlign: TextAlign.center,
//        cursorColor: Colors.white,
//        maxLength: 50,
//        decoration: InputDecoration(
//          focusedBorder:
//              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
//          enabledBorder:
//              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
//        ),
//      ),
//    );
//  }
//}

//class SearchTextField extends StatelessWidget {
//  const SearchTextField({
//    Key key,
//    this.onSubmitted,
//  }) : super(key: key);
//
//  final Function onSubmitted;
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: const EdgeInsets.only(left: 15.0),
//      child: Container(
//        width: 280,
//        child: TextField(
//          style: KNoteDescription,
//          textAlign: TextAlign.left,
//          onSubmitted: onSubmitted,
//          cursorColor: Colors.white,
//          maxLength: 50,
//          decoration: InputDecoration(
//            focusedBorder: UnderlineInputBorder(
//                borderSide: BorderSide(color: Colors.white)),
//            enabledBorder: UnderlineInputBorder(
//                borderSide: BorderSide(color: Colors.white)),
//          ),
//        ),
//      ),
//    );
//  }
//}

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
