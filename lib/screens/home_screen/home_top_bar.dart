import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/services/network_service/weather_service.dart';
import 'package:provider/provider.dart';

class HomeTopBar extends StatefulWidget {
  const HomeTopBar(
      {Key key,
      this.onTap,
      this.weatherVisible,
      this.topBarColor,
      this.onDoubleTap})
      : super(key: key);

  final Function onTap;
  final bool weatherVisible;
  final Color topBarColor;
  final Function onDoubleTap;

  @override
  _HomeTopBarState createState() => _HomeTopBarState();
}

enum CurrentWeatherState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class _HomeTopBarState extends State<HomeTopBar> {
  int temperature;
  String cityName;
  String weatherIcon;
  CurrentWeatherState _state = CurrentWeatherState.NOT_DOWNLOADED;

  @override
  void initState() {
    _fetchWeather();
    super.initState();
  }

//  bool _weatherVisible = true;

  void _fetchWeather() async {
    final metricNotifier = Provider.of<MetricNotifier>(context, listen: false);
    bool _metricUnitOn = metricNotifier.getMetric();
    if (mounted) {
      setState(() {
        _state = CurrentWeatherState.DOWNLOADING;
      });

      var weatherData = await WeatherService.getCurrentWeather(
          _metricUnitOn ? 'metric' : 'imperial');
      setState(() {
        if (weatherData == null) {
//        _weatherVisible = false;
          return;
        }

        temperature = weatherData['main']['temp'].toInt();
        cityName = weatherData['name'];
        weatherIcon = weatherData['weather'][0]['icon'];
        _getWeatherIconImage(weatherIcon);
      });

      setState(() {
        _state = CurrentWeatherState.FINISHED_DOWNLOADING;
      });
    }
  }

  Widget _getWeatherIconImage(String weatherIcon, {double size = 20}) {
    if (weatherIcon == '01d') {
      return Icon(EvaIcons.sunOutline, color: Colors.white, size: size);
    } else if (weatherIcon == '01n') {
      return Icon(EvaIcons.moonOutline, color: Colors.white, size: size);
    }

    ///FontAwesomeIcons is often thicker and bigger
//    else if (weatherIcon == '02d') {
//      return Icon(FontAwesomeIcons.cloudSun, color: Colors.white);
//    } else if (weatherIcon == '02n') {
//      return Icon(FontAwesomeIcons.cloudMoon, color: Colors.white);
//    } else if (weatherIcon == '13d' || weatherIcon == '13n') {
//      return Icon(FontAwesomeIcons.snowflake, color: Colors.white);
//    }

    else {
      return Image(
        image: NetworkImage(
            //https://openweathermap.org/img/wn/04n@2x.png
            "https://openweathermap.org/img/wn/$weatherIcon@2x.png"),
      );
    }
  }

  Widget contentFinishedDownload() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final metricNotifier = Provider.of<MetricNotifier>(context, listen: false);
    bool _metricUnitOn = metricNotifier.getMetric();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(children: [
            Container(
              decoration: BoxDecoration(
                  color: _darkTheme ? Colors.transparent : darkThemeButton,
                  shape: BoxShape.circle),
              height: 30,
              width: 30,
              child: _getWeatherIconImage(weatherIcon),
            ),
            SizedBox(width: 3.0),
            Text(
              _metricUnitOn ? '$temperature°C' : '$temperature°F',
              style: TextStyle(
                  color: _darkTheme ? darkThemeButton : lightThemeButton,
                  fontSize: 15.0),
            ),
          ]),
          Text(
            '$cityName',
            style: TextStyle(
                color: _darkTheme ? darkThemeButton : lightThemeButton,
                fontSize: 15.0),
          ),
        ],
      ),
    );
  }

  Widget contentDownloading() {
    return Center(child: CircularProgressIndicator(strokeWidth: 10));
  }

  Widget contentNotDownloaded() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '',
          ),
        ],
      ),
    );
  }

  Widget _resultView() => _state == CurrentWeatherState.FINISHED_DOWNLOADING
      ? contentFinishedDownload()
      : _state == CurrentWeatherState.DOWNLOADING
          ? contentDownloading()
          : contentNotDownloaded();

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//    final weatherNotifier = Provider.of<MantraNotifier>(context);
//    bool _weather = weatherNotifier.getMantra();
    return Container(
      color: _darkTheme ? widget.topBarColor : lightThemeSurface,
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
                  Visibility(
                    visible: widget.weatherVisible,
                    child: InkWell(
                      onTap: widget.onTap,
                      onDoubleTap: _fetchWeather,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15, left: 5),
                        child: _resultView(),
                      ),
                    ),
                  ),

                  ///nice try but we can't press it, it's below the topSheet
//                  Visibility(
//                    visible: widget.closeButtonVisible,
//                    child: IconButton(
//                      icon: Icon(EvaIcons.closeCircleOutline,
//                          size: 30, color: Colors.white),
//                      onPressed: () => Navigator.pop(context),
//                    ),
//                  )
                ],
              )
//                  : Container(),
              ),
        ],
      ),
    );
  }
}
