import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';
import 'package:tinycolor/tinycolor.dart';

List<Color> colorsDark2 = [
  darkBkgdColor,
  TinyColor(Color(0xFFF28C82)).darken(20).color,
  TinyColor(Color(0xFFFABD03)).darken(20).color,
  TinyColor(Color(0xFFFFF476)).darken(30).color,
  TinyColor(Color(0xFFCDFF90)).darken(40).color,
  TinyColor(Color(0xFFA7FEEB)).darken(20).color,
  TinyColor(Color(0xFFCBF0F8)).darken(20).color,
  TinyColor(Color(0xFFAFCBFA)).darken(20).color,
  TinyColor(Color(0xFFD7AEFC)).darken(20).color,
  TinyColor(Color(0xFFFDCFE9)).darken(20).color,
  TinyColor(Color(0xFFE6C9A9)).darken(20).color,
  TinyColor(Color(0xFFE9EAEE)).darken(20).color,
];

List<Color> colorsDark = [
  darkBkgdColor,
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
];

List<Color> colorsLight = [
  lightSurface,
  Color(0xFFF28C82),
  Color(0xFFFABD03),
  Color(0xFFFFF476),
  Color(0xFFCDFF90),
  Color(0xFFA7FEEB),
  Color(0xFFCBF0F8),
  Color(0xFFAFCBFA),
  Color(0xFFD7AEFC),
  Color(0xFFFDCFE9),
  Color(0xFFE6C9A9),
  Color(0xFFE9EAEE),
];

class ColorPicker extends StatefulWidget {
  final Function(int) onTap;
  final int selectedIndex;
  ColorPicker({this.onTap, this.selectedIndex});
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    if (selectedIndex == null) {
      selectedIndex = widget.selectedIndex;
    }
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _darkTheme ? colorsDark.length : colorsLight.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onTap(index);
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              width: 50,
              height: 50,
              child: Container(
                child: Center(
                    child: selectedIndex == index
                        ? Icon(Icons.done)
                        : Container()),
                decoration: BoxDecoration(
                    color: _darkTheme ? colorsDark[index] : colorsLight[index],
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 1,
                        color: _darkTheme ? Colors.white70 : Colors.black87)),
              ),
            ),
          );
        },
      ),
    );
  }
}
