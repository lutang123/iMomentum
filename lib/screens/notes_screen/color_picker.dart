import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme_color.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

// List<Color> colorsDark2 = [
//   darkThemeNoPhotoBkgdColor,
//   TinyColor(Color(0xFFFd54062)).darken(20).color,
//   TinyColor(Color(0xFFFABD03)).darken(20).color,
//   TinyColor(Color(0xFFFFF476)).darken(30).color,
//   TinyColor(Color(0xFFCDFF90)).darken(40).color,
//   TinyColor(Color(0xFFA7FEEB)).darken(20).color,
//   TinyColor(Color(0xFFCBF0F8)).darken(20).color,
//   TinyColor(Color(0xFFAFCBFA)).darken(20).color,
//   TinyColor(Color(0xFFD7AEFC)).darken(20).color,
//   TinyColor(Color(0xFFFDCFE9)).darken(20).color,
//   TinyColor(Color(0xFFE6C9A9)).darken(20).color,
//   TinyColor(Color(0xFFE9EAEE)).darken(20).color,
// ];

// List<Color> colorsDark3 = [
//   darkThemeNoPhotoBkgdColor,
//   Colors.red, //Color(0xFFF28C82),
//   Colors.pink,
//   Colors.purple,
//   Colors.deepPurple,
//   Colors.indigo,
//   Colors.blue,
//   Colors.lightBlue,
//   Colors.cyan,
//   Colors.teal,
//   Colors.green,
//   Colors.lightGreen,
//   Colors.lime,
//   Colors.yellow,
//   Colors.amber,
//   Colors.orange,
//   Colors.deepOrange,
//   Colors.brown,
//   Colors.grey,
//   Colors.blueGrey,
// ];
List<Color> colorsDark = [
  darkThemeNoPhotoColor,
  Color(0xFFbb596b),
  Color(0xFF87556f),
  Color(0xffe79c2a),
  Color(0xffcdb30c),
  Color(0xFF799351),
  Color(0xff24a19c),
  Color(0xff158467),
  Color(0xFF086972),
  Color(0xFF0f4c75),
  // Colors.purple,
  Color(0xFF6f4a8e),
  Color(0xff6a2c70),
  Colors.brown,
  Color(0xFF557571),
  // Color(0xffb55400),
];

final colorsLight = [
  lightThemeNoPhotoColor, // greenwhite
  Color(0xfff28b81),
  Color(0xffffb6b9),
  Color(0xfff76a8c),
  Color(0xfff8dc88),
  Color(0xfff8fab8),
  Color(0xffccf0e1),
  // light pink //ffb6b9, ffacb7
  Color(0xfff7bd02), // yellow //fafba4, feb377, ffe0ac
  Color(0xfffbf476), // light yellow, f8fab8
  Color(0xffcdff90), // light green, cee397
  Color(0xffa7feeb), // turquoise
  Color(0xffcbf0f8), // light cyan
  Color(0xffafcbfa), // light blue
  Color(0xffd7aefc), // plum,
  Color(0xffffc1f3),
  Color(0xfffbcfe9), // misty rose
  Color(0xffe6c9a9), // light brown
  Color(0xffe9eaee) // light gray
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
