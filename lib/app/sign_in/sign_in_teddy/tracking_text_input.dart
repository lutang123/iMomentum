import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'input_helper.dart';
import 'package:iMomentum/app/constants/theme.dart';

typedef void CaretMoved(Offset globalCaretPosition);
typedef void TextChanged(String text);

// Helper widget to track caret position.
class TrackingTextInput extends StatefulWidget {
  TrackingTextInput({
    Key key,
    this.onCaretMoved,
    this.onTextChanged,
    // this.enable,
    this.inputDecoration,
    this.isObscured = false,
    this.onEditingComplete,
    this.textController,
    // this.onChanged,
    // this.textInputAction,
  }) : super(key: key);
  final CaretMoved onCaretMoved;
  final TextChanged onTextChanged;
  // final bool enable;
  final InputDecoration inputDecoration;
  final bool isObscured;
  final Function onEditingComplete;
  final TextEditingController textController;
  // final Function onChanged;
  // final TextInputAction textInputAction;

  @override
  _TrackingTextInputState createState() => _TrackingTextInputState();
}

class _TrackingTextInputState extends State<TrackingTextInput> {
  final GlobalKey _fieldKey = GlobalKey();
  // final TextEditingController c
  TextEditingController get textController => widget.textController;
  Timer _debounceTimer;

  @override
  initState() {
    textController.addListener(() {
      // We debounce the listener as sometimes the caret position is updated after the listener
      // this assures us we get an accurate caret position.
      if (_debounceTimer?.isActive ?? false) _debounceTimer.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 100), () {
        if (_fieldKey.currentContext != null) {
          // Find the render editable in the field.
          final RenderObject fieldBox =
              _fieldKey.currentContext.findRenderObject();
          Offset caretPosition = getCaretPosition(fieldBox);

          if (widget.onCaretMoved != null) {
            widget.onCaretMoved(caretPosition);
          }
        }
      });
      if (widget.onTextChanged != null) {
        widget.onTextChanged(textController.text);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: _fieldKey,
      keyboardAppearance: Brightness.light,
      controller: textController,
      onEditingComplete: widget.onEditingComplete,
      style: TextStyle(fontSize: 16.0, color: lightThemeWords),
      enabled: true,
      keyboardType:
          widget.isObscured ? TextInputType.text : TextInputType.emailAddress,
      textInputAction:
          widget.isObscured ? TextInputAction.done : TextInputAction.next,
      decoration: widget.inputDecoration,
      // decoration: InputDecoration(
      //   labelText: widget.label,
      //   hintText: widget.hint,
      //   labelStyle: TextStyle(fontSize: 16.0, color: Colors.white70),
      //   prefixIcon: Icon(widget.icon),
      // ),
      obscureText: widget.isObscured,
      // validator: (value) {},
    );
  }
}
