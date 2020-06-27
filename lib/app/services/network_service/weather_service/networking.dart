import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper({this.url});
  final String url;

  Future getData() async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var source = response.body;
      return jsonDecode(source);
    } else {
      throw Exception('Failed to load location weather');
    }
  }
}
