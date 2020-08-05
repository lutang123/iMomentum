import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iMomentum/app/common_widgets/empty_content.dart';
import 'package:iMomentum/screens/unsplash/widget/image_tile.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/unsplash/search_photo.dart';
import 'package:iMomentum/screens/unsplash/unsplash_image_provider.dart';
import 'package:iMomentum/screens/unsplash/widget/loading_indicator.dart';
import 'package:provider/provider.dart';

import 'image_page.dart';
import 'models.dart';

class StaggeredView extends StatefulWidget {
  final Database database;

  final query;
  final bool searching;
  const StaggeredView(this.query,
      {Key key, this.database, this.searching = true});

  @override
  _StaggeredViewState createState() => _StaggeredViewState();
}

class _StaggeredViewState extends State<StaggeredView> {
//  var query;
//  bool searching;
//  _StaggeredViewState(this.query, {this.searching = true});

  //the first step is to declare a ScrollController variable.
  ScrollController _scrollController;

  Future<List<UnsplashImage>> imageList;
  get query => widget.query;
  get searching => widget.searching;

  bool searching2;
  @override
  void initState() {
    super.initState();
    setState(() {
      searching2 = searching;
    });
    //We instantiate it within our initState method
    _scrollController = ScrollController();
    imageList = _loadImages(keyword: query);
    //update UnsplashImages function and app new page to list
//    UnsplashImageProvider.unsplashImages(query);
//    _loadImages(keyword: 'nature');
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        setState(() {
          imageList = updatedInfo(query); //this return a list of images
        });
      }
    });
  }

  /// States whether there is currently a task running loading images.
  bool loadingImages = false;

  Future<List<UnsplashImage>> _loadImages({String keyword}) async {
    // set loading state
    // delay setState, otherwise: Unhandled Exception: setState() or markNeedsBuild() called during build.
    await Future.delayed(Duration(microseconds: 1));
    setState(() {
      // set loading
      loadingImages = true;
    });
    //load images
    // load images
    List<UnsplashImage> images;
    List res = await UnsplashImageProvider.loadImagesWithKeywords(
      keyword,
      page:
          ++page, //we canot not remove this, otherwise it keeps getting the same 10 images
    );
    // set totalPages
    int totalPages = res[0];
    print('totalPage: $totalPages'); //32680
    images = res[1];
    setState(() {
      loadingImages = false;
    });
    return images;
  }

  List<UnsplashImage> x =
      []; //variable to update the image info as scrolling reaches max extent for 'happy' page
  List<UnsplashImage> y =
      []; //variable to update the image info as the scrolling reaches max extent for all not 'happy' page
  var imageQuery; //Variable to take in query input
  int page = 0;
  //function to update the variables when scrolling reaches max extent
  Future<List<UnsplashImage>> updatedInfo(query) async {
    page = page + 1;
    if (query != 'nature') {
      y = y + await _loadImages(keyword: query);

      ///not totally understand why
//      print('y: $y');
      print(
          'y.length: ${y.length}'); //10, and every time we scroll up, we got 10 more
      return y;
    } else {
      x = x + await _loadImages(keyword: 'nature');
//      if (x.length < 41 && x.length > 0) {
      ///got error when scrolling to 40, but not in search
      print('x.length: ${x.length}'); //10
      return x;
//      }
    }
  }

  //dispose scroll controller
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget _buildSearchAppBar() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SliverPadding(
      padding: const EdgeInsets.only(top: 8.0),
      sliver: SliverAppBar(
        backgroundColor: _darkTheme ? Color(0xf01b262c) : Colors.grey[50],
        automaticallyImplyLeading: false,
//      stretch: false,
        floating: true,
        title: Container(
            width: 300,
            decoration: BoxDecoration(
//              color: _darkTheme ? darkSurfaceTodo : lightSurface,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(
                  width: 1,
                  color: _darkTheme ? Colors.white54 : Colors.black38),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'Search photos',
                    style: TextStyle(
                      fontSize: 14,
                      color: _darkTheme ? darkHint : lightHint,
                    ),
                  ),
                  onPressed: () => showSearch(
                    context: context,
                    delegate: SearchPhotos(),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  color: _darkTheme ? darkHint : lightHint,
                  onPressed: () => showSearch(
                    context: context,
                    delegate: SearchPhotos(),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  /// Returns a StaggeredTile for a given [image].
  StaggeredTile _buildStaggeredTile(UnsplashImage image, int columnCount) {
    // calc image aspect ration
    double aspectRatio =
        image.getHeight().toDouble() / image.getWidth().toDouble();
    // calc columnWidth
    double columnWidth = MediaQuery.of(context).size.width / columnCount;
    // not using [StaggeredTile.fit(1)] because during loading StaggeredGrid is really jumpy.
    return StaggeredTile.extent(1, aspectRatio * columnWidth);
  }

  Widget _buildImageGrid(AsyncSnapshot<dynamic> snapshot) {
//    int columnCount = orientation == Orientation.portrait ? 2 : 3;
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverStaggeredGrid.countBuilder(
        // set column count
        crossAxisCount: 2,
        itemCount: snapshot.data
            .length, //NoSuchMethodError: The getter 'length' was called on null.
        // set itemBuilder
        itemBuilder: (BuildContext context, int index) =>
//            _buildImageItemBuilder(index),
            OpenContainer(
          useRootNavigator: true,
          transitionType: ContainerTransitionType.fade,
          closedBuilder: (BuildContext _, VoidCallback openContainer) {
            return ImageTile(
              image: snapshot.data[index],
              database: widget.database,
            );
          },
          closedColor: Colors.transparent,
          closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          openColor: Colors.transparent,
          openBuilder: (BuildContext context, VoidCallback _) {
            return ImagePage(snapshot.data[index].getId(),
                snapshot.data[index].getRegularUrl(), widget.database);
          },
        ),
        staggeredTileBuilder: (int index) =>
            _buildStaggeredTile(snapshot.data[index], 2),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // pass image loader
//        future: updatedInfo(query),
        future: imageList,
        builder: (context, snapshot) {
//          print('snapshot.connectionState: ${snapshot.connectionState}');
//          print('snapshot.data: ${snapshot.data}');

          ///we can not have ConnectionState.done, because we need to keep loading new
//          if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            return // image loaded return [_ImageTile]
                CustomScrollView(
              controller: _scrollController,
              // put AppBar in NestedScrollView to have it sliver off on scrolling
              slivers: <Widget>[
                searching2
                    ? _buildSearchAppBar()
                    : null, //we can not write Container()
                _buildImageGrid(snapshot),
                //filter null views
                ///why not showing? TODO
                loadingImages
                    ? SliverToBoxAdapter(
                        child: LoadingIndicator(Colors.grey[400]),
                      )
                    : null,
              ].where((w) => w != null).toList(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                children: <Widget>[
                  /// type String is not a subtype of type 'int' of 'index' ??
                  /// Http error: 403
                  ///
                  /// NoSuchMethodError: The getter 'length' was called on null
                  /// it appears when x.length: 40
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      snapshot.error.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  EmptyMessage(
                    title: 'Something went wrong',
                    message:
                        'Can\'t load items right now, please try again later',
                  )
                ],
              ),
            );
          }
//          }
          return Center(
            child: SpinKitDoubleBounce(
              color: Colors.white,
              size: 50.0,
            ),
          );
        });
  }
}
