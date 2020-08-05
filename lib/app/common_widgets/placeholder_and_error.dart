import 'package:flutter/material.dart';

class ImageError extends StatelessWidget {
  const ImageError({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
          decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/ocean1.jpg'),
          fit: BoxFit.cover,
        ),
      ));
}

class PlaceHolder extends StatelessWidget {
  const PlaceHolder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
          decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/ocean1.jpg'),
          fit: BoxFit.cover,
        ),
      ));
}

///// Returns a placeholder to show until an image is loaded.
//Widget _buildImagePlaceholder({UnsplashImage image}) => image != null
//    ? Container(
//    color: Color(int.parse(image.getColor().substring(1, 7), radix: 16) +
//        0x64000000))
//    : Image.network(ImageUrl.randomImageUrl, fit: BoxFit.cover);
//
///// Returns a error placeholder to show until an image is loaded.
//Widget _buildImageErrorWidget() => Container(
//  color: Colors.grey[700],
//  child: Text(''),
//);
