//import 'package:flutter/material.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:iMomentum/app/common_widgets/empty_content.dart';
//import 'package:iMomentum/app/common_widgets/widget/image_tile.dart';
//import 'package:iMomentum/app/models/image_model.dart';
//import 'package:iMomentum/app/services/database.dart';
//import 'package:iMomentum/app/theme/multi_notifier.dart';
//import 'package:provider/provider.dart';
//import 'models.dart';
//import 'package:iMomentum/app/constants/theme.dart';
//import 'package:iMomentum/app/constants/constants.dart';
//
//class FavoriteImage extends StatefulWidget {
//  final Database database;
//  const FavoriteImage({Key key, this.database}) : super(key: key);
//  @override
//  _FavoriteImageState createState() => _FavoriteImageState();
//}
//
///// Provide a state for [ImageGallery].
//class _FavoriteImageState extends State<FavoriteImage> {
////  /// Asynchronously loads a [UnsplashImage] for a given [index].
////  Future<UnsplashImage> _loadImage(int index) async {
////    // check if new images need to be loaded
////    if (index >= images.length - 2) {
////      // Reached the end of the list. Try to load more images.
////      _loadImages();
////    }
////    return index < images.length ? images[index] : null;
////  }
//
//  @override
//  Widget build(BuildContext context) {
//    final themeNotifier = Provider.of<ThemeNotifier>(context);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//
//    return Scaffold(
//        backgroundColor: _darkTheme ? Color(0xf01b262c) : Colors.grey[50],
//        body: StreamBuilder<List<ImageModel>>(
//          stream: widget.database
//              .imagesStream(), // print(database.todosStream());//Instance of '_MapStream<QuerySnapshot, List<TodoModel>>'
//          builder: (context, snapshot) {
//            if (snapshot.hasData) {
//              final List<ImageModel> images = snapshot.data;
//
//              if (images.isNotEmpty) {
//                return Column(
//                  children: <Widget>[
//                    Expanded(
//                      child: Padding(
//                        padding: const EdgeInsets.only(left: 8.0, right: 8),
//                        child: CustomScrollView(
//                            // put AppBar in NestedScrollView to have it sliver off on scrolling
//                            slivers: <Widget>[
//                              _buildImageGrid(images: images)
//                            ]),
//                      ),
//                    ),
//                  ],
//                );
//              } else {
//                return Center(
//                    child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Text(
//                      'Please enter a task from HomePage first',
//                      style: KEmptyContent,
//                      textAlign: TextAlign.center,
//                    ),
//                  ],
//                ));
//              }
//            } else if (snapshot.hasError) {
//              return Center(
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Text(snapshot.error.toString()),
//                    ErrorMessage(
//                      title: 'Something went wrong',
//                      message:
//                          'Can\'t load items right now, please try again later',
//                    )
//                  ],
//                ),
//              );
//            }
//            return Center(child: CircularProgressIndicator());
//          },
//        ));
//  }
//
//  /// Returns a StaggeredTile for a given [image].
//  StaggeredTile _buildStaggeredTile(ImageModel image, int columnCount) {
//    // calc image aspect ration
//    double aspectRatio =
//        image.height.toDouble() / image.width.toDouble();
//    // calc columnWidth
//    double columnWidth = MediaQuery.of(context).size.width / columnCount;
//    // not using [StaggeredTile.fit(1)] because during loading StaggeredGrid is really jumpy.
//    return StaggeredTile.extent(1, aspectRatio * columnWidth);
//  }
//
//  /// Returns the grid that displays images.
//  /// [orientation] can be used to adjust the grid column count.
//  Widget _buildImageGrid({orientation = Orientation.portrait, List<ImageModel> images }) {
//    // calc columnCount based on orientation
//    int columnCount = orientation == Orientation.portrait ? 2 : 3;
//    // return staggered grid
//    return SliverPadding(
//      padding: const EdgeInsets.all(16.0),
//      sliver: SliverStaggeredGrid.countBuilder(
//        // set column count
//        crossAxisCount: columnCount,
//        itemCount: images.length,
//        // set itemBuilder
//        itemBuilder: (BuildContext context, int index) =>
//            ImageTile(
//              image: images[index],
//              database: widget.database,
//            ),
//        staggeredTileBuilder: (int index) =>
//            _buildStaggeredTile(images[index], columnCount),
//        mainAxisSpacing: 16.0,
//        crossAxisSpacing: 16.0,
//      ),
//    );
//  }
//}
