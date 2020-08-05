import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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
            image: AssetImage('assets/images/cloud.jpg'),
            fit: BoxFit.cover,
//            colorFilter: ColorFilter.mode(
//                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        child: Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
        )),
      ),
      loadingBuilder: (BuildContext context, ImageChunkEvent event) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/cloud.jpg'),
              fit: BoxFit.cover,
//            colorFilter: ColorFilter.mode(
//                Colors.white.withOpacity(0.8), BlendMode.dstATop),
            ),
          ),
          child: Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
          )),
        );
      });
}
