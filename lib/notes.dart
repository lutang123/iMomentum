///notes on sliver app bar
//  Widget _buildSearchAppBar() {
//    final themeNotifier = Provider.of<ThemeNotifier>(context);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//    return SliverPadding(
//      padding: const EdgeInsets.only(top: 8.0),
//      sliver: SliverAppBar(
//        backgroundColor: _darkTheme ? Color(0xf01b262c) : Colors.grey[50],
//        automaticallyImplyLeading: false,
////      stretch: false,
//        floating: true,
//        title: Container(
//            width: 300,
//            decoration: BoxDecoration(
////              color: _darkTheme ? darkSurfaceTodo : lightSurface,
//              borderRadius: BorderRadius.all(Radius.circular(10.0)),
//              border: Border.all(
//                  width: 1,
//                  color: _darkTheme ? Colors.white54 : Colors.black38),
//            ),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                FlatButton(
//                  child: Text(
//                    'Search photos',
//                    style: TextStyle(
//                      fontSize: 14,
//                      color: _darkTheme ? darkHint : lightHint,
//                    ),
//                  ),
//                  onPressed: () => showSearch(
//                    context: context,
//                    delegate: SearchPhotos(),
//                  ),
//                ),
//                IconButton(
//                  icon: Icon(
//                    Icons.search,
//                  ),
//                  color: _darkTheme ? darkHint : lightHint,
//                  onPressed: () => showSearch(
//                    context: context,
//                    delegate: SearchPhotos(),
//                  ),
//                ),
//              ],
//            )),
//      ),
//    );
//  }

