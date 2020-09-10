import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/landing_and_signIn/landing_page.dart';
import 'app/constants/theme.dart';
import 'app/services/multi_notifier.dart';
import 'package:rxdart/subjects.dart';

///Todo in notification: Replace android/app/src/main/res/drawable  app icon.
//done all configuration, for the following, added 'raw' file from example app
//⚠️ Ensure that you have configured the resources that should be kept so that resources like your notification icons aren't discarded by the R8 compiler by following the instructions here. Without doing this, you might not see the icon you've specified in your app's notifications. The configuration used by the example app can be found here where it is specifying that all drawable resources should be kept, as well as the file used to play a custom notification sound (sound file is located here).

/// for local notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

//this BehaviorSubject are all from RxDart
// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

void main() async {
  // needed if you intend to initialize in the `main` function
  // Ensure services are loaded before the widgets get loaded
  WidgetsFlutterBinding.ensureInitialized();

  // Restrict device orientiation to portraitUp
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// for local notification code:
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  // Note: permissions aren't requested here just to demonstrate that can be done
  // later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      //this is what to do on received notification
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });

  // //another example for onDidReceiveLocalNotification:
  // Future onDidReceiveLocalNotification(BuildContext context, int id,
  //     String title, String body, String payload) async {
  //   // display a dialog with the notification details, tap ok to go to another page
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: Text(title),
  //       content: Text(body),
  //       actions: [
  //         CupertinoDialogAction(
  //           isDefaultAction: true,
  //           child: Text('Ok'),
  //           onPressed: () async {
  //             Navigator.of(context, rootNavigator: true).pop();
  //             await Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => SecondScreen(payload),
  //               ),
  //             );
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }

  var initializationSettings = InitializationSettings(
    initializationSettingsAndroid,
    initializationSettingsIOS,
  );

  //Here we have specified the default icon to use for notifications on Android
  // (refer to the Android setup section) and designated the function (selectNotification)
  // that should fire when a notification has been tapped on via the onSelectNotification
  // callback. Specifying this callback is entirely optional but here it will trigger
  // navigation to another page and display the payload associated with the notification.
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });
  //
  // //another example for onSelectNotification
  // Future onSelectNotification(BuildContext context, String payload) async {
  //   if (payload != null) {
  //     debugPrint('notification payload: ' + payload);
  //   }
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => SecondScreen(payload)),
  //   );
  // }
  //
  // //In the real world, this payload could represent the id of the item you want
  // // to display the details of. Once the initialisation is complete, then you can
  // // manage the displaying of notifications.
  //
  // // ⚠ If the app has been launched by tapping on a notification created by this plugin, calling initialize is what will trigger the onSelectNotification to trigger to handle the notification that the user tapped on. An alternative to handling the "launch notification" is to call the getNotificationAppLaunchDetails method that is available in the plugin. This could be used, for example, to change the home route of the app for deep-linking. Calling initialize will still cause the onSelectNotification callback to fire for the launch notification. It will be up to developers to ensure that they don't process the same notification twice (e.g. by storing and comparing the notification id).
  //
  // //Then call the requestPermissions method with desired permissions at the appropriate point in your application
  // //The ?. operator is used here as the result will be null when run on other platforms.
  // var result = await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         IOSFlutterLocalNotificationsPlugin>()
  //     ?.requestPermissions(
  //       alert: true,
  //       badge: true,
  //       sound: true,
  //     );

  //The payload has been specified ('item x'), that will passed back through your application when the user has tapped on a notification.
  //
  // On Android devices, notifications will only in appear in the tray and won't
  // appear as a toast (heads-up notification) unless things like the priority/importance
  // has been set appropriately.
  //The "ticker" text is passed here though it is optional and specific to Android.
  // This allows for text to be shown in the status bar on older versions of Android
  // when the notification is shown.

  //On Android devices, the default behaviour is that the notification may not be
  // delivered at the specified time when the device in a low-power idle mode.
  // This behaviour can be changed by setting the optional parameter named
  // androidAllowWhileIdle to true when calling the schedule method.

  ///Todo, what is this?
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
    ///this is for setting
    SharedPreferences.getInstance().then((prefs) {
      bool darkModeOn = prefs.getBool('darkMode') ?? true;
      bool focusModeOn = prefs.getBool('focusMode') ?? true;
      bool randomOn = prefs.getBool('randomOn') ?? true;
      String backgroundImage =
          prefs.getString('imageUrl') ?? ImageUrl.fixedImageUrl;
      bool metricUnitOn = prefs.getBool('metricUnitOn') ?? true;
      bool useYourMantras = prefs.getBool('useMyMantras') ?? true;
      int index = prefs.getInt('indexMantra') ?? 0;
      bool useMyQuote = prefs.getBool('useMyQuote') ?? true;

      ///then runApp
      runApp(
        MultiProvider(
          providers: [
            ///for theme
            ChangeNotifierProvider<ThemeNotifier>(
                create: (_) =>
                    ThemeNotifier(darkModeOn ? darkTheme : lightTheme)),

            ///for focus
            ChangeNotifierProvider<FocusNotifier>(
                create: (_) => FocusNotifier(focusModeOn)),

            ///for image
            ChangeNotifierProvider<RandomNotifier>(
                create: (_) => RandomNotifier(randomOn)),
            ChangeNotifierProvider<ImageNotifier>(
                create: (_) => ImageNotifier(backgroundImage)),

            ///for metric
            ChangeNotifierProvider<MetricNotifier>(
                create: (_) => MetricNotifier(metricUnitOn)),

            ///for mantra
            ChangeNotifierProvider<MantraNotifier>(
                create: (_) => MantraNotifier(useYourMantras, index)),

            ///for quote
            ChangeNotifierProvider<QuoteNotifier>(
                create: (_) => QuoteNotifier(useMyQuote)),
          ],
          child: MyApp(),
        ),
      );
    });
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

