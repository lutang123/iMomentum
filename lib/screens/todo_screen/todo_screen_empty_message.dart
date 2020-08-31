import 'package:flutter/material.dart';

class TodoScreenEmptyMessage extends StatelessWidget {
  final String text1;
  final String text2;

  const TodoScreenEmptyMessage({Key key, this.text1, this.text2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              text1,
              style: Theme.of(context).textTheme.subtitle2,
              // textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              text2,
              style: Theme.of(context).textTheme.subtitle2,
              // textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
