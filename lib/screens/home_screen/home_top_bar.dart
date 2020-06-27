import 'package:flutter/material.dart';

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
    return Container(
//      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Row(
//          crossAxisAlignment: CrossAxisAlignment.baseline,
//          textBaseline: TextBaseline.alphabetic,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
//                          IconButton(
//                            iconSize: 30,
//                            onPressed: null,
//                            icon: Icon(Icons.favorite_border),
//                          ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(children: [
                  Container(
                    height: 35,
                    width: 35,
                    child: Image(
                      image: NetworkImage(
                          //https://openweathermap.org/img/wn/04n@2x.png
                          "https://openweathermap.org/img/wn/$weatherIcon@2x.png"),
                    ),
                  ),
                  SizedBox(width: 3.0),
                  Text(
                    '$temperature°',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ]),
                Text(
                  '$cityName',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
