import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/my_round_button.dart';
import 'package:iMomentum/app/common_widgets/setting_switch.dart';
import 'package:iMomentum/app/utils/format.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/network_service/weather_service.dart';
import 'package:provider/provider.dart';
import 'package:iMomentum/app/utils/cap_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class _WeatherScreenState extends State<WeatherScreen> {
  AppState _state = AppState.NOT_DOWNLOADED;

  @override
  void initState() {
    _fetchWeather();
    super.initState();
  }

  String cityName;
  int temperature;
  int feelLike;
  String description;
  String weatherIcon;

  String
      sunrise; //current.sunrise //DateTime.fromMillisecondsSinceEpoch(firebaseMap['date'])
  String sunset; //current.sunrise
  double uvi; //current.uvi

  double speed; //current.wind_speed
  String visibility; //current.visibility
  int humidity; //current.humidity

  List<HourlyWeatherData> hourlyWeatherDataList = [];
  List<DailyWeatherData> dailyWeatherDataList = [];

  void _fetchWeather() async {
    final metricNotifier = Provider.of<MetricNotifier>(context, listen: false);
    bool _metricUnitOn = metricNotifier.getMetric();

    if (mounted) {
      setState(() {
        _state = AppState.DOWNLOADING;
      });
      var weatherData = await WeatherService.getCurrentWeather(
          _metricUnitOn ? 'metric' : 'imperial');
      var weatherOneCall = await WeatherService.getForecastWeather(
          _metricUnitOn ? 'metric' : 'imperial');

      hourlyWeatherDataList = List<HourlyWeatherData>.generate(
          weatherOneCall['hourly'].take(12).toList().length, (index) {
        return HourlyWeatherData(
          hourlyTem: weatherOneCall['hourly'][index]['temp'].toInt(),
          hourlyIcon: weatherOneCall['hourly'][index]['weather'][0]['icon'],
        );
      });

      dailyWeatherDataList = List<DailyWeatherData>.generate(
          weatherOneCall['daily'].take(6).toList().length, (index) {
        return DailyWeatherData(
          dailyIcon: weatherOneCall['daily'][index]['weather'][0]['icon'],
          maxTem: weatherOneCall['daily'][index]['temp']['max'].toInt(),
          minTem: weatherOneCall['daily'][index]['temp']['min'].toInt(),
        );
      });

      setState(() {
        if (weatherData == null || weatherOneCall == null) {
          return;
        }
        cityName = weatherData['name'];
        //for current details
        var current = weatherOneCall['current'];
        temperature = current['temp'].toInt();
        feelLike = current['feels_like'].toInt();
        weatherIcon = current['weather'][0]['icon'];
        description = current['weather'][0]['description'];

        ///https://stackoverflow.com/questions/50632217/dart-flutter-converting-timestamp
        sunrise =
            //1598361536
            Format.timeAMPM(
                DateTime.fromMillisecondsSinceEpoch(current['sunrise'] * 1000));
        sunset = Format.timeAMPM(DateTime.fromMillisecondsSinceEpoch(
            current['sunset'] * 1000)); //current.sunrise
        uvi = current['uvi']; //current.uvi

        speed = current['wind_speed']; //current.wind_speed
        //extract the last three zero
        var x = current['visibility'].toString();
        visibility = x.substring(0, x.length - 3); //current.visibility
        humidity = current['humidity']; //current.humidity
      });

      setState(() {
        _state = AppState.FINISHED_DOWNLOADING;
      });
    }
  }

  Widget getWeatherIconImage(String weatherIcon, {double size = 20}) {
    if (weatherIcon == '01d') {
      return Icon(EvaIcons.sunOutline, color: Colors.white, size: size);
    } else if (weatherIcon == '01n') {
      return Icon(EvaIcons.moonOutline, color: Colors.white, size: size);
    }

    ///todo
//    else if (weatherIcon == '02d') {
//      return BoxedIcon(WeatherIcons.day_sunny);
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

  bool _switchVisible = false;
  Widget _getSettingButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: _toggleSwitchVisible,
          child: _switchVisible == true
              ? Icon(EvaIcons.closeCircleOutline, size: 25)
              : Icon(EvaIcons.moreHorizotnalOutline),
        ),
      ],
    );
  }

  void _toggleSwitchVisible() {
    setState(() {
      _switchVisible = !_switchVisible;
    });
  }

  Future<void> _onMetricChanged(
      bool value, MetricNotifier metricNotifier) async {
    metricNotifier.setMetric(value);

    ///call this again to update screen
    _fetchWeather();
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('metricUnitOn', value);
  }

  Widget contentFinishedDownload() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final metricNotifier = Provider.of<MetricNotifier>(context, listen: false);
    bool _metricUnitOn = metricNotifier.getMetric();
    return Column(
      children: [
        _getSettingButton(context),
        Row(
          children: [
            Text(cityName,
                style: TextStyle(
                    fontSize: 23,
                    color: _darkTheme ? Colors.white : Colors.black87)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
//                crossAxisAlignment: CrossAxisAlignment.end,
//                textBaseline: TextBaseline.ideographic,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    child: getWeatherIconImage(weatherIcon, size: 40),
                  ),
                  SizedBox(width: 3.0),
                  Text(
                    _metricUnitOn ? '$temperature°C' : '$temperature°F',
                    style: TextStyle(
                        color: _darkTheme ? darkThemeButton : lightThemeButton,
                        fontSize: 26.0),
                  ),
                ]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${description.firstCaps}',
                    style: Theme.of(context).textTheme.subtitle2),
                SizedBox(height: 5),
                Text(
                    _metricUnitOn
                        ? 'Feels like $feelLike°C'
                        : 'Feels like $feelLike°F',
                    style: Theme.of(context).textTheme.subtitle2)
              ],
            )
          ],
        ),
        Divider(color: Colors.white70),
        hourlyListView(),
        Divider(color: Colors.white70),
        otherCurrentWeatherInfo(),
        Divider(color: Colors.white70),
        forecastListView(),
        Visibility(
          visible: _switchVisible,
          child: Column(
            children: [
              Divider(color: Colors.white70),
              SettingSwitchNoIcon(
                title: 'Metric Units',
                value: _metricUnitOn,
                onChanged: (val) {
                  ///why here has to add setState, but other switch don't need?
                  setState(() {
                    _metricUnitOn = val;
                  });
                  _onMetricChanged(val, metricNotifier);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Tips: Double tap on the top-right side of Home screen to update weather information anytime.",
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget hourlyListView() {
    final metricNotifier = Provider.of<MetricNotifier>(context, listen: false);
    bool _metricUnitOn = metricNotifier.getMetric();
    return SizedBox(
      height: 63,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourlyWeatherDataList.length,
        itemBuilder: (BuildContext context, int index) {
          HourlyWeatherData hourly = hourlyWeatherDataList[index];
          String hourlyIcon = hourly.hourlyIcon;
          int hourlyTemp = hourly.hourlyTem;
          return Container(
//            color: Colors.orange,
            padding: EdgeInsets.symmetric(horizontal: 4.0),
//            width: 50,
            height: 63,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Format.timeHour(
                      DateTime.now().add(Duration(hours: index + 1))),
                  style: TextStyle(color: Colors.white60, fontSize: 13),
                ),
                Container(
//                    color: Colors.blu e,
                    height: 28,
                    width: 28,
                    child: getWeatherIconImage(hourlyIcon)),
                Text(
                  _metricUnitOn ? '$hourlyTemp°C' : '$hourlyTemp°F',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget otherCurrentWeatherInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.white60),
                  children: <TextSpan>[
                    TextSpan(text: 'Sunrise '),
                    TextSpan(
                      text: '$sunrise',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.white60),
                  children: <TextSpan>[
                    TextSpan(text: 'Sunset  '),
                    TextSpan(
                      text: '$sunset',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.white60),
                  children: <TextSpan>[
                    TextSpan(text: 'UV Index '),
                    TextSpan(
                      text: '$uvi',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.white60),
                  children: <TextSpan>[
                    TextSpan(text: 'Wind '),
                    TextSpan(
                      text: '$speed km/h',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.white60),
                  children: <TextSpan>[
                    TextSpan(text: 'Humidity '),
                    TextSpan(
                      text: '$humidity %',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.white60),
                  children: <TextSpan>[
                    TextSpan(text: 'Visibility '),
                    TextSpan(
                      text: '$visibility km',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget forecastListView() {
    final metricNotifier = Provider.of<MetricNotifier>(context, listen: false);
    bool _metricUnitOn = metricNotifier.getMetric();
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dailyWeatherDataList.length,
        itemBuilder: (BuildContext context, int index) {
          DailyWeatherData daily = dailyWeatherDataList[index];
          String dailyIcon = daily.dailyIcon;
          int maxTemp = daily.maxTem;
          int minTemp = daily.minTem;
          return Container(
//            color: Colors.purple,
            padding: EdgeInsets.symmetric(horizontal: 4.0),
//            width: 100,
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Format.dayOfWeek(
                      DateTime.now().add(Duration(days: index + 1))),
                  style: TextStyle(color: Colors.white70),
                ),
                Container(
//                  color: Colors.yellow,
                  child: Row(
                    children: [
                      Container(
                          height: 30,
                          width: 30,
//                          color: Colors.blue,
                          child: getWeatherIconImage(dailyIcon)),
                      SizedBox(width: 3),
                      Text(
                        _metricUnitOn ? '$maxTemp°C' : '$maxTemp°F',
                      ),
                      SizedBox(width: 3),
                      Text(
                        _metricUnitOn ? '$minTemp°C' : '$minTemp°F',
                        style: TextStyle(color: Colors.white60),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget contentDownloading() {
    return Container(
        margin: EdgeInsets.all(25),
        child: Column(children: [
          Center(
            child: Text(
              'Fetching Weather...',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 50),
              child: Center(child: CircularProgressIndicator(strokeWidth: 10)))
        ]));
  }

  Widget contentNotDownloaded() {
    return Column(
      children: <Widget>[
        _getSettingButton(context),
        Center(
          child: Text(
            'Failed to load weather data',
          ),
        ),
      ],
    );
  }

  Widget _resultView() => _state == AppState.FINISHED_DOWNLOADING
      ? contentFinishedDownload()
      : _state == AppState.DOWNLOADING
          ? contentDownloading()
          : contentNotDownloaded();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: _resultView(),
    );
  }
}
