import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iMomentum/app/common_widgets/empty_and_error_content.dart';
import 'package:iMomentum/app/constants/my_strings.dart';
import 'package:iMomentum/screens/home_drawer/unsplash/widget/image_tile.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/services/network_service/unsplash_image_provider.dart';
import 'package:iMomentum/screens/home_drawer/unsplash/widget/loading_indicator.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'image_page.dart';
import '../../../app/models/unsplash_image.dart';

class StaggeredView extends StatefulWidget {
  final Database database;
  final query;
  // final bool searching;
  const StaggeredView(
    this.query, {
    Key key,
    this.database,
    // this.searching = true,
  });

  @override
  _StaggeredViewState createState() => _StaggeredViewState();
}

class _StaggeredViewState extends State<StaggeredView> {
  ScrollController _scrollController;

  Future<List<UnsplashImage>> imageList;
  get query => widget.query;
  // get searching => widget.searching;

  @override
  void initState() {
    super.initState();
    //We instantiate it within our initState method
    _scrollController = ScrollController();

    imageList = _loadImages(keyword: query);
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
    // load images
    List<UnsplashImage> images;
    List res = await UnsplashImageProvider.loadImagesWithKeywords(
      keyword,
      page:
          ++page, //we canot not remove this, otherwise it keeps getting the same 10 images
    );
    // set totalPages
//    int totalPages = res[0];
//    print('totalPage: $totalPages'); //32680
    images = res[1];
    setState(() {
      loadingImages = false;
    });
    return images;
  }

  List<UnsplashImage> x =
      []; //variable to update the image info as scrolling reaches max extent for 'natural' page
  List<UnsplashImage> y =
      []; //variable to update the image info as the scrolling reaches max extent for all not 'natural' page
  var imageQuery; //Variable to take in query input
  int page = 0;
  //function to update the variables when scrolling reaches max extent
  Future<List<UnsplashImage>> updatedInfo(query) async {
    page = page + 1;
    if (query != 'nature') {
      y = y + await _loadImages(keyword: query);
//      print('y: $y');
//      print(
//          'y.length: ${y.length}'); //10, and every time we scroll up, we got 10 more
      return y;
    } else {
      x = x + await _loadImages(keyword: 'nature');
//      if (x.length < 41 && x.length > 0) {
      ///got error when scrolling to 40, but not in search
//      print('x.length: ${x.length}'); //10
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
        staggeredTileBuilder: (int index) =>
            _buildStaggeredTile(snapshot.data[index], 2),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        crossAxisCount: 2,
        itemCount: snapshot.data
            .length, //NoSuchMethodError: The getter 'length' was called on null.
        // set itemBuilder
        itemBuilder: (BuildContext context, int index) =>
//            ImageTile(
//          image: snapshot.data[index],
//          database: widget.database,
//        ),
            ///Notes on openContainer, no difference on navigation, slightly better animation
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
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      imageList = _loadImages(keyword: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
//        future: updatedInfo(query), //do not use this one.
        future: imageList,
        builder: (context, snapshot) {
//          print('snapshot.connectionState: ${snapshot.connectionState}');
//          print('snapshot.data: ${snapshot.data}');
          ///we can not have ConnectionState.done, because we need to keep loading new
//          if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            return // image loaded return [_ImageTile]
                LiquidPullToRefresh(
              height: 100, //default
              springAnimationDurationInMilliseconds: 700,
              animSpeedFactor: 1, //default
              color: Color(0XF0bbe1fa),
              backgroundColor: Color(0XF00f4c75),
              onRefresh: _handleRefresh,
              showChildOpacityTransition: false,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  _buildImageGrid(snapshot),

                  ///why not showing? TODO
                  loadingImages
                      ? SliverToBoxAdapter(
                          child: LoadingIndicator(Colors.grey[400]),
                        )
                      : null,
                ].where((w) => w != null).toList(), //filter null views??
              ),
            );
          } else if (snapshot.hasError) {
            print(
                'snapshot.hasError in fetching unsplash images: ${snapshot.error.toString()}');

            ///TODO contact us
            return EmptyOrError(
              tips: Strings.textError,
              textTap: Strings.textErrorOnTap,
              onTap: null,
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
