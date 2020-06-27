import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:iMomentum/app/constants/api_key.dart';

const apiKey = APIKeys.weatherAPIKey;
const urlFirstPart = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future<dynamic> getLocationWeather() async {
    var position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

    var response = await http.get(
        '$urlFirstPart?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$apiKey');

    if (response.statusCode == 200) {
      var weatherData = jsonDecode(response.body);
      return weatherData; //that's the data we want to use
    } else {
      print(response.statusCode);
      throw Exception('Failed to load');
    }
  }
}