///HomeScreen
///
///speech-to-text:
//  //for speech-to-text
//  String _currentLocaleId = "";
//  void _setCurrentLocale(SpeechToTextProvider speechProvider) {
//    if (speechProvider.isAvailable) {
//      _currentLocaleId = speechProvider.systemLocale.localeId;
//    }
//  }
//
//  Widget speechButton() {
//    //for speech-to-text:
//    var speechProvider = Provider.of<SpeechToTextProvider>(context);
//    _setCurrentLocale(speechProvider);
//    return Visibility(
//      visible: _speechButtonVisible,
//      child: Column(
//        children: [
//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: [
//              speechProvider.isListening
//                  ? Text(
//                      "I'm listening...",
//                      style: TextStyle(fontStyle: FontStyle.italic),
//                    )
//                  : Text(
//                      'Not listening',
//                      style: TextStyle(fontStyle: FontStyle.italic),
//                    ),
//            ],
//          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: [
//              FlatButton(
//                child: Text('Stop'),
//                onPressed: speechProvider.isListening
//                    ? () => speechProvider.stop()
//                    : null,
//              ),
//              FlatButton(
//                child: Text('Cancel'),
//                onPressed: speechProvider.isListening
//                    ? () {
//                        speechProvider.cancel();
//                        setState(() {
//                          _speechButtonVisible = false;
//                        });
//                      }
//                    : null,
//              ),
//              FlatButton(
//                child: Text('Done'),
//                onPressed: () {
//                  setState(() {
//                    _speechButtonVisible = false;
//                    // ignore: unnecessary_statements
//                    _onSubmitted;
//                  });
//                },
//              )
//            ],
//          ),
//          speechProvider.hasError
//              ? Text(speechProvider.lastError.errorMsg)
//              : Container(),
//        ],
//      ),
//    );
//  }
//
//  bool _textFieldVisible = true;
//
//  Widget homeTextField() {
//    //for speech-to-text:
//    var speechProvider = Provider.of<SpeechToTextProvider>(context);
//    _setCurrentLocale(speechProvider);
//    return Container(
//      width: 350,
//      child: Row(
//        children: [
////          Opacity(
////            opacity: 0.0,
////            child: IconButton(
////              icon: Icon(Icons.mic_none),
////              onPressed: null,
////            ),
////          ),
//          Visibility(
//            visible: _textFieldVisible,
//            child: Expanded(
//              child: TextField(
////                onChanged: (val) {
////                  speechProvider.hasResults
////                      ? val = speechProvider.lastResult.recognizedWords
////                      : val = '';
////
////                  ///never printed
////                  print(
////                      'textEditingController.text: ${textEditingController.text}');
////                  setState(() {
////                    textEditingController.text = val;
////                  });
////                },
////                controller: textEditingController,
//                style: GoogleFonts.varelaRound(
//                    fontSize: 25.0, color: Colors.white),
//                textAlign: TextAlign.center,
//                onSubmitted: _onSubmitted,
//                cursorColor: Colors.white,
//                maxLength: 100,
//
//                ///no save button, so we can not do multiline
////        keyboardType: TextInputType.multiline,
////        maxLines: null,
//                decoration: InputDecoration(
//                  focusedBorder: UnderlineInputBorder(
//                      borderSide: BorderSide(color: Colors.white)),
//                  enabledBorder: UnderlineInputBorder(
//                      borderSide: BorderSide(color: Colors.white)),
//                ),
//              ),
//            ),
//          ),
//
////          Visibility(
////            visible: _speechButtonVisible,
////            child: Expanded(
////              child: speechProvider.hasResults
////                  ? Text(
////                      speechProvider.lastResult.recognizedWords,
////                      style: GoogleFonts.varelaRound(
////                          fontSize: 25.0, color: Colors.white),
////                      textAlign: TextAlign.center,
////                    )
////                  : Container(),
////            ),
////          ),
//
////          RoundSmallIconButton(
////            icon:
////                speechProvider.isNotAvailable ? Icons.mic_off : Icons.mic_none,
////            onPressed: () {
////              if (_isAvailable && !_isListening)
////                _speechRecognition
////                    .listen(locale: "en_US")
////                    .then((result) => print('$result'));
////            },
////
////              _speechRecognition
////                  .setRecognitionResultHandler((String result) => setState(() {
////                resultText = result;
////                controller.text = resultText;
////              }));
////
//////            _onPressMic,
////          )
//        ],
//      ),
//    );
//  }
//
//  void _showNoSpeechMessage() {
//    Flushbar(
//      isDismissible: true,
//      margin: const EdgeInsets.all(20),
//      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
//      borderRadius: 50,
//      flushbarPosition: FlushbarPosition.BOTTOM,
//      flushbarStyle: FlushbarStyle.FLOATING,
////      reverseAnimationCurve: Curves.decelerate,
////      forwardAnimationCurve: Curves.elasticOut,
//      backgroundGradient: LinearGradient(colors: [
//        Color(0xF0a2de96).withOpacity(0.85),
//        Color(0xF03ca59d).withOpacity(0.85)
//      ]),
//      duration: Duration(seconds: 2),
//      icon: Icon(
//        Icons.mic_off,
//        color: Colors.white,
//      ),
//      titleText: Text(
//        'Speech Recognition is not available on this device.',
//        style: TextStyle(
//            fontWeight: FontWeight.bold,
//            fontSize: 17.0,
//            color: Colors.white,
//            fontFamily: "ShadowsIntoLightTwo"),
//      ),
//      messageText: Text(
//        'please check your setting, and in the mean time you can add task by typing.',
//        style: TextStyle(
//            fontSize: 12.0,
//            color: Colors.white,
//            fontFamily: "ShadowsIntoLightTwo"),
//      ),
//    )..show(context);
//  }
//
//  bool _speechButtonVisible = false;
//
//  void _showText() {
//    //must add listen: false too
//    var speechProvider =
//        Provider.of<SpeechToTextProvider>(context, listen: false);
//    _setCurrentLocale(speechProvider);
//
////    print('mounted: $mounted'); //true
//    print(
//        'textEditingController.text: ${textEditingController.text}'); //it didn't print anything
//    if (!mounted) return;
//    speechProvider.hasResults
//        ? setState(() {
//            String result = speechProvider.lastResult.recognizedWords;
//            print('result: $result');
//            print('textEditingController.text: ${textEditingController.text}');
//            textEditingController.value = textEditingController.value.copyWith(
//              text: result,
//              selection: TextSelection(
//                  baseOffset: result.length, extentOffset: result.length),
//              composing: TextRange.empty,
//            );
//          })
//
////    setState(() {
////            textEditingController.text =
////                speechProvider.lastResult.recognizedWords;
////          })
//        : setState(() {
//            textEditingController.text = '';
//          });
//  }

//  void _onPressMic() {
//    //on any button, this must be listen: false
//    var speechProvider =
//        Provider.of<SpeechToTextProvider>(context, listen: false);
//    _setCurrentLocale(speechProvider);
//
//    if (speechProvider.isNotAvailable) {
//      _showNoSpeechMessage();
//    }
////    else if (!speechProvider.isAvailable || speechProvider.isListening) {
////      return null;
////    }
//    else {
//      speechProvider.listen(partialResults: true);
//
//      setState(() {
//        _speechButtonVisible = !_speechButtonVisible;
//      });
//      _showText();
//    }
//  }
///bt can't make it to TextFiled
//
///https://stackoverflow.com/questions/58545579/implement-speech-to-text-in-textfields-flutter
// Platform messages are asynchronous, so we initialize in an async method.

///https://stackoverflow.com/questions/56752042/search-with-text-to-speech-works-only-either-with-speech-or-textfield

