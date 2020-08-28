import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

//  //not available
//  'Rooney', //If your brand is lighthearted and you appreciate an unconventional approach,“overall impression of warmth and smoothness.”

List<String> fontList = [
  'Roboto', //modern, yet approachable.” If that sounds like your brand, give it a go.

//  'Lato', //pair with Roboto; The semi-rounded details of the letters give Lato a feeling of warmth, while the strong structure provides stability and seriousness.” Doesn’t that sound perfect for a business site?
//  'Ubuntu', //pair with Roboto, If you’re looking for something distinctly modern, try Ubuntu,
//  'Open Sans', //pair with Roboto, humanist sans serif typeface, open forms and a neutral, yet friendly appearance. It was optimized for print, web, and mobile interfaces, and has excellent legibility characteristics in its letterforms.
//  'Quicksand', //pair with Open Sans, give the impression of friendliness.

  //handwriting:
  'Architects Daughter',
  //handwriting:
  'Crafty Girls',

//  'Dancing Script',
  'The Girl Next Door',

  'Handlee',

  //cursive
  'Cedarville Cursive', //Open Sans, casual cursive handwriting script

  //Best Children Friendly
  'Salsa', // based on behavior and nature of flat round brush stroke
];

class FontPicker extends StatefulWidget {
  final Function(String) onTap;
  final String selectedFont;
  final Color backgroundColor;
  FontPicker({this.onTap, this.selectedFont, this.backgroundColor});
  @override
  _FontPickerState createState() => _FontPickerState();
}

class _FontPickerState extends State<FontPicker> {
  String selectedFont;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    if (selectedFont == null) {
      selectedFont = widget.selectedFont;
    }
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: fontList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedFont = fontList[index];
              });
              widget.onTap(fontList[index]);
            },
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: 80,
                  height: 50,
                  child: Container(
                    child: Center(
                        child: Text('Example',
                            style: GoogleFonts.getFont(fontList[index],
                                color: _darkTheme
                                    ? darkThemeButton
                                    : lightThemeButton,
                                fontSize: 12))),
                    decoration: BoxDecoration(
                        color: widget.backgroundColor,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(width: 1, color: Colors.white70)),
                  ),
                ),
                selectedFont == fontList[index] ? Icon(Icons.done) : Container()
              ],
            ),
          );
        },
      ),
    );
  }
}
