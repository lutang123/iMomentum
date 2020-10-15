import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';

class InputDropdown extends StatelessWidget {
  const InputDropdown({
    Key key,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed,
  }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: labelText, //we don't need labelText
          ),
          baseStyle: valueStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(valueText, style: valueStyle),
              Icon(Icons.arrow_drop_down,
                  color: Theme.of(context).brightness == Brightness.light
                      // ? Colors.grey.shade700
                      // : Colors.white70,
                      ? lightThemeButton
                      : darkThemeButton),
            ],
          ),
        ),
      ),
    );
  }
}
