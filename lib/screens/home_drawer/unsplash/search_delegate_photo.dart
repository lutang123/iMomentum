import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/screens/home_drawer/unsplash/staggered_view.dart';
import 'package:iMomentum/screens/home_drawer/unsplash/tags_list.dart';
import 'package:iMomentum/app/services/network_service/unsplash_image_provider.dart';
import 'package:iMomentum/screens/home_drawer/unsplash/widget/image_tile.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';
import '../../../app/models/unsplash_image.dart';

//adding search to the app
class SearchPhotos extends SearchDelegate<Container> {
  var tagsList = TagsList.tagsList;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    assert(context != null);
    final ThemeData theme = Theme.of(context).copyWith(
        // canvasColor: _darkTheme ? darkThemeHint : lightThemeButton,
        // cursorColor:
        //     _darkTheme ? darkThemeHint : lightThemeHint, //seems didn't change
        hintColor: _darkTheme ? darkThemeHint : lightThemeHint,
        primaryColor: _darkTheme
            ? darkThemeNoPhotoColor
            : lightThemeNoPhotoColor, //no change
        textTheme: TextTheme(
          headline6: TextStyle(
              color: _darkTheme ? darkThemeWords : lightThemeWords,
              fontWeight: FontWeight.w600,
              fontSize: 20),
        ));
    assert(theme != null);
    return theme;
  }

  @override
  Widget buildLeading(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: _darkTheme ? Colors.white : lightThemeButton,
      ),
      onPressed: () {
        Navigator.of(context).pop();
//        close(context, null);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return [
      query == '' || query == null
          ? Container()
          : IconButton(
              icon: Icon(
                Icons.clear,
                color: _darkTheme ? Colors.white70 : lightThemeButton,
              ),
              onPressed: () {
                query = '';
              },
            ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return StaggeredView(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    var appHeight = MediaQuery.of(context).size.height;
    var appWidth = MediaQuery.of(context).size.width;

    final suggestionsList = tagsList
        .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    int page = 0;
    Future<List<UnsplashImage>> _loadImages({String keyword}) async {
      List<UnsplashImage> images;
      List res = await UnsplashImageProvider.loadImagesWithKeywords(keyword,
          page: ++page);
      images = res[1];
      return images;
    }

    //return listview of 15 elements or less with appropriate results
    return Scaffold(
      backgroundColor:
          _darkTheme ? darkThemeNoPhotoColor : lightThemeNoPhotoColor,
      body: ListView.builder(
        itemCount: (suggestionsList.length < 16) ? suggestionsList.length : 15,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.only(
                  left: appWidth / 60,
                  top: appHeight / 100,
                  right: appWidth / 60),
              height: appHeight / 6,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: appWidth / 2000))),
              child: Stack(
                alignment: Alignment.topLeft,
                children: <Widget>[
                  FutureBuilder(
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ContainerOnlyTextPhotoSearch(
                      text: suggestionsList[index],
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              query = suggestionsList[index];
              showResults(context);
            },
          );
        },
      ),
    );
  }
}