///notes on animated opacity:
///https://flutter.dev/docs/cookbook/animation/opacity-animation;
///https://stackoverflow.com/questions/57776800/flutter-animation-text-fade-transition
//  double opacity = 1.0;
//
//  changeOpacity() {
//    Future.delayed(Duration(seconds: 5), () {
//      setState(() {
//        opacity = opacity == 0.0 ? 1.0 : 0.0;
//      });
//    });
//  }
//
//  Widget getFirstGreeting() {
//    final User user = Provider.of<User>(context, listen: false);
//    return Stack(
//      alignment: Alignment.center,
//      children: [
//        AnimatedOpacity(
//          opacity: opacity,
//          duration: Duration(seconds: 2),
//          child: AutoSizeText(
//            user.displayName == null
//                ? '${FirstGreetings().showGreetings()}'
//                : '${FirstGreetings().showGreetings()}, ${user.displayName.substring(0, user.displayName.indexOf(' '))}',
//            maxLines: 2,
//            maxFontSize: 35,
//            minFontSize: 30,
//            textAlign: TextAlign.center,
//            style: TextStyle(
//                fontSize: 35.0,
//                color: Colors.white,
//                fontWeight: FontWeight.bold),
//          ),
//        ),
//        AnimatedOpacity(
//          opacity: opacity == 1 ? 0 : 1,
//          duration: Duration(seconds: 2),
//          child: getSecondGreetings,
//        ),
//      ],
//    );
//  }

///notes on trying update photo with random API:
//  void getRandomOn() async {
//    final prefs = await SharedPreferences.getInstance();
//  }

//  UnsplashImage image;
//
//  Future<void> fetchImage() async {
//    image = await UnsplashImageProvider.loadImagesRandom();
//    setState(() {
//      print('image: $image');
//      randomUrl = image.getFullUrl();
//      print('newUrl: $randomUrl');
//    });
//  }

// https://source.unsplash.com/daily?nature
//'https://source.unsplash.com/random?nature'
//https://source.unsplash.com/random?nature/$counter

//  String randomUrl;
//
////  int counter = 0;
//  void _onDoubleTap() {
//    setState(() {
//      fetchImage();
//    });
//  }
//
//  void _onLongPress() {
//    final database = Provider.of<Database>(context, listen: false);
//
//    final route = SharedAxisPageRoute(
//        page: ImagePage(image.getId(), image.getRegularUrl(), database),
//        transitionType: SharedAxisTransitionType.scaled);
//    Navigator.of(context, rootNavigator: true).push(route);
//  }

/// TodoScreen
///
///note on setting reminder on this page:
// void _showAddDialog(Todo todo) async {
//   setState(() {
//     _addButtonVisible = false;
//     _listVisible = false;
//   });
//   await showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return StatefulBuilder(builder: (context, setState) {
//         return AlertDialog(
//           contentPadding: EdgeInsets.only(top: 10.0),
//           backgroundColor: CustomColors.pageBackgroundColor,
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(20.0))),
//           title: Column(
//             children: <Widget>[
//               Text("Add Reminder",
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.white,
//                   )),
//               SizedBox(height: 15),
//               Text(
//                 'Remind me for this task at: .',
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.white60,
//                     fontStyle: FontStyle.italic),
// //                  style: Theme.of(context).textTheme.subtitle2,
//               )
//             ],
//           ),
//           content: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 _buildReminderDate(),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ///Todo: change color when typing
//                       FlatButton(
//                           child: Text(
//                             'Cancel',
//                             style: GoogleFonts.varelaRound(
//                               fontSize: 18,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           // shape: _isFolderNameEmpty
//                           //     ? RoundedRectangleBorder(
//                           //     borderRadius:
//                           //     BorderRadius.circular(68.0),
//                           //     side: BorderSide(
//                           //         color: Colors.white70,
//                           //         width: 2.0))
//                           //     : null,
//                           onPressed: () {
//                             setState(() {
//                               _addButtonVisible = true;
//                               _listVisible = true;
//                             });
//                             Navigator.of(context).pop();
//                           }),
//                       FlatButton(
//                         child: Text(
//                           'Save',
//                           style: GoogleFonts.varelaRound(
//                             fontSize: 18,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         // shape: _isFolderNameEmpty
//                         //     ? null
//                         //     : RoundedRectangleBorder(
//                         //     borderRadius:
//                         //     BorderRadius.circular(68.0),
//                         //     side: BorderSide(
//                         //         color: Colors.white70,
//                         //         width: 2.0)),
//                         onPressed: () => _setReminder(context),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
// //            actions: <Widget>[],
//         );
//       });
//     },
//   );
// }
//
// Widget _buildReminderDate() {
//   return DateTimePicker(
//     selectedDate: _startDate,
//     selectedTime: _startTime,
//     onSelectedDate: (date) => _onSelectedDate(date),
//     onSelectedTime: (time) => _onSelectedTime(time),
//   );
// }
//
// _onSelectedDate(date) {
//   print('date: $date');
//   setState(() => _startDate = date);
// }
//
// _onSelectedTime(time) {
//   print('time: $time'); //time: TimeOfDay(01:00)
//   setState(() => _startTime = time);
// }
//
// void _setReminder(BuildContext context) {
//   setState(() {
//     _addButtonVisible = true;
//     _listVisible = true;
//   });
//   Navigator.of(context).pop();
//   _showDailyAtTime();
// }
//
// Future<void> _showDailyAtTime() async {
//   String _toTwoDigitString(int value) {
//     return value.toString().padLeft(2, '0');
//   }
//
//   /// for local notification
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   var time = Time(1, 13, 0);
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'repeatDailyAtTime channel id',
//       'repeatDailyAtTime channel name',
//       'repeatDailyAtTime description');
//   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//
//   var platformChannelSpecifics = NotificationDetails(
//       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.showDailyAtTime(
//       0, //id
//       'show daily title', //title
//       //body
//       'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
//       //notificationTime
//       time,
//       //NotificationDetails notificationDetails
//       platformChannelSpecifics);
// }
//

