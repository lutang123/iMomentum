import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    Key key,
    @required this.weatherIcon,
    @required this.temperature,
    @required this.cityName,
  }) : super(key: key);

  final String weatherIcon;
  final int temperature;
  final String cityName;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//    final weatherNotifier = Provider.of<MantraNotifier>(context);
//    bool _weather = weatherNotifier.getMantra();
    return Container(
      color: _darkTheme ? Colors.transparent : lightSurface,
      child: Padding(
        padding: const EdgeInsets.only(right: 15, left: 5),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            SizedBox(
                height: 50,
                child:
//              _weather
//                  ?
                    Row(
//                crossAxisAlignment: CrossAxisAlignment.baseline,
//                textBaseline: TextBaseline.alphabetic,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(children: [
                          Container(
                            decoration: BoxDecoration(
                                color: _darkTheme
                                    ? Colors.transparent
                                    : darkButton,
                                shape: BoxShape.circle),
                            height: 30,
                            width: 30,
                            child: Image(
                              image: NetworkImage(
                                  //https://openweathermap.org/img/wn/04n@2x.png
                                  "https://openweathermap.org/img/wn/$weatherIcon@2x.png"),
                            ),
                          ),
                          SizedBox(width: 3.0),
                          Text(
                            '$temperature°',
                            style: TextStyle(
                                color: _darkTheme ? darkButton : lightButton,
                                fontSize: 15.0),
                          ),
                        ]),
                        Text(
                          '$cityName',
                          style: TextStyle(
                              color: _darkTheme ? darkButton : lightButton,
                              fontSize: 15.0),
                        ),
                      ],
                    )
                  ],
                )
//                  : Container(),
                ),
          ],
        ),
      ),
    );
  }
}
