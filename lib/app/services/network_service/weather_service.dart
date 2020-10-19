import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:iMomentum/app/constants/api_key.dart';

const apiKey = APIKeys.weatherAPIKey;
const urlFirstPart = 'https://api.openweathermap.org/data/2.5/weather';
const urlOneCall = 'https://api.openweathermap.org/data/2.5/onecall';

class WeatherService {
  //for current, which has location.
  //https://api.openweathermap.org/data/2.5/weather?lat=49.28&lon=-123.12&units=metric&appid=856822fd8e22db5e1ba48c0e7d69844a
  static Future<dynamic> getCurrentWeather(String units) async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    // print("position: $position");
    String url =
        '$urlFirstPart?lat=${position.latitude}&lon=${position.longitude}&units=$units&appid=$apiKey';
    var weatherData = await NetworkHelper(url: url).getData();
    return weatherData;
  }

  // 'https://api.openweathermap.org/data/2.5/onecall?lat=49.28&lon=-123.12&exclude=minutely&units=metric&appid=856822fd8e22db5e1ba48c0e7d69844a');
  static Future<dynamic> getForecastWeather(String units) async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    String url =
        '$urlOneCall?lat=${position.latitude}&lon=${position.longitude}&exclude=minutely&units=$units&appid=$apiKey';
    var weatherData = await NetworkHelper(url: url).getData();
    return weatherData;
  }
}

class HourlyWeatherData {
  final String hourlyIcon;
  final int hourlyTem;

  HourlyWeatherData({this.hourlyIcon, this.hourlyTem});
}

class DailyWeatherData {
  final String dailyIcon;
  final int maxTem;
  final int minTem;

  DailyWeatherData({this.dailyIcon, this.maxTem, this.minTem});
}

class NetworkHelper {
  NetworkHelper({this.url});
  final String url;

  Future getData() async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var source = response.body;
      return jsonDecode(source);
    } else {
      print({response.statusCode});
      throw Exception('Failed to load data.');
    }
  }
}

class Location {
  //we don't add constructor for this class because we wrote a
  // function to give value to the property
  //  Location({this.lat, this.lon});
  double lat;
  double lon;

  Future<void> getCurrentLocation() async {
    try {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      lat = position.latitude;
      lon = position.longitude;
    } catch (e) {
      print(e);
    }
  }
}
