import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/unsplash_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'loading_indicator.dart';

/// Bottom-sheet displaying info for a given [image].
class InfoSheet extends StatelessWidget {
  final UnsplashImage image;

  InfoSheet(this.image);

  @override
  Widget build(BuildContext context) => /*Container*/ Card(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 16.0),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0)),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: image != null
                ? <Widget>[
                    InkWell(
                      onTap: () => launch(image?.getUser()?.getHtmlLink()),
                      child: Row(
                        children: <Widget>[
                          _buildUserProfileImage(
                              image?.getUser()?.getMediumProfileImage()),
                          Expanded(
                            child: Text(
                              '${image.getUser().getFirstName()} ${image?.getUser()?.getLastName()}',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    _buildDateWidget('${image.createdAtFormatted()}'),
                    // show description
                    _buildDescriptionWidget(image.getDescription()),
                    _buildAltDescription(image.getAltDescription()),
                    // show location
                    _buildLocationWidget(image.getLocation()),
                    // show exif data
//                    _buildExifWidget(image.getExif()),
                    // filter null views
                  ].where((w) => w != null).toList()
                : <Widget>[LoadingIndicator(Colors.black26)]),
        /*decoration: new BoxDecoration(
            color: Colors.grey[50],
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0))),*/
      );

  /// Builds a round image widget displaying a profile image from a given [url].
  Widget _buildUserProfileImage(String url) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: CircleAvatar(
          backgroundImage: NetworkImage(url),
        ),
      );

  Widget _buildDateWidget(String date) => date != null
      ? Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
          child: Text(
            'Created at:  ${date.toUpperCase()}',
            style: TextStyle(
                color: lightThemeWords,
                fontSize: 12.0,
                fontWeight: FontWeight.bold),
          ),
        )
      : null;

  /// Builds widget displaying a given [description] for an image.
  Widget _buildDescriptionWidget(String description) => description != null
      ? Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
          child: Text(
            '$description',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16.0,
              letterSpacing: 0.1,
            ),
          ),
        )
      : null;

  Widget _buildAltDescription(String altDescription) => altDescription != null
      ? Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
          child: Text(
            '$altDescription',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16.0,
              letterSpacing: 0.1,
            ),
          ),
        )
      : null;

  /// Builds a widget displaying the [location], where the image was captured.
  Widget _buildLocationWidget(Location location) => location != null
      ? Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 30.0, right: 16.0),
          child: Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.black54,
                  )),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '${location.getCity()}, ${location.getCountry()}'
                          .toUpperCase(),
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
            ],
          ),
        )
      : null;

  /// Builds a widget displaying all [exif] data
  // Widget _buildExifWidget(Exif exif) => exif != null
  //     ? Padding(
  //         padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
  //         child: Row(
  //           children: <Widget>[
  //             Padding(
  //                 padding: EdgeInsets.all(8.0),
  //                 child: Icon(
  //                   Icons.photo_camera,
  //                   color: Colors.black54,
  //                 )),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 Padding(
  //                     padding: EdgeInsets.only(
  //                         left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
  //                     child: Text(
  //                       '${exif.getModel()}',
  //                       style: TextStyle(
  //                           color: Colors.black54,
  //                           fontSize: 14.0,
  //                           fontWeight: FontWeight.bold),
  //                     )),
  //                 Row(
  //                   children: <Widget>[
  //                     // display exif info
  //                     _buildExifInfoItem('ƒ${exif.getAperture()}'),
  //                     _buildExifInfoItem('${exif.getExposureTime()}'),
  //                     _buildExifInfoItem('${exif.getFocalLength()}mm'),
  //                     _buildExifInfoItem('ISO${exif.getIso()}'),
  //                   ],
  //                 ),
  //               ],
  //             )
  //           ].where((w) => w != null).toList(),
  //         ))
  //     : null;

  /// Builds exif info item that displays given [data].
  // Widget _buildExifInfoItem(String data) => data != null
  //     ? Padding(
  //         padding:
  //             EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
  //         child: Text(
  //           data,
  //           style: TextStyle(
  //               color: Colors.black26,
  //               fontSize: 12.0,
  //               fontWeight: FontWeight.bold),
  //         ))
  //     : null;
}
