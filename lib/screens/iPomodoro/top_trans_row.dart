import 'package:flutter/material.dart';

class PomodoroTopTransRow extends StatelessWidget {
  const PomodoroTopTransRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Opacity(
            opacity: 0.0,
            child: IconButton(
              onPressed: null,
              icon: Icon(Icons.clear, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
