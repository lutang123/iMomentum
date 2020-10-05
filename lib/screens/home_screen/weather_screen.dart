import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/utils/format.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/app/services/network_service/weather_service.dart';
import 'package:provider/provider.dart';
import 'package:iMomentum/app/utils/extension_firstCaps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class _WeatherScreenState extends State<WeatherScreen> {
  AppState _state = AppState.NOT_DOWNLOADED;
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

  @override
  void initState() {
    _fetchWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: _resultView(),
    );
  }

  Widget _resultView() => _state == AppState.FINISHED_DOWNLOADING
      ? contentFinishedDownload()
      : _state == AppState.DOWNLOADING
          ? contentDownloading()
          : contentNotDownloaded();

  Widget contentFinishedDownload() {
    final metricNotifier = Provider.of<MetricNotifier>(context, listen: false);
    bool _metricUnitOn = metricNotifier.getMetric();
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Column(
      children: [
        _getSettingButton(context),
        Row(
          children: [
            Text(cityName,
                style: TextStyle(
                    fontSize: 23,
                    color: _darkTheme ? darkThemeWords : lightThemeWords)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(
                height: 60,
                width: 60,
                child: getWeatherIconImage(weatherIcon, size: 40),
              ),
              SizedBox(width: 3.0),
              Text(
                _metricUnitOn ? '$temperature°C' : '$temperature°F',
                style: TextStyle(
                    color: _darkTheme ? darkThemeWords : lightThemeWords,
                    fontSize: 26.0),
              ),
            ]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${description.firstCaps}',
                  style: TextStyle(
                      color: _darkTheme ? darkThemeHint2 : lightThemeHint2,
                      fontStyle: FontStyle.italic,
                      fontSize: 17),
                ),
                SizedBox(height: 5),
                Text(
                    _metricUnitOn
                        ? 'Feels like $feelLike°C'
                        : 'Feels like $feelLike°F',
                    style: TextStyle(
                        color: _darkTheme ? darkThemeHint2 : lightThemeHint2,
                        fontStyle: FontStyle.italic,
                        fontSize: 17))
              ],
            )
          ],
        ),
        Divider(color: _darkTheme ? darkThemeHint2 : lightThemeHint2),
        hourlyListView(),
        Divider(color: _darkTheme ? darkThemeHint2 : lightThemeHint2),
        otherCurrentWeatherInfo(),
        Divider(color: _darkTheme ? darkThemeHint2 : lightThemeHint2),
        forecastListView(),
        Visibility(
          visible: _switchVisible,
          child: Column(
            children: [
              Divider(color: _darkTheme ? darkThemeHint2 : lightThemeHint2),
              ListTile(
                title: Text('Metric Units',
                    style: TextStyle(
                        fontSize: 15,
                        color: _darkTheme ? darkThemeWords : lightThemeWords)),
                trailing: Transform.scale(
                  scale: 0.9,
                  child: CupertinoSwitch(
                    activeColor: _darkTheme
                        ? switchActiveColorDark
                        : switchActiveColorLight,
                    trackColor: Colors.grey,
                    value: _metricUnitOn,
                    onChanged: (val) {
                      ///why here has to add setState, but other switch don't need?
                      setState(() {
                        _metricUnitOn = val;
                      });
                      _onMetricChanged(val, metricNotifier);
                    },
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget hourlyListView() {
    final metricNotifier = Provider.of<MetricNotifier>(context, listen: false);
    bool _metricUnitOn = metricNotifier.getMetric();
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SizedBox(
      height: 65,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourlyWeatherDataList.length,
        itemBuilder: (BuildContext context, int index) {
          HourlyWeatherData hourly = hourlyWeatherDataList[index];
          String hourlyIcon = hourly.hourlyIcon;
          int hourlyTemp = hourly.hourlyTem;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            height: 65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Format.timeHour(
                      DateTime.now().add(Duration(hours: index + 1))),
                  style: TextStyle(
                      color: _darkTheme ? darkThemeHint : lightThemeHint,
                      fontSize: 13),
                ),
                Container(
                    height: 28,
                    width: 28,
                    child: getWeatherIconImage(hourlyIcon)),
                Text(
                  _metricUnitOn ? '$hourlyTemp°C' : '$hourlyTemp°F',
                  style: TextStyle(
                      color: _darkTheme ? darkThemeWords : lightThemeWords,
                      fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget otherCurrentWeatherInfo() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
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
                  style: TextStyle(
                      color: _darkTheme ? darkThemeHint : lightThemeHint),
                  children: <TextSpan>[
                    TextSpan(text: 'Sunrise '),
                    TextSpan(
                      text: '$sunrise',
                      style: TextStyle(
                          color: _darkTheme ? darkThemeWords : lightThemeWords),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      color: _darkTheme ? darkThemeHint : lightThemeHint),
                  children: <TextSpan>[
                    TextSpan(text: 'Sunset  '),
                    TextSpan(
                      text: '$sunset',
                      style: TextStyle(
                          color: _darkTheme ? darkThemeWords : lightThemeWords),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      color: _darkTheme ? darkThemeHint : lightThemeHint),
                  children: <TextSpan>[
                    TextSpan(text: 'UV Index '),
                    TextSpan(
                      text: '$uvi',
                      style: TextStyle(
                          color: _darkTheme ? darkThemeWords : lightThemeWords),
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
                  style: TextStyle(
                      color: _darkTheme ? darkThemeHint : lightThemeHint),
                  children: <TextSpan>[
                    TextSpan(text: 'Wind '),
                    TextSpan(
                      text: '$speed km/h',
                      style: TextStyle(
                          color: _darkTheme ? darkThemeWords : lightThemeWords),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      color: _darkTheme ? darkThemeHint : lightThemeHint),
                  children: <TextSpan>[
                    TextSpan(text: 'Humidity '),
                    TextSpan(
                      text: '$humidity %',
                      style: TextStyle(
                          color: _darkTheme ? darkThemeWords : lightThemeWords),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      color: _darkTheme ? darkThemeHint : lightThemeHint),
                  children: <TextSpan>[
                    TextSpan(text: 'Visibility '),
                    TextSpan(
                      text: '$visibility km',
                      style: TextStyle(
                          color: _darkTheme ? darkThemeWords : lightThemeWords),
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
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
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
          return Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Format.dayOfWeek(
                        DateTime.now().add(Duration(days: index + 1))),
                    style: TextStyle(
                        color: _darkTheme ? darkThemeHint : lightThemeHint,
                        fontSize: 13),
                  ),
                  Row(
                    children: [
                      Container(
                          height: 28,
                          width: 28,
                          child: getWeatherIconImage(dailyIcon)),
                      SizedBox(width: 2),
                      Text(_metricUnitOn ? '$maxTemp°C' : '$maxTemp°F',
                          style: TextStyle(
                              color:
                                  _darkTheme ? darkThemeWords : lightThemeWords,
                              fontSize: 14)),
                      SizedBox(width: 3),
                      Text(
                        _metricUnitOn ? '$minTemp°C' : '$minTemp°F',
                        style: TextStyle(
                            color: _darkTheme ? darkThemeHint : lightThemeHint,
                            fontSize: 14),
                      ),
                      SizedBox(width: 1),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 3),
              VerticalDivider(
                color: _darkTheme ? darkThemeDivider : lightThemeDivider,
                width: 1,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget contentDownloading() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
        margin: EdgeInsets.all(25),
        child: Column(children: [
          Center(
            child: Text(
              'Fetching Weather...',
              style: TextStyle(
                  fontSize: 20,
                  color: _darkTheme ? darkThemeWords : lightThemeWords),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 50),
              child: Center(child: CircularProgressIndicator(strokeWidth: 10)))
        ]));
  }

  Widget contentNotDownloaded() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Column(
      children: <Widget>[
        _getSettingButton(context),
        Center(
          child: Text(
            'Failed to load weather data',
            style: TextStyle(
                fontSize: 18,
                color: _darkTheme ? darkThemeHint2 : lightThemeHint2, //70
                fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }

  void _fetchWeather() async {
    final metricNotifier = Provider.of<MetricNotifier>(context, listen: false);
    bool _metricUnitOn = metricNotifier.getMetric();
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    // if (mounted) {
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
      //1598361536
      sunrise = Format.timeAMPM(
          DateTime.fromMillisecondsSinceEpoch(current['sunrise'] * 1000));
      sunset = Format.timeAMPM(DateTime.fromMillisecondsSinceEpoch(
          current['sunset'] * 1000)); //current.sunrise
      uvi = current['uvi'].toDouble(); //current.uvi
      speed = current['wind_speed'].toDouble(); //current.wind_speed
      //extract the last three zero
      var x = current['visibility'].toString();
      visibility = x.substring(0, x.length - 3); //current.visibility
      humidity = current['humidity'].toInt(); //current.humidity
    });

    setState(() {
      _state = AppState.FINISHED_DOWNLOADING;
    });
  }

  Widget getWeatherIconImage(String weatherIcon, {double size = 20}) {
    if (weatherIcon == '01n') {
      return Icon(EvaIcons.moonOutline, color: Colors.white, size: size);
    } else {
      return Image(
        image: NetworkImage(
            //https://openweathermap.org/img/wn/04n@2x.png
            "https://openweathermap.org/img/wn/$weatherIcon@2x.png"),
      );
    }
  }

  bool _switchVisible = false;
  Widget _getSettingButton(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: _toggleSwitchVisible,
          child: _switchVisible == true
              ? Icon(EvaIcons.closeCircleOutline,
                  size: 25,
                  color: _darkTheme ? darkThemeButton : lightThemeButton)
              : Icon(EvaIcons.moreHorizotnalOutline,
                  color: _darkTheme ? darkThemeButton : lightThemeButton),
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
}
