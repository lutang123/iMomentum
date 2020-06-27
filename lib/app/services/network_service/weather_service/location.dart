import 'package:geolocator/geolocator.dart';

class Location {
  //we don't add constructor for this class because we wrote a
  // function to give value to the property
  //  Location({this.lat, this.lon});
  double lat;
  double lon;

  Future<void> getCurrentLocation() async {
    try {
      var position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      lat = position.latitude;
      lon = position.longitude;
    } catch (e) {
      print(e);
    }
  }
}
