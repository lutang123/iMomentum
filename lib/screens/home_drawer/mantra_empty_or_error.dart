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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text1,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2, //TextStyle(color: Colors.black87, fontSize: 18)
                  ),
                  Text(
                    text2,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2, //TextStyle(fontWeight: FontWeight.w400,color: Colors.black.withOpacity(0.7),fontStyle: FontStyle.italic,fontSize: 17),
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
