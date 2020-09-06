import 'dart:convert';
import 'dart:io';
import 'package:iMomentum/app/constants/api_key.dart';
import '../../models/unsplash_image.dart';

/// Helper class to interact with the Unsplash Api and provide [UnsplashImage].
class UnsplashImageProvider {
  ///load random
//  static loadImagesRandom() async {
////    int counter = 0;
//    //'https://api.unsplash.com/search/photos?query=$keywords&page=$page&per_page=$perPage&order_by=popular&client_id=${Keys.unsplashAPI}'
//    String url =
//        'https://api.unsplash.com/photos/random?query=nature&client_id=${Keys.unsplashAPI}';
////    counter++;
//    // receive image data from unsplash
//    var data = await _getImageData(url);
////    print(data);
//    return UnsplashImage(data);
//  }

  /// Asynchronously loads a [UnsplashImage] for a given [id].
  static Future<UnsplashImage> loadImage(String id) async {
    String url = 'https://api.unsplash.com/photos/$id';
    // receive image data from unsplash
    var data = await _getImageData(url);
    // return image
    return UnsplashImage(data);
  }

  /// Asynchronously load a list of trending [UnsplashImage].
  /// Returns a list of [UnsplashImage].
  /// [page] is the page index for the api request.
  /// [perPage] sets the length of the returned list.
//  static Future<List> loadImages({int page = 1, int perPage = 10}) async {
//    String url =
//        'https://api.unsplash.com/photos?page=$page&per_page=$perPage';
//    // receive image data from unsplash
//    var data = await _getImageData(url);
//    // generate UnsplashImage List from received data
//    List<UnsplashImage> images =
//        List<UnsplashImage>.generate(data.length, (index) {
//      return UnsplashImage(data[index]);
//    });
//    // return images
//    return images;
//  }

  static Future<List> loadImagesWithKeywords(String keywords,

      ///when changed perPage to >10, we get nothing but error, why?
      {int page = 1,
      int perPage = 10}) async {
    // Search for image associated with the keyword
    String url =
        //&order_by=popular??? (Optional; default: relevant). Valid values are latest and relevant.) //&orientation=portrait
        'https://api.unsplash.com/search/photos?query=$keywords&page=$page&per_page=$perPage&client_id=${APIKeys.unsplashAPI}';
    // receive image data from unsplash associated to the given keyword
    var data = await _getImageData(url);
    // generate UnsplashImage List from received data
//    print(
//        'data result length: ${data['results'].length}'); //data result length: 10

    //this line got error: type'List<dynamic> is not a subtyoe of List<UnsplashImage>
//    List<UnsplashImage> images = data['results'];
//    var images = data['results']; //this is not working either

    ///got length called on null error when scrolling to 40, don't know why
    List<UnsplashImage> images =
        List<UnsplashImage>.generate(data['results'].length, (index) {
      return UnsplashImage(data['results'][index]);
    });
    int totalPages = data['total_pages'];
//    print(data);
//    print('images.length: ${images.length}');
    return [totalPages, images];
  }

  ///alternative way on http.get, but no header
//   static dynamic _getImageData(String url) async {
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       // If the server did return a 200 OK response,
//       // then parse the JSON.
//
//       var jsonData = json.decode(response.body);
// //      print('jsonData: $jsonData');
//       return jsonData;
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       print("Http error: ${response.statusCode}"); //flutter: Http error: 401
//       //The HTTP 401 Unauthorized client error status response code indicates that the request has not been applied because it lacks valid authentication credentials for the target resource. ... This status is similar to 403 , but in this case, authentication is possible.
//       throw Exception('Failed to load photos');
//     }
//   }

  /// Receive image data from a given [url] and return the JSON decoded the data.
  static dynamic _getImageData(String url) async {
    // setup http client
    HttpClient httpClient = HttpClient();
    // setup http request
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    // pass the client_id in the header
    request.headers.add('Authorization', 'Client-ID ${APIKeys.unsplashAPI}');

    // wait for response
    HttpClientResponse response = await request.close();
    // print('response.statusCode: ${response.statusCode}');
    // Process the response
    if (response.statusCode == 200) {
      // response: OK
      // decode JSON
      // print('hello 1 ');
      String json = await response.transform(utf8.decoder).join();
      // print('hello 2');
      // print('jsonDecode(json): ${jsonDecode(json)}');
      //flutter: {total: 4012, total_pages: 402, results: [{id: yB6WFHbkX40, created_at: 2017-06-26T15:02:15-04:00, updated_at: 2020-07-21T01:28:45-04:00, promoted_at: null, width: 5184, height: 3456, color: #18191C, description: Woman near a pool, alt_description: Santorini, Greece, urls: {raw: https://images.unsplash.com/photo-1498503403619-e39e4ff390fe?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEzNjA0M30, full: https://images.unsplash.com/photo-1498503403619-e39e4ff390fe?ixlib=rb-1.2.1&q=85&fm=jpg&crop=entropy&cs=srgb&ixid=eyJhcHBfaWQiOjEzNjA0M30, regular: https://images.unsplash.com/photo-1498503403619-e39e4ff390fe?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjEzNjA0M30, small: https://images.unsplash.com/photo-1498503403619-e39e4ff390fe?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjEzNjA0M30, thumb: https://images.unsplash.com/photo-1498503403619-e39e4ff390fe?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid<…>
      ///found problem: when x.length: 40, response.statusCode is still 200,
      ///but print(jsonDecode(json)) return{}
      ///
      /// mistakenly commented  return jsonDecode(json); and can't get any images
      return jsonDecode(json);
    } else {
      // something went wrong :(
      print("Http error: ${response.statusCode}");
      // return empty list
      return [];
    }
  }
}

///another way of parsing json data to objects, we used this way in weather info.
//  static Future<List<UImage>> unsplashImages(imageQuery) async {
//    int page = 0;
//
//    //if query is not null then get the info of images
//    if (imageQuery != null) {
//      var source = await http.get(
//          'https://api.unsplash.com/search/photos?page=$page&query=$imageQuery&per_page=15&client_id=6afce23445904aebe8ef6e597340247cf1357b4ca8b439283a48eea3c4fa9247');
//      var jsonData = jsonDecode(source.body);
//
//      List<UImage> Images_Info = [];
//
//      for (var image in jsonData['results']) {
//        var tags = [];
//        for (var i in image['tags']) {
//          tags.add(i['title']);
//        }
//        var Image_info = UImage(
//            image['user']['name'],
//            image['user']['username'],
//            image['description'],
//            image['alt_description'],
//            image['urls']['small'],
//            image['urls']['regular'],
//            tags,
//            image['user']['profile_image']['small']);
//        Images_Info.add(Image_info);
//      }
//      return Images_Info; //return image info
//    }
//  }

///notes on other functions:
//  String url = 'https://api.unsplash.com/search/photos?page=$page&query=$imageQuery&per_page=15&client_id=apiKey'

///another class
//class UImage {
//  final String user_name;
//  final String website_user_name;
//  final String description;
//  final String alt_description;
//  final String url;
//  final List tags;
//  final String profile_image;
//  final String regular_image_url;
//
//  UImage(
//      this.user_name,
//      this.website_user_name,
//      this.description,
//      this.alt_description,
//      this.url,
//      this.regular_image_url,
//      this.tags,
//      this.profile_image);
//}
