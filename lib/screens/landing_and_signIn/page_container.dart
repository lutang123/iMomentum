import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/theme.dart';

class MyIntroPageContainer extends StatelessWidget {
  const MyIntroPageContainer({
    Key key,
    @required this.imageURL,
    @required this.title1,
    this.title2,
    this.title3,
    this.title4,
    this.title5,
    // this.title6,
    // this.title7,
  }) : super(key: key);

  final String imageURL;
  final String title1;
  final String title2;
  final String title3;
  final String title4;
  final String title5;
  // final String title6;
  // final String title7;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageURL),
            fit: BoxFit.cover,
          ),
          gradient: KBackgroundGradient),
      constraints: BoxConstraints.expand(),
      child: SafeArea(
        child: Center(
          child: Padding(
            //total: 30
            padding: const EdgeInsets.all(15.0), //(horizontal: 15.0),
            child: MySignInContainer(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: KIntro,
                      children: [
                        TextSpan(text: title1),
                        TextSpan(text: title2, style: KIntroHighlight),
                        TextSpan(text: title3),
                        TextSpan(text: title4, style: KIntroHighlight),
                        TextSpan(text: title5),
                        // TextSpan(text: title6, style: KIntroHighlight),
                        // TextSpan(text: title7),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}

class MyPageContainer extends StatelessWidget {
  const MyPageContainer(
      {Key key,
      @required this.imageURL,
      @required this.title,
      this.subtitle = '',
      this.feature1 = '',
      this.feature2 = '',
      this.feature3 = '',
      this.icon1,
      this.icon2,
      this.icon3})
      : super(key: key);

  final String imageURL;
  final String title;
  final String subtitle;
  final String feature1;
  final String feature2;
  final String feature3;
  final IconData icon1;
  final IconData icon2;
  final IconData icon3;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageURL),
            fit: BoxFit.cover,
          ),
          gradient: KBackgroundGradient),
      constraints: BoxConstraints.expand(),
      child: SafeArea(
        child: Center(
          //without this Center MySignInContainer will expand the screen
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: MySignInContainer(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center, //default
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: KLandingTitle, textAlign: TextAlign.center),
                SizedBox(height: 8),
                Text(subtitle,
                    style: KLandingSubtitle, textAlign: TextAlign.center),
                SizedBox(height: 15),
                buildListTile(icon1, feature1),
                buildListTile(icon2, feature2),
                buildListTile(icon3, feature3),
              ],
            )),
          ),
        ),
      ),
    );
  }

  /// list tile tend to expand and take all screen width and does not look good on wide screen like iPad or web
  ListTile buildListTile(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, //  FontAwesomeIcons.images,
          color: lightThemeButton),
      title: Text(text, style: KLandingFeature),
    );
  }

  /// tried to make it a row, but then on mobile it can run out of space
  Padding iconAndWordsRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, //  FontAwesomeIcons.images,
              color: lightThemeButton),
          SizedBox(width: 30),
          Text(text, style: KLandingFeature)
        ],
      ),
    );
  }
}
