import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './input_helper.dart';

typedef void CaretMoved(Offset globalCaretPosition);
typedef void TextChanged(String text);

// Helper widget to track caret position.
class TrackingTextInput extends StatefulWidget {
  TrackingTextInput({
    Key key,
    this.onCaretMoved,
    this.onTextChanged,
    this.hint,
    this.enable,
    this.label,
    this.icon,
    this.isObscured = false,
    this.focusNode,
    this.onEditingComplete,
    this.onChanged,
    this.textController,
  }) : super(key: key);
  final CaretMoved onCaretMoved;
  final TextChanged onTextChanged;
  final String hint;
  final bool enable;
  final String label;
  final IconData icon;
  final bool isObscured;
  final FocusNode focusNode;
  final Function onEditingComplete;
  final Function onChanged;
  final TextEditingController textController;

//  final FormFieldValidator<String> validator;

  @override
  _TrackingTextInputState createState() => _TrackingTextInputState();
}

class _TrackingTextInputState extends State<TrackingTextInput> {
  final GlobalKey _fieldKey = GlobalKey();
  // final TextEditingController textController = TextEditingController();
  Timer _debounceTimer;

  @override
  initState() {
    widget.textController.addListener(() {
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
        widget.onTextChanged(widget.textController.text);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // key: _fieldKey,
      controller: widget.textController,
      focusNode: widget.focusNode,
      onEditingComplete: widget.onEditingComplete,
      onChanged: widget.onChanged,
      style: TextStyle(fontSize: 16.0, color: Colors.white),
      enabled: widget.enable,
      keyboardType:
          widget.isObscured ? TextInputType.text : TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        labelStyle: TextStyle(fontSize: 16.0, color: Colors.white70),
        prefixIcon: Icon(widget.icon),
      ),
      obscureText: widget.isObscured,
      // validator: (value) {},
    );
  }
}