///Auto animate note (difficult to use since I have delegate list and staggered grid
///add auto animation
// final options = LiveOptions(
//   // Start animation after (default zero)
//   delay: Duration(seconds: 1),
//
//   // Show each item through (default 250)
//   showItemInterval: Duration(milliseconds: 500),
//
//   // Animation duration (default 250)
//   showItemDuration: Duration(seconds: 1),
//
//   // Animations starts at 0.05 visible
//   // item fraction in sight (default 0.025)
//   visibleFraction: 0.05,
//
//   // Repeat the animation of the appearance
//   // when scrolling in the opposite direction (default false)
//   // To get the effect as in a showcase for ListView, set true
//   reAnimateOnVisibility: false,
// );
//
// // Build animated item (helper for all examples)
// Widget buildAnimatedItem(
//     BuildContext context,
//     Database database,
//     List<Todo> todos,
//     List<Todo> anyList,
//     int index,
//     Animation<double> animation,
//     ) =>
//     // For example wrap with fade transition
// FadeTransition(
//   opacity: Tween<double>(
//     begin: 0,
//     end: 1,
//   ).animate(animation),
//   // And slide transition
//   child: SlideTransition(
//     position: Tween<Offset>(
//       begin: Offset(0, -0.1),
//       end: Offset.zero,
//     ).animate(animation),
//     // Paste you Widget
//     child: slidableListItem(database, todos, anyList, index + 1),
//   ),
// );
//
// // final Duration listShowItemDuration = Duration(milliseconds: 250);
// Widget _buildLiveSliverListView(
//     Database database, List<Todo> todos, List<Todo> anyList) {
//   return LiveSliverList.options(
//     options: options,
//     // And attach root sliver scrollController to widgets
//     controller: _hideButtonController,
//
//     // showItemDuration: listShowItemDuration,
//     itemCount: listItemCount,
//     itemBuilder: buildAnimatedItem,
//   );
// }

