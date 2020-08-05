import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as PathFile;
import 'models.dart';
import 'dart:io';

/// Screen for showing an individual [UnsplashImage].
class PreviewFile extends StatefulWidget {
  final File imageFile;

  PreviewFile({this.imageFile});

  @override
  _PreviewFileState createState() => _PreviewFileState();
}

class _PreviewFileState extends State<PreviewFile>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    _animationController.addListener(() => setState(() {}));
//    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  StorageUploadTask _uploadTask;

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://imomentum-5969c.appspot.com');

  /// Returns PhotoView around given [imageId] & [imageUrl].
  Widget _buildPhotoView(File imageFile) => PhotoView(
      heroAttributes: PhotoViewHeroAttributes(tag: imageFile.path),
      imageProvider: FileImage(imageFile),
      initialScale: PhotoViewComputedScale.covered,
      minScale: PhotoViewComputedScale.covered,
      maxScale: PhotoViewComputedScale.covered,
      loadingBuilder: (BuildContext context, ImageChunkEvent event) {
        return Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
        ));
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // set the global key
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          _buildPhotoView(widget.imageFile),
          // wrap in Positioned to not use entire screen
          Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.black12,
                title: Text('Preview'),
                leading:
                    // back button
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () => Navigator.pop(context)),
              )),
          Positioned(
            bottom: 60,
            left: 60,
            right: 60,
            child: ClipRRect(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: _uploadTask != null
                      ?

                      /// Manage the task state and event subscription with a StreamBuilder
                      StreamBuilder<StorageTaskEvent>(
                          stream: _uploadTask.events,
                          builder: (_, snapshot) {
                            var event = snapshot?.data?.snapshot;

                            double progressPercent = event != null
                                ? event.bytesTransferred / event.totalByteCount
                                : 0;

                            return Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                LiquidCustomProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.blue[200]),
                                  backgroundColor: Colors
                                      .black38, // Defaults to the current Theme's backgroundColor.
                                  value: 0.2,
                                  shapePath: _buildBoatPath(),
                                  direction: Axis
                                      .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      if (_uploadTask.isComplete)
                                        Icon(Icons.cloud_done),
                                      SizedBox(height: 3),
//                                    if (_uploadTask.isPaused)
//                                      FlatButton(
//                                        child: Icon(Icons.play_arrow),
//                                        onPressed: _uploadTask.resume,
//                                      ),
//                                    if (_uploadTask.isInProgress)
//                                      FlatButton(
//                                        child: Icon(Icons.pause),
//                                        onPressed: _uploadTask.pause,
//                                      ),
//                                    SizedBox(height: 5),
                                      Text(
                                        '${(progressPercent * 100).round()}%',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          })

                      // Allows user to decide when to start the upload
                      : MyFlatButton(
                          text: 'Set as background photo', onPressed: _apply
//                  _onImageChanged(context, imageFile, imageNotifier),
                          ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Path _buildBoatPath() {
    return Path()
      ..moveTo(15, 120)
      ..lineTo(0, 85)
      ..lineTo(50, 85)
      ..lineTo(50, 0)
      ..lineTo(105, 80)
      ..lineTo(60, 80)
      ..lineTo(60, 85)
      ..lineTo(120, 85)
      ..lineTo(105, 120)
      ..close();
  }

  /// Starts an upload task
  void _apply() async {
    /// Unique file name for the file
    String filePath = 'images/${PathFile.basename(widget.imageFile.path)}}';
//    print(filePath);
    //StorageReference
    final StorageReference storageReference = _storage.ref().child(filePath);

    //StorageUploadTask
    setState(() {
      _uploadTask = storageReference.putFile(widget.imageFile);
    });

    StorageTaskSnapshot storageSnapshot = await _uploadTask.onComplete;
    print('File Uploaded');

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    final imageNotifier = Provider.of<ImageNotifier>(context, listen: false);
    final randomNotifier = Provider.of<RandomNotifier>(context, listen: false);
//      final appliedOwnPhotoNotifier =
//          Provider.of<AppliedOwnPhotoNotifier>(context, listen: false);
    //save image changes
    imageNotifier.setImage(downloadUrl);
    //change the randomOn value to false at the same time
    randomNotifier.setRandom(false);
//      appliedOwnPhotoNotifier.setBoolOwnPhoto(true);
    //then save in shared preference
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('imageUrl', downloadUrl);
    //save settings
    prefs.setBool('randomOn', false);

    ///also save filepath and appliedURL
    prefs.setString('appliedImageUrl', downloadUrl);
    prefs.setString('appliedFilePath', filePath);
    prefs.setBool('appliedOwnPhoto', true);

    await Future.delayed(Duration(minutes: 1));

    ///navigate back two level
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == 2;
    });

    ///change ui,
    //make the screen only show uploadedFileURL, we can not make _imageFile as
    // null because then we can't use it to delete
//    setState(() {
//      _uploadedFileURL = downloadUrl;
////      _imageFileVisible = false;
//    });
  }
}
