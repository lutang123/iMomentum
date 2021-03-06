import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/image_path.dart';
import 'package:photo_view/photo_view.dart';

// //HTTP request failed, statusCode: 503, https://source.unsplash.com/random?nature

// 503 SERVICE UNAVAILABLE
// The server is currently unable to handle the request due to a temporary overload or scheduled maintenance, which will likely be alleviated after some delay.
class BuildPhotoView extends StatelessWidget {
  const BuildPhotoView({
    Key key,
    @required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) => PhotoView(
      imageProvider: NetworkImage(imageUrl),
      initialScale: PhotoViewComputedScale.covered,
      minScale: PhotoViewComputedScale.covered,
      maxScale: PhotoViewComputedScale.covered,
      loadFailedChild: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.fixedImagePath),
            fit: BoxFit.cover,
//            colorFilter: ColorFilter.mode(
//                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
      ),
      loadingBuilder: (BuildContext context, ImageChunkEvent event) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagePath.loadingImage),
              fit: BoxFit.cover,
//            colorFilter: ColorFilter.mode(
//                Colors.white.withOpacity(0.8), BlendMode.dstATop),
            ),
          ),
          child: Container(),
          // Center(
          //     child: CircularProgressIndicator(
          //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
          // )),
        );
      });
}