///layout builder note
//  LayoutBuilder(
//    builder: (context, constraint) {
//      return SingleChildScrollView(
//        child: ConstrainedBox(
//          constraints: BoxConstraints(minHeight: constraint.maxHeight),
//          child: IntrinsicHeight(
//            child: Column(
//              children: <Widget>[
//                Text("Header"),
//                Expanded(
//                  child: Container(
//                    color: Colors.red,
//                  ),
//                ),
//                Text("Footer"),
//              ],
//            ),
//          ),
//        ),
//      );
//    },
//  )
//
//  Widget pieChartContent() {
//    final themeNotifier = Provider.of<ThemeNotifier>(context);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//    return LayoutBuilder(builder: (context, constraint) {
//      return SingleChildScrollView(
//        child: ConstrainedBox(
//          constraints: BoxConstraints(minHeight: constraint.maxHeight),
//          child: IntrinsicHeight(
//            child: Column(
//              children: [
//                Expanded(
//                  //this is within a column
//                  child:
////      SingleChildScrollView(
////        child:
//                      CustomizedContainerNew(
//                    color: _darkTheme ? darkSurfaceTodo : lightSurface,
//                    child: Padding(
//                      padding: const EdgeInsets.all(15.0),
//                      child: Column(
//                        children: <Widget>[
//                          Text(
//                            _dataMapSelected.isEmpty
//                                ? 'Focused Time on Today'
//                                : 'Focused Time on ${Format.date(_calendarControllerNew.selectedDay)}',
//                            style: Theme.of(context).textTheme.headline5,
//                            textAlign: TextAlign.center,
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.only(top: 8.0),
//                            child: Text(
//                              _dataMapSelected.isEmpty
//                                  ? 'Total ${Format.minutes(_todayDuration)}'
//                                  : 'Total ${Format.minutes(_selectedDuration)}',
//                              style: Theme.of(context).textTheme.headline6,
//                              textAlign: TextAlign.center,
//                            ),
//                          ),
//                          SizedBox(height: 10.0),
////              Expanded(  //why adding Expanded here is wrong, because we have SingleChildScrollView
////                child:
//                          _dataMapSelected.isEmpty
//                              ? NewPieChart(dataMap: _dataMapToday)
//                              : NewPieChart(dataMap: _dataMapSelected),
//
////              ),
//                          Spacer()
//                        ],
//                      ),
//                    ),
//                  ),
////      ),
//                ),
//              ],
//            ),
//          ),
//        ),
//      );
//    });
//  }
///original without sliver
//  Widget buildListView(
//      Database database, List<Todo> todos, List<Todo> anyList) {
//    final themeNotifier = Provider.of<ThemeNotifier>(context);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//    return ListView.separated(
//        controller: _hideButtonController,
//        itemCount: anyList.length + 2,
//        separatorBuilder: (context, index) => Divider(
//              indent: 75,
//              endIndent: 75,
//              height: 0.5,
//              color: _darkTheme ? Colors.white70 : Colors.black38,
//            ),
////        shrinkWrap: true,
//        itemBuilder: (context, index) {
//          if (index == 0 || index == anyList.length + 1) {
//            return Container();
//          }
//          return slidableListItem(database, todos, anyList, index);
//        });
//  }

///notes for trying Reorderable: it's only working for selectedList, and the order is temporary
//
//  Widget buildListView(
//      Database database, List<Todo> todos, List<Todo> anyList) {
//    void _onReorder(int oldIndex, int newIndex) {
//      setState(
//        () {
//          if (newIndex > oldIndex) {
//            newIndex -= 1;
//          }
//          final Todo todo = anyList.removeAt(oldIndex);
//          anyList.insert(newIndex, todo);
//        },
//      );
//    }
//
//    return ReorderableListView(
//        //replaced ListView.builder
//        onReorder: _onReorder,
//        scrollDirection: Axis.vertical,
////        shrinkWrap: true,
////        itemCount: anyList.length, //The getter 'length' was called on null.
//        children: List.generate(
//          anyList.length,
//          (index) {
//            return DismissibleListItem(
//              //this one take a TodoListTile
//              index: index,
//              key: Key('$index'),
//              listItems: anyList,
//              database: database,
//              delete: () => _delete(context, anyList[index]),
//              onTap: () => _onTap(database, todos, anyList[index]),
//              onChangedCheckbox: (newValue) =>
//                  _onChangedCheckbox(newValue, context, anyList[index]),
//            );
//          },
//        ));
//  }

///tried to move stream builder down but has error because of TabBarView
///

///AddTodoScreen
///
///https://medium.com/@gshubham030/custom-dropdown-menu-in-flutter-7d8d1e026c6b

/// notes on adding project
//  List _projects = [
//    'Project 1', //0, default
//    'Project 2', //1
//    'Others' //2
//  ];

//  List<DropdownMenuItem<String>> _dropDownMenuItemsProjects;
//  String _currentProject;

//  void changedDropDownItemProjects(String selectedCity) {
////    print("Selected city $selectedCity, we are going to refresh the UI");
//    setState(() {
//      _currentProject = selectedCity;
//    });
////    _dropDownFocusNode.unfocus();
////    FocusScope.of(context).requestFocus(_dropDownFocusNode);
//  }
//
//  // here we are creating the list needed for the DropDownButton
//  List<DropdownMenuItem<String>> getDropDownMenuItemsProjects() {
//    List<DropdownMenuItem<String>> items = List();
//    for (String city in _projects) {
//      // here we are creating the drop down menu items, you can customize the item right here
//      // but I'll just use a simple text for this
//      items.add(DropdownMenuItem(value: city, child: Text(city)));
//    }
//    return items;
//  }

