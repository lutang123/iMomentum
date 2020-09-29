import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

class HomeTextField extends StatelessWidget {
  const HomeTextField({
    Key key,
    this.onSubmitted,
    // this.icon,
    // this.textEditingController,
    this.onChanged,
    this.max = 100,
    this.width = 320,
    this.autofocus = false,
  }) : super(key: key);

  final Function onSubmitted;
  // final IconData icon;
  // final TextEditingController textEditingController;
  final Function onChanged;
  final int max;
  final double width;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SizedBox(
      width: width,
      child: TextFormField(
        onChanged: onChanged,
        autofocus: autofocus,
        // controller: textEditingController,
        style: GoogleFonts.varelaRound(fontSize: 25.0, color: Colors.white),
        textAlign: TextAlign.center,
        onFieldSubmitted: onSubmitted,
        validator: (value) =>
            value.isNotEmpty ? null : 'Content can\'t be empty',
        cursorColor: Colors.white,
        maxLength: max, //default 100
        inputFormatters: [LengthLimitingTextInputFormatter(max)],
        keyboardAppearance: _darkTheme ? Brightness.dark : Brightness.light,

        ///no save button, can not do multiline
//        keyboardType: TextInputType.multiline,
//        maxLines: null, default is 1
        decoration: KTextFieldInputDecoration,
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
