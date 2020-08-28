import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/screens/unsplash/staggered_view.dart';
import 'package:iMomentum/screens/unsplash/tags_list.dart';
import 'package:iMomentum/app/services/network_service/unsplash_image_provider.dart';
import 'package:iMomentum/screens/unsplash/widget/image_tile.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';
import '../../app/models/unsplash_image.dart';

//adding search to the app
class SearchPhotos extends SearchDelegate<Container> {
  var tagsList = TagsList.tagsList;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    assert(context != null);
//    final ThemeData theme = Theme.of(context);
//    assert(theme != null);
    return _darkTheme ? darkTheme : lightTheme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: _darkTheme ? Colors.white : Colors.black87,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: _darkTheme ? Colors.white : Colors.black87,
      ),
      onPressed: () {
        Navigator.of(context).pop();
//        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StaggeredView(query, searching: false);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var appHeight = MediaQuery.of(context).size.height;
    var appWidth = MediaQuery.of(context).size.width;

    final suggestionsList = tagsList
        .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    int page = 0;
    Future<List<UnsplashImage>> _loadImages({String keyword}) async {
      // set loading state
      // delay setState, otherwise: Unhandled Exception: setState() or markNeedsBuild() called during build.
//    setState(() {
//      // set loading
//      loadingImages = true;
//    });
      //load images
      // load images
      List<UnsplashImage> images;
      List res = await UnsplashImageProvider.loadImagesWithKeywords(keyword,
          page: ++page);
      // set totalPages
      int totalPages = res[0];
      print('totalPage: $totalPages'); //32680
      images = res[1];
//    setState(() {
//      loadingImages = false;
//    });
      return images;
    }

    //return listview of 15 elements or less with appropriate results
    return ListView.builder(
      itemCount: (suggestionsList.length < 11) ? suggestionsList.length : 10,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Container(
            margin: EdgeInsets.only(
                left: appWidth / 60,
                top: appHeight / 100,
                right: appWidth / 60),
            height: appHeight / 6,
            child: Row(
              children: <Widget>[
                Expanded(flex: 1, child: Text(suggestionsList[index])),
                Expanded(
                  flex: 3,
                  child: FutureBuilder(
                    future: _loadImages(keyword: suggestionsList[index]),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return Container();
                      } else {
                        //listView to show sample images of each query
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ImageTile(image: snapshot.data[index]),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: appWidth / 2000))),
          ),
          onTap: () {
            query = suggestionsList[index];
            showResults(context);
          },
        );
      },
    );
  }
}

//class StaggeredViewKeyword extends StatefulWidget {
//  final Database database;
//
//  final query;
//  const StaggeredViewKeyword(this.query, {Key key, this.database});
//
//  @override
//  _StaggeredViewKeywordState createState() => _StaggeredViewKeywordState(query);
//}
//
//class _StaggeredViewKeywordState extends State<StaggeredViewKeyword> {
//  var query;
//  _StaggeredViewKeywordState(this.query);
//
//  Future<List<UnsplashImage>> _loadImages({String keyword}) async {
//    //delay setState, otherwise: Unhandled Exception: setState() or markNeedsBuild() called during build.
//    await Future.delayed(Duration(microseconds: 1));
//
//    //load images
//    List res = await UnsplashImageProvider.loadImagesWithKeywords(keyword,
//        page: ++page);
//    // set totalPages
//    int totalPages = res[0];
//    print('totalPage: $totalPages');
//
//    return res[1];
//  }
//
//  var x =
//      []; //variable to update the image info as scrolling reaches max extent for 'happy' page
//  var y =
//      []; //variable to update the image info as the scrolling reaches max extent for all not 'happy' page
//  var imageQuery; //Variable to take in query input
//  int page = 0;
//  //function to update the variables when scrolling reaches max extent
//  updatedInfo(query) async {
//    page = page + 1;
//
//    if (query != 'nature') {
//      y = y + await _loadImages(keyword: query);
////      print('y: $y');
////      print(y.length);
//      return y;
//    } else {
//      x = x + await _loadImages(keyword: 'nature');
//      return x;
//    }
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    //update UnsplashImages function and app new page to list
//    UnsplashImageProvider.unsplashImages(query);
//    _scrollController.addListener(() {
//      if (_scrollController.position.maxScrollExtent ==
//          _scrollController.offset) {
//        setState(() {
//          updatedInfo(query);
//        });
//      }
//    });
//  }
//
//  var _scrollController = ScrollController();
//
//  //dispose scroll controller
//  @override
//  void dispose() {
//    super.dispose();
//    _scrollController.dispose();
//  }
//
//  /// Returns a StaggeredTile for a given [image].
//  StaggeredTile _buildStaggeredTile(UnsplashImage image, int columnCount) {
//    // calc image aspect ration
//    double aspectRatio =
//        image.getHeight().toDouble() / image.getWidth().toDouble();
//    print(image.getId());
//    // calc columnWidth
//    double columnWidth = MediaQuery.of(context).size.width / columnCount;
//    // not using [StaggeredTile.fit(1)] because during loading StaggeredGrid is really jumpy.
//    return StaggeredTile.extent(1, aspectRatio * columnWidth);
//  }
//
//  Widget _buildImageGrid(AsyncSnapshot<dynamic> snapshot) {
////    int columnCount = orientation == Orientation.portrait ? 2 : 3;
//    return SliverPadding(
//      padding: const EdgeInsets.all(8.0),
//      sliver: SliverStaggeredGrid.countBuilder(
//        // set column count
//        crossAxisCount: 2,
//        itemCount: snapshot.data.length,
//        // set itemBuilder
//        itemBuilder: (BuildContext context, int index) =>
////            _buildImageItemBuilder(index),
//            ImageTile(
//          image: snapshot.data[index],
//          database: widget.database,
//        ),
//        staggeredTileBuilder: (int index) =>
//            _buildStaggeredTile(snapshot.data[index], 2),
//        mainAxisSpacing: 16.0,
//        crossAxisSpacing: 16.0,
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return FutureBuilder(
//        // pass image loader
//        future: updatedInfo(query),
//        builder: (context, snapshot) {
//          if (snapshot.data != null) {
//            return // image loaded return [_ImageTile]
//                CustomScrollView(
//              // put AppBar in NestedScrollView to have it sliver off on scrolling
//              slivers: <Widget>[
//                _buildImageGrid(snapshot),
//                //filter null views
//              ].where((w) => w != null).toList(),
//              controller: _scrollController,
//            );
//          } else if (snapshot.hasError) {
//            return Center(
//              child: Column(
//                children: <Widget>[
//                  Text(snapshot.error.toString()),
//                  EmptyMessage(
//                    title: 'Something went wrong',
//                    message:
//                        'Can\'t load items right now, please try again later',
//                  )
//                ],
//              ),
//            );
//          }
//          return Center(
//            child: SpinKitDoubleBounce(
//              color: Colors.white,
//              size: 50.0,
//            ),
//          );
//        });
//  }
//}