///note for project
//              _currentCategory == 'Focus'
//                  ? Container(
//                      width: 350,
//                      child: Padding(
//                        padding:
//                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Text(
//                              'Project name',
//                              style: TextStyle(
//                                  fontSize: 13,
//                                  color: _darkTheme
//                                      ? Colors.white54
//                                      : Colors.black38),
//                            ),
//                            DropdownButton(
//                              value: _currentProject,
//                              items: _dropDownMenuItemsProjects,
//                              onChanged: changedDropDownItemProjects,
//                              dropdownColor: darkAdd,
////                        focusNode: _dropDownFocusNode,
//                            ),
//                          ],
//                        ),
//
////                  DropdownButtonFormField(
////                    isDense: true,
////                    icon: Icon(Icons.arrow_drop_down_circle),
////                    iconSize: 22.0,
////                    iconEnabledColor: Theme.of(context).primaryColor,
////                    items: _priorities.map((String priority) {
////                      return DropdownMenuItem(
////                        value: priority,
////                        child: Text(
////                          priority,
////                          style: TextStyle(
////                            fontSize: 18.0,
////                          ),
////                        ),
////                      );
////                    }).toList(),
////                    style: TextStyle(
////                        color: _darkTheme ? Colors.white70 : Color(0xF01b262c),
////                        fontSize: 14.0),
////                    decoration: InputDecoration(
////                      hintText: 'Category',
////                      hintStyle: TextStyle(
////                          fontSize: 13,
////                          color: _darkTheme ? Colors.white54 : Colors.black38),
////                      focusedBorder: UnderlineInputBorder(
////                          borderSide: BorderSide(
////                              color: _darkTheme ? Colors.white : lightButton)),
////                      enabledBorder: UnderlineInputBorder(
////                          borderSide: BorderSide(
////                              color: _darkTheme ? Colors.white : lightButton)),
////                    ),
////                    onChanged: (value) {
////                      setState(() {
////                        _priority = value;
////                      });
////                    },
////                    value: _priority,
////                  ),
//                      ),
//                    )
//                  : Container(),

///note folder container
///
///
/// Note Card UI in List
//class NotesFolderContainerButton extends StatelessWidget {
//  final Function onTap;
//
//  NotesFolderContainerButton({this.onTap});
//
//  @override
//  Widget build(BuildContext context) {
//    return Center(
//      child: InkWell(
//        onTap: onTap,
//        child: Container(
//          height: 200,
//          width: 160,
//          decoration: BoxDecoration(
//            image: DecorationImage(
//              image: AssetImage(
//                'assets/images/images_notes/ic_4288585374.png',
//              ),
//              fit: BoxFit.cover,
////          colorFilter: ColorFilter.mode(
////              Colors.transparent.withOpacity(0.8), BlendMode.dstATop),
//            ),
//          ),
////      constraints: BoxConstraints.expand(),
//          child: Center(
//            child: Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Row(
//                children: <Widget>[
//                  Icon(Icons.add),
//                  SizedBox(width: 3),
//                  Text(
//                    'Add Folder',
//                    style: TextStyle(
//                        fontSize: 22,
//                        color: Colors.white,
//                        fontFamily: 'OpenSans'),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}
//        Center(
//          child: Container(
//            height: 200,
//            width: 160,
//            decoration: BoxDecoration(
//              image: DecorationImage(
//                image: AssetImage(
//                  'assets/images/images_notes/ic_${folder.colorCode}.png',
//                ),
//                fit: BoxFit.cover,
//                colorFilter: ColorFilter.mode(
//                    Colors.transparent.withOpacity(0.5), BlendMode.dstATop),
//              ),
//            ),
//            child: Center(
//              child: Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  folder.title ?? '',
//                  maxLines: 3,
//                  style: TextStyle(
//                      fontSize: 22,
//                      color: Colors.white,
//                      fontFamily: 'OpenSans'),
//                ),
//              ),
//            ),
//          ),
//        )

///FolderScreen
///

/// spent a lot of time on Sliver App Bar but the space is too big or too small,
/// later learnt that I should use SliverToBoxAdapter
//  Widget _buildSearchAppBar() {
//    final themeNotifier = Provider.of<ThemeNotifier>(context);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//    return SliverPadding(
//      padding: const EdgeInsets.only(top: 0.0),
//      sliver: SliverAppBar(
//        backgroundColor: Colors.transparent,
////        backgroundColor: _darkTheme ? Colors.black38 : lightSurface,
//        titleSpacing: 0,
//        elevation: 0,
//        centerTitle: true,
//        snap: true,
//        toolbarHeight: 100,
//        automaticallyImplyLeading: false,
//        stretch: false,
//        floating: true,
////        bottom: PreferredSize(
////          // Add this code
////          preferredSize: Size.fromHeight(0.0), // Add this code
////          child: Text(''), // Add this code
////        ), // Add this code
////          flexibleSpace: /title
//        title: Column(
//          children: [
////              Container(
//////                height: 80,
////                child: Row(
////                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
////                  children: <Widget>[
////                    Padding(
////                      padding: const EdgeInsets.only(left: 25.0),
////                      child: Text('Folders',
////                          style: Theme.of(context).textTheme.headline4),
////                    ),
////                    FlatButton(
////                        onPressed: () => _showEditDialog(context),
////                        child: Text('Edit'))
////                  ],
////                ),
////              ),
//            Padding(
//              padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 0),
//              child: Container(
//                  decoration: BoxDecoration(
//                      color: _darkTheme ? Colors.black38 : lightSurface,
//                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                  child: Row(
//                    children: <Widget>[
//                      FlatButton.icon(
//                          onPressed: null,
//                          icon: Icon(
//                            Icons.search,
//                            color: Colors.white70,
//                          ),
//                          label: Text(
//                            'Search your notes',
//                            style: TextStyle(color: Colors.white70),
//                          ))
//                    ],
//                  )),
//            ),
//          ],
//        ),
//      ),
//    );
//  }