///https://github.com/flutter/flutter/issues/21810

class _MyAppState extends State<MyApp> {
  ///for local notification
  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');

  @override
  void initState() {
    super.initState();
    _requestIOSPermissions();
    // _configureDidReceiveLocalNotificationSubject();
    // _configureSelectNotificationSubject();

    /// test on where to call this function
    _showDailyAtTime();
  }

  /// Showing a daily notification at a specific time
  Future<void> _showDailyAtTime() async {
    String _toTwoDigitString(int value) {
      return value.toString().padLeft(2, '0');
    }

    var time = Time(10, 0, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0, //id
        'show daily title', //title
        //body
        'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
        //notificationTime
        time,
        //NotificationDetails notificationDetails
        platformChannelSpecifics);
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  ///not sure what are these for
  // void _configureDidReceiveLocalNotificationSubject() {
  //   didReceiveLocalNotificationSubject.stream
  //       .listen((ReceivedNotification receivedNotification) async {
  //     await showDialog(
  //       context: context,
  //       builder: (BuildContext context) => CupertinoAlertDialog(
  //         title: receivedNotification.title != null
  //             ? Text(receivedNotification.title)
  //             : null,
  //         content: receivedNotification.body != null
  //             ? Text(receivedNotification.body)
  //             : null,
  //         actions: [
  //           CupertinoDialogAction(
  //             isDefaultAction: true,
  //             child: Text('Ok'),
  //             onPressed: () async {
  //               Navigator.of(context, rootNavigator: true).pop();
  //               await Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) =>
  //                       SecondScreen(receivedNotification.payload),
  //                 ),
  //               );
  //             },
  //           )
  //         ],
  //       ),
  //     );
  //   });
  // }

  // void _configureSelectNotificationSubject() {
  //   selectNotificationSubject.stream.listen((String payload) async {
  //     await Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => SecondScreen(payload)),
  //     );
  //   });
  // }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    return Provider<AuthBase>(
      create: (context) => Auth(),

      /// must have a Builder here
      /// we use `builder` to obtain a new `BuildContext` that has access to the provider
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'iMomentum',
            theme: themeNotifier.getTheme(),
            darkTheme:
                darkTheme, //add this so that the app will follow phone setting
            themeMode: ThemeMode.system,

            /// todo: local
            /// from plugin: flutter_localizations
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              GlobalCupertinoLocalizations
                  .delegate, // Add global cupertino localiztions.
            ],

            locale: Locale('en', 'US'), // Current locale
            supportedLocales: [
              const Locale('en', 'US'), // English
              const Locale('zh', 'ZH'), // Chinese??
            ],

            home: LandingPage(),
          );
        },
      ),
    );
  }
}

// class SecondScreen extends StatefulWidget {
//   SecondScreen(this.payload);
//
//   final String payload;
//
//   @override
//   State<StatefulWidget> createState() => SecondScreenState();
// }
//
// class SecondScreenState extends State<SecondScreen> {
//   String _payload;
//   @override
//   void initState() {
//     super.initState();
//     _payload = widget.payload;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Second Screen with payload: ${(_payload ?? '')}'),
//       ),
//       body: Center(
//         child: RaisedButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }
