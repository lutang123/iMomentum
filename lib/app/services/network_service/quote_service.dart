//import 'dart:convert';
//
//import 'package:http/http.dart' as http;
//
////http://quotes.rest/qod.json?maxlength=150&category=inspire
//
//class QuoteService {
//  static Future<dynamic> fetchQuote() async {
//    try {
//      final response = await http
//          .get('http://quotes.rest/qod.json?maxlength=100&category=inspire');
////      print(response.statusCode);
//      if (response.statusCode == 200) {
//        return json.decode(response.body)['contents']['quotes'][0];
//      } else {
//        throw Exception('Failed to load quote');
//      }
//    } catch (e) {
//      print('error in fetchging quote: $e');
//    }
//  }
//}
//
////    try {
////      final response = await http.get('https://favqs.com/api/qotd');
////      print(response.statusCode);
////      if (response.statusCode == 200) {
////        return json.decode(response.body)['quote'];
////      } else {
////        throw Exception('Failed to load quote');
////      }
////    } catch (e) {
////      print('error in fetchging quote: $e');
////    }
//
////      final response = await http.get('http://quotes.rest/quote/random.json');
////      if (response.statusCode == 200) {
////        return json.decode(response.body)['contents']['quotes'][0];
////      } else {
////        throw Exception('Failed to load location weather');
////      }
//
///// Quote kindly supplied by https://theysaidso.com/api/
//
///// http://quotes.rest/qod.json?maxlength=100&category=inspire
//
////'https://favqs.com/api/qotd'
//
////'“The world breaks everyone and afterward many are strong at the broken places.” --Ernest Hemingway'