///the original StaggeredGridView.countBuilder
//  Widget getDefaultFolderList(Database database) {
//    List defaultFolders = [
//      Folder(id: 0.toString(), title: 'All Notes', colorCode: '4278238420'),
//      Folder(id: 1.toString(), title: 'Notes', colorCode: '4278228616'),
//    ];
//
//    return StaggeredGridView.countBuilder(
//        controller: _hideButtonController,
//        staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
//        mainAxisSpacing: 8.0,
//        crossAxisSpacing: 8.0,
//        physics: BouncingScrollPhysics(),
//        crossAxisCount: 4,
//        itemCount: defaultFolders.length,
//        shrinkWrap: true,
//        itemBuilder: (BuildContext context, int index) {
//          final folder = defaultFolders[index];
//          return Slidable(
////            controller: slidableController,
//            key: UniqueKey(),
//            closeOnScroll: true,
//            actionPane: SlidableDrawerActionPane(),
//            dismissal: SlidableDismissal(
//              child: SlidableDrawerDismissal(),
//              onDismissed: (actionType) {
//                _delete(context, folder);
//              },
//            ),
//            actionExtentRatio: 0.25,
//            child: OpenContainer(
//              useRootNavigator: true,
//              transitionType: _transitionType,
//              closedBuilder: (BuildContext _, VoidCallback openContainer) {
//                return Stack(
//                  alignment: Alignment.topRight,
//                  children: <Widget>[
//                    NotesFolderContainer(
//                      folder: folder,
////                onTap: () => _gotoNotesInFolder(database,
////                    folder),
//                    ),
//                    IconButton(
//                      icon: FaIcon(
//                        FontAwesomeIcons.trashAlt,
//                        size: 20,
//                        color: Colors.white,
//                      ),
//                      onPressed: () => _delete(context, folder),
//                    )
//                  ],
//                );
//              },
//              closedElevation: 0,
//              openElevation: 0,
//              closedColor: Colors.transparent,
//              closedShape: const RoundedRectangleBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(0))),
//              openColor: Colors.transparent,
//              openBuilder: (BuildContext context, VoidCallback _) {
//                return NotesInFolder(database: database, folder: folder);
//              },
//            ),
//
////            NotesFolderContainer(
////                folder: folder,
////                onTap: () => _gotoNotesInFolder(database,
////                    folder)), //on tap: NoteFolderDetail(note: folder);
//            actions: <Widget>[],
//            secondaryActions: <Widget>[
//              IconSlideAction(
//                caption: 'Delete',
//                color: Colors.black12,
//                iconWidget: FaIcon(
//                  FontAwesomeIcons.trashAlt,
//                  color: Colors.white,
//                ),
////                icon: Icons.delete,
//                onTap: () => _delete(context, folder),
//              ),
//            ],
//          );
//        });
//  }

