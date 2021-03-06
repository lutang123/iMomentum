import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/my_container.dart';
import 'package:iMomentum/app/common_widgets/my_fab.dart';
import 'package:iMomentum/app/common_widgets/my_list_tile.dart';
import 'package:iMomentum/app/common_widgets/my_stack_screen.dart';
import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/setting_switch.dart';
import 'package:iMomentum/app/constants/constants_style.dart';
import 'package:iMomentum/app/constants/my_strings.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/quote_model.dart';
import 'package:iMomentum/app/services/firestore_service/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/home_drawer/mantra_top_title.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_quote_screen.dart';
import 'mantra_empty_or_error.dart';

class MyQuotes extends StatefulWidget {
  final Database database;

  const MyQuotes({Key key, this.database}) : super(key: key);
  @override
  _MyQuotesState createState() => _MyQuotesState();
}

class _MyQuotesState extends State<MyQuotes> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    ///for quote
    final quoteNotifier = Provider.of<QuoteNotifier>(context);
    bool _quoteOn = quoteNotifier.getQuote();

    return MyStackScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: CustomizedContainerNew(
            color: _darkTheme ? darkThemeSurface : lightThemeSurface,
            child:

                ///doesn't work when children is expended
                // CustomScrollView(
                //   slivers: [
                //     SliverToBoxAdapter(
                //       child:
                //
                Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  MantraTopTitle(
                    title: 'Quotes',
                    subtitle: 'A daily reminder for inspiration and growth.',
                    onPressed: _showTipDialog,
                    darkTheme: _darkTheme,
                  ),
                  StreamBuilder<List<QuoteModel>>(
                      stream: widget.database
                          .quotesStream(), //print: flutter: Instance of '_MapStream<List<TodoDuration>, dynamic>'
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final List<QuoteModel> quotes = snapshot
                              .data; //print('x: $entries'); //x: [Instance of 'TodoDuration', Instance of 'TodoDuration']
                          if (quotes.isNotEmpty) {
                            ///The following assertion was thrown during performLayout():
                            // RenderFlex children have non-zero flex but incoming height constraints are unbounded.
                            //
                            // When a column is in a parent that does not provide a finite height constraint, for example if it is in a vertical scrollable, it will try to shrink-wrap its children along the vertical axis. Setting a flex on a child (e.g. using Expanded) indicates that the child is to expand to fill the remaining space in the vertical direction.
                            // These two directives are mutually exclusive. If a parent is to shrink-wrap its child, the child cannot simultaneously expand to fit its parent.
                            //
                            // Consider setting mainAxisSize to MainAxisSize.min and using FlexFit.loose fits for the flexible children (using Flexible rather than Expanded). This will allow the flexible children to size themselves to less than the infinite remaining space they would otherwise be forced to take, and then will cause the RenderFlex to shrink-wrap the children rather than expanding to fit the maximum constraints provided by the parent.
                            return Expanded(
                              //need to wrap this column with an Expanded, because the whole thing is in another column
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                  children: <Widget>[
                                    SettingSwitchNoIcon(
                                      title: 'Apply Your Own Quotes',
                                      value:
                                          quotes.length > 0 ? _quoteOn : false,
                                      onChanged: (val) {
                                        _quoteOn = val;
                                        onQuoteChanged(val, quoteNotifier);
                                      },
                                    ),
                                    SizedBox(height: 15),
                                    Visibility(
                                      visible: _quoteVisible,
                                      child: Expanded(
                                        child: buildListView(
                                          widget.database,
                                          quotes,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return EmptyOrErrorMantra(
                              //already in Expanded
                              hideEmptyMessage: _hideEmptyMessage,
                              text1: Strings.textQuote1,
                              text2: Strings.textQuote2,
                            );
                          }
                        } else if (snapshot.hasError) {
                          return EmptyOrErrorMantra(
                            hideEmptyMessage: _hideEmptyMessage,
                            text1: Strings.textQuote1,
                            text2: Strings.streamErrorMessage,
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                ],
              ),
            ),
            //     )
            //   ],
            // ),
          ),
        ),
        floatingActionButton: Visibility(
          visible: _fabVisible,
          child: MyFAB(onPressed: () => _add(widget.database)),
        ),
      ),
    );
  }

  Future<void> _showTipDialog() async {
    await PlatformAlertDialog(
      title: 'Tips',
      content: Strings.tipsOnQuoteScreen,
      defaultActionText: 'OK.',
    ).show(context);
  }

  Future<void> onQuoteChanged(bool value, QuoteNotifier quoteNotifier) async {
    //save settings
    quoteNotifier.setQuote(value);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('useMyQuote', value);
  }

  ListView buildListView(Database database, List<QuoteModel> quotes) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return ListView.separated(
        itemCount: quotes.length + 2,
        separatorBuilder: (context, index) => Divider(
              height: 1,
              color: _darkTheme ? Colors.white70 : Colors.black38,
            ),
        itemBuilder: (context, index) {
          if (index == 0 || index == quotes.length + 1) {
            return Container();
          }
          return Slidable(
            key: UniqueKey(),
            closeOnScroll: true,
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: MantraList(
              text: quotes[index - 1].author == null ||
                      quotes[index - 1].author == ''
                  ? '"${quotes[index - 1].title}"'
                  : '"${quotes[index - 1].title} -- ${quotes[index - 1].author}"',
              onTap: () => _update(database, quotes[index - 1]),
            ),
            actions: <Widget>[
              IconSlideAction(
                caption: 'Edit',
                foregroundColor: Colors.blue,
                color: _darkTheme ? Colors.black12 : lightThemeNoPhotoColor,
                iconWidget: FaIcon(
                  EvaIcons.edit2Outline,
                  color: Colors.blue,
                ),
                onTap: () => _update(database, quotes[index - 1]),
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                foregroundColor: Colors.red,
                color: _darkTheme ? Colors.black12 : lightThemeNoPhotoColor,
                iconWidget: FaIcon(
                  EvaIcons.trash2Outline,
                  color: Colors.red,
                ),
                onTap: () => _delete(index, quotes[index - 1]),
              ),
            ],
          );
        });
  }

  bool _fabVisible = true;
  Future<void> _delete(int index, QuoteModel quote) async {
    setState(() {
      _fabVisible = false;
    });
    try {
      await widget.database.deleteQuote(quote);
      //PlatformException is from import 'package:flutter/services.dart';
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }

    ///if we add BuildContext in the function, i.e. the context is white color,
    /// flush bar will not show.
    Flushbar(
      isDismissible: true,
      mainButton: FlatButton(
        onPressed: () {
          setState(() {
            _fabVisible = false;
          });
          widget.database.setQuote(quote);

          ///can not have this
          // Navigator.pop(context);
        },
        child: FlushBarButtonChild(
          title: 'UNDO',
        ),
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(8),
      borderRadius: 15,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundGradient: KFlushBarGradient,
      duration: Duration(seconds: 4),
      icon: Icon(
        EvaIcons.trash2Outline,
        color: Colors.white,
      ),
      titleText: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(
          'Deleted: ',
          style: KFlushBarTitle,
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(left: 3.0),
        child: Text(
          quote.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: KFlushBarMessage,
        ),
      ),
    )..show(context).then((value) => setState(() => _fabVisible = true));
  }

  bool _hideEmptyMessage = true;
  bool _quoteVisible = true;

  Future<void> _add(Database database) async {
    setState(() {
      _hideEmptyMessage = false;
      _quoteVisible = false;
      _fabVisible = false;
    });

    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => AddQuoteScreen(
              database: database,
            ));

    setState(() {
      _hideEmptyMessage = true;
      _quoteVisible = true;
      _fabVisible = true;
    });
  }

  void _update(Database database, QuoteModel quote) async {
    setState(() {
      _quoteVisible = false;
      _fabVisible = _fabVisible;
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
      _fabVisible = true;
    });
  }
}
