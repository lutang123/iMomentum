import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/setting_switch.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/mantra_model.dart';
import 'package:iMomentum/app/models/quote_model.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/iPomodoro/clock_mantra_quote_title.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:flutter/cupertino.dart';
import '../../app/constants/constants_style.dart';

class MoreSettingScreen extends StatefulWidget {
  final Database database;

  const MoreSettingScreen({Key key, this.database}) : super(key: key);
  @override
  _MoreSettingScreenState createState() => _MoreSettingScreenState();
}

class _MoreSettingScreenState extends State<MoreSettingScreen> {
  ///launch email, not works, in apple it tried to find Mail
  // final Uri _emailLaunchUri = Uri(
  //     scheme: 'mailto',
  //     path: 'sabrina.tanglu@gmail.com',
  //     queryParameters: {'subject': 'Example Subject & Symbols are allowed!'});
  //
  // Future<void> _launchEmailClient() async {
  //   var url = _emailLaunchUri.toString();
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     print('Could not launch $url');
  //   }
  // }

  int counter = 0;

  void _onDoubleTap() {
    setState(() {
      ImageUrl.randomImageUrl =
          'https://source.unsplash.com/random?nature/$counter';
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final randomNotifier = Provider.of<RandomNotifier>(context, listen: false);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context, listen: false);

    ///for mantra
    final mantraNotifier = Provider.of<MantraNotifier>(context);
    bool _mantraOn =
        mantraNotifier.getMantra(); //default is on if adding your own
    ///for quote
    final quoteNotifier = Provider.of<QuoteNotifier>(context);
    bool _quoteOn = quoteNotifier.getQuote();

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        BuildPhotoView(
          imageUrl:
              _randomOn ? ImageUrl.randomImageUrl : imageNotifier.getImage(),
        ),
        ContainerLinearGradient(),
        GestureDetector(
          onDoubleTap: _onDoubleTap,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(
                    child: CustomizedContainerNew(
                      color: _darkTheme ? darkThemeSurface : lightThemeSurface,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            _topRow(),
                            SettingSwitch(
                              size: 20,
                              icon: FontAwesomeIcons.adjust,
                              title: 'Dark Theme',
                              value: _darkTheme,
                              onChanged: (val) {
                                _darkTheme = val;
                                _onThemeChanged(val, themeNotifier);
                              },
                            ),
                            StreamBuilder<List<MantraModel>>(
                                stream: widget.database
                                    .mantrasStream(), //print: flutter: Instance of '_MapStream<List<TodoDuration>, dynamic>'
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final List<MantraModel> mantras = snapshot
                                        .data; //print('x: $entries'); //x: [Instance of 'TodoDuration', Instance of 'TodoDuration']
                                    return Column(
                                      children: [
                                        SettingSwitch(
                                            size: 20,
                                            icon: FontAwesomeIcons.user,
                                            title: 'Apply Your Own Mantras',
                                            // isThreeLine: true,
                                            // subtitle:
                                            //     'Only available after adding your own mantras.',
                                            value: mantras.length > 0
                                                ? _mantraOn
                                                : false,
                                            onChanged: (val) {
                                              _mantraOn = val;
                                              onMantraChanged(
                                                  val, mantraNotifier);
                                            }),
                                        // Text(
                                        //     'Only available after adding your own mantras.')
                                      ],
                                    );
                                  } else if (snapshot.hasError) {
                                    return Container();
                                  }
                                  return Center(
                                      child: CircularProgressIndicator());
                                }),
                            StreamBuilder<List<QuoteModel>>(
                                stream: widget.database
                                    .quotesStream(), //print: flutter: Instance of '_MapStream<List<TodoDuration>, dynamic>'
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final List<QuoteModel> quotes = snapshot
                                        .data; //print('x: $entries'); //x: [Instance of 'TodoDuration', Instance of 'TodoDuration']
                                    return SettingSwitch(
                                        size: 20,
                                        icon: FontAwesomeIcons.user,
                                        title: 'Apply Your Own Quote',
                                        value: quotes.length > 0
                                            ? _quoteOn
                                            : false,
                                        onChanged: (val) {
                                          _quoteOn = val;
                                          onQuoteChanged(val, quoteNotifier);
                                        });
                                  } else if (snapshot.hasError) {
                                    return Container();
                                  }
                                  return Center(
                                      child: CircularProgressIndicator());
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  // Widget _mantraSwitch(List<MantraModel> mantras) {
  //   return SizedBox(
  //     width: 350,
  //     child: ListTile(
  //       title: Text('Apply Your Own Mantras'),
  //       trailing: Transform.scale(
  //         scale: 0.9,
  //         child: CupertinoSwitch(
  //           activeColor: switchActiveColor,
  //           trackColor: Colors.grey,
  //           value: mantras.length > 0 ? _mantraOn : false,
  //           onChanged: (val) {
  //             _mantraOn = val;
  //             onMantraChanged(val, mantraNotifier);
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _quoteSwitch(List<QuoteModel> quotes) {
  //   return SizedBox(
  //     width: 350,
  //     child: ListTile(
  //       title: Text('Apply Your Own Quotes'),
  //       trailing: Transform.scale(
  //         scale: 0.9,
  //         child: CupertinoSwitch(
  //           activeColor: switchActiveColor,
  //           trackColor: Colors.grey,
  //           value: quotes.length > 0 ? _quoteOn : false,
  //           onChanged: (val) {
  //             _quoteOn = val;
  //             onQuoteChanged(val, quoteNotifier);
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _topRow() {
    return Column(
      children: [
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios, size: 30),
              color: Colors.white,
            )
          ],
        ),
        MantraTopBar(
          title: 'Settings',
          subtitle: 'More options to customize your experience.',
        ),
      ],
    );
  }

  Future<void> _onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }

  Future<void> onMantraChanged(
      bool value, MantraNotifier mantraNotifier) async {
    //save settings
    mantraNotifier.setMantra(value);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('useMyMantras', value);
  }

  Future<void> onQuoteChanged(bool value, QuoteNotifier quoteNotifier) async {
    //save settings
    quoteNotifier.setQuote(value);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('useMyQuote', value);
  }
}
