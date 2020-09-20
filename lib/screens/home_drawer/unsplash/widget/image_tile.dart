import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/models/unsplash_image.dart';

/// ImageTile displayed in StaggeredGridView.
class ImageTile extends StatelessWidget {
  final UnsplashImage image;
  final Database database;

  const ImageTile({this.image, this.database});

  /// Adds rounded corners to a given [widget].
  Widget _addRoundedCorners(Widget widget) =>
      // wrap in ClipRRect to achieve rounded corners
      ClipRRect(borderRadius: BorderRadius.circular(10.0), child: widget);

  /// Returns a placeholder to show until an image is loaded.
  Widget _buildImagePlaceholder({UnsplashImage image}) => Container(
        color: image != null
            ? Color(int.parse(image.getColor().substring(1, 7), radix: 16) +
                0x64000000)
            : Colors.grey[200],
      );

  /// Returns a error placeholder to show until an image is loaded.
  Widget _buildImageErrorWidget() => Container(
        color: Colors.grey[200],
        child: Center(
            child: Icon(
          Icons.broken_image,
          color: Colors.grey[400],
        )),
      );

  @override
  Widget build(BuildContext context) => image != null
      ? _addRoundedCorners(CachedNetworkImage(
          imageUrl: image?.getSmallUrl(),
          placeholder: (context, url) => _buildImagePlaceholder(image: image),
          errorWidget: (context, url, obj) => _buildImageErrorWidget(),
          fit: BoxFit.cover,
        ))
      : _buildImagePlaceholder();

//  @override
//  Widget build(BuildContext context) => InkWell(
//        onTap: () {
//          final route = SharedAxisPageRoute(
//              page: ImagePage(image.getId(), image.getRegularUrl(), database),
//              transitionType: SharedAxisTransitionType.scaled);
//          Navigator.of(context).push(route);
//
//          ///this one will pop back to drawer
////          Navigator.of(context).pushReplacement(PageRoutes.zoneIn(
////              () => ImagePage(image.getId(), image.getRegularUrl(), database)));
//
////          // original one
////          Navigator.of(context).push(
////            MaterialPageRoute(
////              builder: (BuildContext context) =>
////                  // open [ImagePage] with the given image
////                  ImagePage(image.getId(), image.getRegularUrl(), database),
////            ),
////          );
//        },
//        child: image != null
//            ? Hero(
//                tag: '${image.getRegularUrl()}',
//                child: _addRoundedCorners(CachedNetworkImage(
//                  imageUrl: image?.getSmallUrl(),
//                  placeholder: (context, url) =>
//                      _buildImagePlaceholder(image: image),
//                  errorWidget: (context, url, obj) => _buildImageErrorWidget(),
//                  fit: BoxFit.cover,
//                )))
//            : _buildImagePlaceholder(),
//      );
}
