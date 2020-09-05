import 'package:flutter/material.dart';

class EmptyOrErrorMantra extends StatelessWidget {
  const EmptyOrErrorMantra(
      {Key key,
      @required bool hideEmptyMessage,

      ///this is added by extracting Widget, no need
      // @required this.context,
      this.text1,
      this.text2})
      : _hideEmptyMessage = hideEmptyMessage,
        super(key: key);

  final bool _hideEmptyMessage;
  // final BuildContext context;
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Spacer(),
          //Text('Power up your day with your favorite quotes.',)
          Visibility(
            visible: _hideEmptyMessage,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text(
                    text1,
                    style: Theme.of(context).textTheme.subtitle2,
                    // textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    text2,
                    style: Theme.of(context).textTheme.subtitle2,
                    // textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}
