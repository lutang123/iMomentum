import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/empty_content.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_fab.dart';
import 'package:iMomentum/app/common_widgets/my_list_tile.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/quote_model.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/iPomodoro/clock_title.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_quote.dart';

class MyQuotes extends StatefulWidget {
  final Database database;

  const MyQuotes({Key key, this.database}) : super(key: key);
  @override
  _MyQuotesState createState() => _MyQuotesState();
}

class _MyQuotesState extends State<MyQuotes> {
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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final randomNotifier = Provider.of<RandomNotifier>(context);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context);

    ///for quote
    final quoteNotifier = Provider.of<QuoteNotifier>(context);
    //if getImage is random, means random is on
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<List<QuoteModel>>(
                        stream: widget.database
                            .quotesStream(), //print: flutter: Instance of '_MapStream<List<TodoDuration>, dynamic>'
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final List<QuoteModel> quotes = snapshot
                                .data; //print('x: $entries'); //x: [Instance of 'TodoDuration', Instance of 'TodoDuration']
                            if (quotes.isNotEmpty) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: CustomizedContainerNew(
                                      color: _darkTheme
                                          ? darkSurfaceTodo
                                          : lightSurface,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                IconButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  icon: Icon(
                                                      Icons.arrow_back_ios,
                                                      size: 30),
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                            MantraTopBar(
                                              title: 'Quotes',
                                              subtitle:
                                                  'A daily reminder for inspiration and growth.',
                                            ),
//
                                            SizedBox(
                                              width: 350,
                                              child: ListTile(
                                                title: Text(
                                                    'Apply Your Own Quotes'),
                                                trailing: Transform.scale(
                                                  scale: 0.9,
                                                  child: CupertinoSwitch(
                                                    activeColor:
                                                        switchActiveColor,
                                                    trackColor: Colors.grey,
                                                    value: quotes.length > 0
                                                        ? _quoteOn
                                                        : false,
                                                    onChanged: (val) {
                                                      _quoteOn = val;
                                                      onQuoteChanged(
                                                          val, quoteNotifier);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: _quoteVisible,
                                              child: Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: buildListView(
                                                    widget.database,
                                                    quotes,
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
                            } else {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: CustomizedContainerNew(
                                      color: _darkTheme
                                          ? darkSurfaceTodo
                                          : lightSurface,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                IconButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  icon: Icon(
                                                      Icons.arrow_back_ios,
                                                      size: 30),
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                            MantraTopBar(
                                              title: 'Quotes',
                                              subtitle:
                                                  'A daily reminder for inspiration and growth.',
                                            ),
                                            SizedBox(height: 5),
                                            Spacer(),
//                                          Text(
//                                            'Center yourself with friendly reminders, reinforce new thought patterns, and bring attention to the values or principles that are most important to you.',
//                                            style: KEmptyContent,
//                                            textAlign: TextAlign.center,
//                                          ),
//                                        Text(
//                                                      'Get inspired by adding your personal mantras. ',
//                                                      style: KEmptyContent,
//                                                      textAlign:
//                                                          TextAlign.center,
//                                                    ),
//                                                    SizedBox(height: 5),
                                            //Text(
                                            //'Power up your day with your favorite quotes.',)
                                            Visibility(
                                              visible: _emptyMessageVisible,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text(
                                                  'By default, a daily quote will show on the bottom of home screen. You can add your own quotes to personalize your experience.',
                                                  style: KEmptyContent,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Spacer()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(snapshot.error.toString()),
                                  EmptyMessage(
                                    title: 'Something went wrong',
                                    message:
                                        'Can\'t load items right now, please try again later',
                                  )
                                ],
                              ),
                            );
                          }
                          return Center(child: CircularProgressIndicator());
                        }),
                  ),
                ],
              ),
            ),
            floatingActionButton: MyFAB(
                onPressed: () => _add(widget.database),
                child: Icon(Icons.add, size: 30, color: Colors.white)),
          ),
        )
      ],
    );
  }

  Future<void> onQuoteChanged(bool value, QuoteNotifier quoteNotifier) async {
    //save settings
    quoteNotifier.setQuote(value);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('useMyQuote', value);
  }

  ListView buildListView(Database database, List<QuoteModel> quotes) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return ListView.separated(
        itemCount: quotes.length + 2,
        separatorBuilder: (context, index) => Divider(
              indent: 15,
              endIndent: 15,
              height: 0.5,
              color: _darkTheme ? Colors.white70 : Colors.black38,
            ),
//        shrinkWrap: true,
//        itemCount: anyList.length, //The getter 'length' was called on null.
        itemBuilder: (context, index) {
          //or index == 0 or index == the last, we return an empty container
          if (index == 0 || index == quotes.length + 1) {
            return Container();
          }
          //itemBuilder(context, items[index - 1]);
          return Slidable(
            key: UniqueKey(),
            closeOnScroll: true,
            actionPane: SlidableDrawerActionPane(),
            dismissal: SlidableDismissal(
              child: SlidableDrawerDismissal(),
              onDismissed: (actionType) {
                _delete(context, index, quotes[index - 1]);
              },
            ),
            actionExtentRatio: 0.25,
            child: QuoteListTile(
              quote: quotes[index - 1],
              onTap: () => _update(database, quotes[index - 1]),
            ),
            actions: <Widget>[
              IconSlideAction(
                caption: 'Edit',
                color: Colors.black12,
                iconWidget: FaIcon(
                  FontAwesomeIcons.edit,
                  color: Colors.white,
                ),
                onTap: () => _update(database, quotes[index - 1]),
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: Colors.black12,
                iconWidget: FaIcon(
                  FontAwesomeIcons.trashAlt,
                  color: Colors.white,
                ),
                onTap: () => _delete(context, index, quotes[index - 1]),
              ),
//              IconSlideAction(
//                caption: 'Select',
//                color: Colors.black12,
//                iconWidget: FaIcon(
//                  FontAwesomeIcons.check,
//                  color: Colors.white,
//                ),
////                onTap: () => _delete(d, index, quotes[index - 1]),
//              ),
            ],
          );
        });
  }

  Future<void> _delete(
      BuildContext context, int index, QuoteModel quote) async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    try {
      await widget.database.deleteQuote(quote);
      //PlatformException is from import 'package:flutter/services.dart';
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }

    Flushbar(
      isDismissible: true,
      mainButton: FlatButton(
        onPressed: () {
          widget.database.setQuote(quote);
        },
        child: Text(
          "UNDO",
          style: TextStyle(color: _darkTheme ? Colors.white : Colors.black87),
        ),
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(left: 10),
      borderRadius: 10,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundGradient: _darkTheme
          ? LinearGradient(colors: [
              Color(0xF0888888).withOpacity(0.85),
              Colors.black54,
            ])
          : LinearGradient(
              colors: [Color(0xF0888888).withOpacity(0.85), lightSurface]),
      duration: Duration(seconds: 4),
      titleText: Text(
        'Deleted',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            color: _darkTheme ? Colors.white : Colors.black87,
            fontFamily: "ShadowsIntoLightTwo"),
      ),
      messageText: Text(
        quote.title,
        style: TextStyle(
            fontSize: 12.0,
            color: _darkTheme ? Colors.white : Colors.black87,
            fontFamily: "ShadowsIntoLightTwo"),
      ),
    )..show(context);
  }

  bool _emptyMessageVisible = true;
  bool _quoteVisible = true;

  Future<void> _add(Database database) async {
    setState(() {
      _emptyMessageVisible = false;
      _quoteVisible = false;
    });

    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => AddQuoteScreen(
              database: database,
            ));

    setState(() {
      _emptyMessageVisible = true;
      _quoteVisible = true;
    });
  }

  void _update(Database database, QuoteModel quote) async {
    setState(() {
      _quoteVisible = false;
    });
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => AddQuoteScreen(
              database: database,
              quote: quote,
            ));

    setState(() {
      _quoteVisible = true;
    });
  }

  Container deleteContainer() {
    return Container(
      color: Colors.black38,
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FaIcon(FontAwesomeIcons.trashAlt),
                Text(
                  'Delete',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
