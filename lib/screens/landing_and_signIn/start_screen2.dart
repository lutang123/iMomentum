import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/my_flat_button.dart';
import 'package:iMomentum/app/constants/image_path.dart';
import 'package:iMomentum/app/constants/my_strings.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/utils/pages_routes.dart';
import 'package:iMomentum/screens/landing_and_signIn/page_container.dart';
import 'package:iMomentum/screens/landing_and_signIn/start_screen1.dart';
import 'package:iMomentum/screens/landing_and_signIn/start_screen3_(signIn).dart';
import 'dart:math';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/utils/extension_firstCaps.dart';

class StartScreen2 extends StatefulWidget {
  final String name;

  const StartScreen2({Key key, this.name}) : super(key: key);

  @override
  _StartScreen2State createState() => _StartScreen2State();
}

class _StartScreen2State extends State<StartScreen2> {
  String userName;
  // LiquidController liquidController;
  @override
  void initState() {
    userName = widget.name;
    // liquidController = LiquidController();
    super.initState();
  }

  int page = 0;
  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }

  final List<Widget> pages = [
    MyIntroPageContainer(
      imageURL: ImagePath.introImage,
      title1: Strings.intro1,
      title2: Strings.intro2,
      title3: Strings.intro3,
      title4: Strings.intro4,
      title5: Strings.intro5,
      // title6: Strings.intro6,
      // title7: Strings.intro7,
    ),
    MyPageContainer(
      imageURL: ImagePath.startImage1,
      title: Strings.title1,
      subtitle: Strings.subtitle1,
      feature1: Strings.inspirationFeature1,
      feature2: Strings.inspirationFeature2,
      feature3: Strings.inspirationFeature3,
      icon1: FontAwesomeIcons.images,
      icon2: FontAwesomeIcons.solidHeart,
      icon3: FontAwesomeIcons.quoteLeft,
    ),
    MyPageContainer(
      imageURL: ImagePath.startImage2,
      title: Strings.title2,
      subtitle: Strings.subtitle2,
      feature1: Strings.focusFeature1,
      feature2: Strings.focusFeature2,
      feature3: Strings.focusFeature3,
      icon1: FontAwesomeIcons.clock,
      icon2: FontAwesomeIcons.list,
      icon3: FontAwesomeIcons.stickyNote,
    ),
    MyPageContainer(
      imageURL: ImagePath.startImage3,
      title: Strings.title3,
      subtitle: Strings.subtitle3,
      feature1: Strings.customizationFeature1,
      feature2: Strings.customizationFeature2,
      feature3: Strings.customizationFeature3,
      icon1: FontAwesomeIcons.cloudUploadAlt,
      icon2: FontAwesomeIcons.edit,
      icon3: FontAwesomeIcons.edit,
    ),
  ];

  Widget _buildDot(int index) {
    double selected = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page ?? 0) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selected;
    return new Container(
      width: 25.0,
      child: Center(
        child: Material(
          color: Colors.white,
          type: MaterialType.circle,
          child: new Container(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: darkThemeNoPhotoColor,
      body: Stack(
        children: <Widget>[
          LiquidSwipe(
            pages: pages,
            enableSlideIcon: true,
            positionSlideIcon: 0.6,
            fullTransitionValue: 600,
            slideIconWidget: page == pages.length - 1 ? null : swipeButton(),
            enableLoop: true,
            onPageChangeCallback: pageChangeCallback,
            waveType: WaveType.liquidReveal,
            // ignoreUserGestureWhileAnimating:
            //     page == pages.length - 1 ? false : true,
            // liquidController: liquidController,
          ),
          topColumn(height, context),
          page == pages.length - 1 ? startButton(height, context) : Container(),
          bottomDots(),
        ],
      ),
    );
  }

  Positioned topColumn(double height, BuildContext context) {
    return Positioned(
      left: 30,
      right: 30,
      top: height * 0.06, // 50/896
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                child: Icon(Icons.arrow_back_ios, color: Colors.white),
                onTap: () =>
                    Navigator.of(context).pushReplacement(PageRoutes.fade(
                  () => StartScreen(),
                )),
              )
            ],
          ),
          SizedBox(height: 20),
          Text('${Strings.welcome}${userName.firstCaps}.', style: KWelcome),
        ],
      ),
    );
  }

  Padding swipeButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        decoration: BoxDecoration(
            color: darkThemeAppBar,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_ios, color: Colors.white),
              SizedBox(width: 2),
              Text(Strings.introSwipe, style: KSwipeButton)
            ],
          ),
        ),
      ),
    );
  }

  Positioned startButton(double height, BuildContext context) {
    return Positioned(
      left: 30,
      right: 30,
      bottom: height * 0.15, //100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(15.0),
              child: MyFlatButton(
                  text: Strings.startButton,
                  onPressed: () =>
                      Navigator.of(context).pushReplacement(PageRoutes.fade(
                        () => StartScreen3(name: userName),
                      ))))
        ],
      ),
    );
  }

  Padding bottomDots() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(pages.length, _buildDot),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// jump to end and previous
// page == pages.length - 1
//     ? Container()
//     : Align(
//         alignment: Alignment.bottomRight,
//         child: Padding(
//           padding: const EdgeInsets.all(25.0),
//           child: FlatButton(
//             onPressed: () {
//               liquidController.animateToPage(
//                   page: pages.length - 1, duration: 500);
//             },
//             child: Container(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text("Skip to End",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.white,
//                     )),
//               ),
//               decoration: BoxDecoration(
//                   color: darkThemeAppBar,
//                   borderRadius:
//                       BorderRadius.all(Radius.circular(10.0))),
//             ),
//             color: Colors.black.withOpacity(0.01),
//           ),
//         ),
//       ),
//
// page == 0
//     ? Container()
//     : Align(
//         alignment: Alignment.bottomLeft,
//         child: Padding(
//           padding: const EdgeInsets.all(25.0),
//           child: FlatButton(
//             onPressed: () {
//               liquidController.jumpToPage(
//                   page: liquidController.currentPage - 1);
//             },
//             child: Container(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   "Previous Page",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               decoration: BoxDecoration(
//                   color: darkThemeAppBar,
//                   borderRadius:
//                       BorderRadius.all(Radius.circular(10.0))),
//             ),
//             color: Colors.black.withOpacity(0.01),
//           ),
//         ),
//       )