//  Widget getFolderList(Database database, List<Folder> folders) {
//    List defaultFolders = [
//      Folder(id: 0.toString(), title: 'All Notes', colorCode: '4278238420'),
//      Folder(id: 1.toString(), title: 'Notes', colorCode: '4278228616'),
//    ];
//
//    List finalFolderList = defaultFolders..addAll(folders);
//
//    return StaggeredGridView.countBuilder(
//        controller: _hideButtonController,
//        staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
//        mainAxisSpacing: 15.0,
//        crossAxisSpacing: 15.0,
//        physics: BouncingScrollPhysics(),
//        crossAxisCount: 4,
//        itemCount: finalFolderList.length,
//        shrinkWrap: true,
//        itemBuilder: (BuildContext context, int index) {
//          final folder = finalFolderList[index];
//          return Slidable(
////            controller: slidableController,
//            key: UniqueKey(),
//            closeOnScroll: true,
//            actionPane: SlidableDrawerActionPane(),
//            dismissal: SlidableDismissal(
//              child: SlidableDrawerDismissal(),
//              onDismissed: (actionType) {
//                _delete(context, folder);
//              },
//            ),
//            actionExtentRatio: 0.25,
//            child: OpenContainer(
//              useRootNavigator: true,
//              transitionType: _transitionType,
//              closedBuilder: (BuildContext _, VoidCallback openContainer) {
//                return NotesFolderContainer(
//                  folder: folder,
////                onTap: () => _gotoNotesInFolder(database,
////                    folder),
//                );
//              },
//              closedElevation: 0,
//              openElevation: 0,
//              closedColor: Colors.transparent,
//              closedShape: const RoundedRectangleBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(0))),
//              openColor: Colors.transparent,
//              openBuilder: (BuildContext context, VoidCallback _) {
//                return NotesInFolder(database: database, folder: folder);
//              },
//            ), //on tap: NoteFolderDetail(note: folder);
//            actions: <Widget>[
//              IconSlideAction(
//                caption: 'Edit folder name',
//                color: Colors.black12,
//                iconWidget: FaIcon(
//                  FontAwesomeIcons.trashAlt,
//                  color: Colors.white,
//                ),
////                icon: Icons.delete,
//                onTap: () => _showAddDialog(context),
//              ),
//            ],
//            secondaryActions: <Widget>[
//              IconSlideAction(
//                caption: 'Delete',
//                color: Colors.black12,
//                iconWidget: FaIcon(
//                  FontAwesomeIcons.trashAlt,
//                  color: Colors.white,
//                ),
////                icon: Icons.delete,
//                onTap: () => _delete(context, folder),
//              ),
//            ],
//          );
//        });
//  }

//this is just to make UI look consistent
//  Widget getButtonFolderContainer(Database database) {
//    List defaultFolders = [
//      NotesFolderContainerButton(onTap: () => _showAddDialog(context)),
//    ];
//
//    return StaggeredGridView.countBuilder(
////        controller: _hideButtonController,
//        staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
//        mainAxisSpacing: 8.0,
//        crossAxisSpacing: 8.0,
//        physics: BouncingScrollPhysics(),
//        crossAxisCount: 4,
//        itemCount: defaultFolders.length,
//        shrinkWrap: true,
//        itemBuilder: (BuildContext context, int index) {
////          final folder = defaultFolders[index];
//          return NotesFolderContainerButton(
//              onTap: () => _showAddDialog(context));
//        });
//  }

///AddNotesScreen
///
/// stack add button
//   Visibility buildAddButton() {
//     final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
//     bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//     return Visibility(
//       visible: _addButtonVisible,
//       child: Stack(
//         overflow: Overflow.visible,
//         alignment: FractionalOffset(0.99, .90),
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12.0),
//             child: OpenContainer(
//               useRootNavigator: true,
//               transitionType: _transitionType,
//               openBuilder: (BuildContext context, VoidCallback _) {
//                 return AddNoteScreen(database: database, folder: folder);
//               },
//               closedElevation: 0.0,
//               closedColor: Colors.transparent,
//               openColor: Colors.transparent,
// //                  shape: CircleBorder(side: BorderSide(color: Colors.white, width: 2.0)),
//               closedShape: RoundedRectangleBorder(
//                 side: BorderSide(
//                     color: _darkTheme ? Colors.white : lightThemeButton,
//                     width: 2.0),
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(_fabDimension / 2),
//                 ),
//               ),
//               closedBuilder:
//                   (BuildContext context, VoidCallback openContainer) {
//                 return SizedBox(
//                   height: _fabDimension,
//                   width: _fabDimension,
//                   child: Center(
//                     child: Icon(
//                       Icons.add,
//                       size: 30,
//                       color: _darkTheme ? Colors.white : lightThemeButton,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//if use appBar, then no access to notes, unless move SteamBuilder above Scaffold, but the empty content and error message will look terrible if no scaffold

///pop up two level
//https://stackoverflow.com/questions/49672706/flutter-navigation-pop-to-index-1
//    int count = 0;
//    Navigator.popUntil(context, (route) {
//      return count++ == 2;
//    });

/// appbar with only title in FolderScreen
// Widget _buildAppBar() {
//   final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
//   bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//   return AppBar(
//     centerTitle: false,
//     elevation: 0,
//     backgroundColor: _darkTheme ? darkThemeAppBar : lightThemeAppBar,
//     automaticallyImplyLeading: false,
//     titleSpacing: 0.0,
//     title: Padding(
//       padding: const EdgeInsets.only(left: 40.0),
//       child: Text('Folders',
//           style: TextStyle(
//               color: _darkTheme ? darkThemeButton : lightThemeButton,
//               fontSize: 34,
//               fontWeight: FontWeight.w600)),
//     ),
//   );
// }

///sad icon
// Icon(
// Icons.sentiment_dissatisfied,
// size: 50,
// color: Colors.black,
// ),