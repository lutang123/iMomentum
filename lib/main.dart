import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/landing_and_signIn/landing_page.dart';
import 'app/constants/theme.dart';
import 'app/services/multi_notifier.dart';

void main() async {
  // Ensure services are loaded before the widgets get loaded
  WidgetsFlutterBinding.ensureInitialized();
  // Restrict device orientiation to portraitUp
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  ///what is this?
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
    SharedPreferences.getInstance().then((prefs) {
      bool darkModeOn = prefs.getBool('darkMode') ?? true;
      bool useYourMantras = prefs.getBool('useMyMantras') ?? true;
      int index = prefs.getInt('indexMantra') ?? 0;

      bool useMyQuote = prefs.getBool('useMyQuote') ?? true;
      bool focusModeOn = prefs.getBool('focusMode') ?? true;
      bool randomOn = prefs.getBool('randomOn') ?? true;
      String backgroundImage =
          prefs.getString('imageUrl') ?? ImageUrl.fixedImageUrl;
//      bool appliedOwnPhoto = prefs.getBool('appliedOwnPhoto') ?? false;
//      String appliedPhotoUrl = prefs.getString('appliedImageUrl');
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeNotifier>(
                create: (_) =>
                    ThemeNotifier(darkModeOn ? darkTheme : lightTheme)),
            ChangeNotifierProvider<FocusNotifier>(
                create: (_) => FocusNotifier(focusModeOn)),
            ChangeNotifierProvider<MantraNotifier>(
                create: (_) => MantraNotifier(useYourMantras, index)),
            ChangeNotifierProvider<QuoteNotifier>(
                create: (_) => QuoteNotifier(useMyQuote)),
            ChangeNotifierProvider<RandomNotifier>(
                create: (_) => RandomNotifier(randomOn)),
            ChangeNotifierProvider<ImageNotifier>(
                create: (_) => ImageNotifier(backgroundImage)),
//            ChangeNotifierProvider<AppliedOwnPhotoNotifier>(
//                create: (_) => AppliedOwnPhotoNotifier(appliedOwnPhoto)),
//            ChangeNotifierProvider<AppliedPhotoUrlNotifier>(
//                create: (_) => AppliedPhotoUrlNotifier(appliedPhotoUrl)),
          ],
          child: MyApp(),
        ),
      );
    });
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final Brightness brightnessValue =
//        MediaQuery.of(context).platformBrightness;
//    bool isDark = brightnessValue == Brightness.dark;
//    print(isDark);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: Builder(
        builder: (context) {
          return KeyboardVisibilityProvider(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'iMomentum',
              theme: themeNotifier.getTheme(),
              themeMode: ThemeMode.system,
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
            ),
          );
        },
      ),
    );
  }
}

//import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
//import 'package:iMomentum/screens/home_screen/home_screen.dart';
//import 'package:provider/provider.dart';
//
//import 'package:iMomentum/screens/notes_screen/keep/models.dart'
//    show CurrentUser;
//import 'package:iMomentum/screens/notes_screen/keep/screens.dart'
//    show HomeScreen, HomeScreenKeep, LoginScreen, NoteEditor, SettingsScreen;
//import 'package:iMomentum/screens/notes_screen/keep/styles.dart';
//
//void main() => runApp(NotesApp());
//
//class NotesApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) => StreamProvider.value(
//        value: FirebaseAuth.instance.onAuthStateChanged
//            .map((user) => CurrentUser.create(user)),
//        initialData: CurrentUser.initial,
//        child: Consumer<CurrentUser>(
//          builder: (context, user, _) => MaterialApp(
//            title: 'Flutter Keep',
//            theme: Theme.of(context).copyWith(
//              brightness: Brightness.light,
//              primaryColor: Colors.white,
//              accentColor: kAccentColorLight,
//              appBarTheme: AppBarTheme.of(context).copyWith(
//                elevation: 0,
//                brightness: Brightness.light,
//                iconTheme: IconThemeData(
//                  color: kIconTintLight,
//                ),
//              ),
//              scaffoldBackgroundColor: Colors.white,
//              bottomAppBarColor: kBottomAppBarColorLight,
//              primaryTextTheme: Theme.of(context).primaryTextTheme.copyWith(
//                    // title
//                    headline6: const TextStyle(
//                      color: kIconTintLight,
//                    ),
//                  ),
//            ),
//            home: user.isInitialValue
//                ? Scaffold(body: const SizedBox())
//                : user.data != null ? HomeScreenKeep() : LoginScreen(),
//            routes: {
//              '/settings': (_) => SettingsScreen(),
//            },
//            onGenerateRoute: _generateRoute,
//          ),
//        ),
//      );
//
//  /// Handle named route
//  Route _generateRoute(RouteSettings settings) {
//    try {
//      return _doGenerateRoute(settings);
//    } catch (e, s) {
//      debugPrint("failed to generate route for $settings: $e $s");
//      return null;
//    }
//  }
//
//  Route _doGenerateRoute(RouteSettings settings) {
//    if (settings.name?.isNotEmpty != true) return null;
//
//    final uri = Uri.parse(settings.name);
//    final path = uri.path ?? '';
//    // final q = uri.queryParameters ?? <String, String>{};
//    switch (path) {
//      case '/note':
//        {
//          final note = (settings.arguments as Map ?? {})['note'];
//          return _buildRoute(settings, (_) => NoteEditor(note: note));
//        }
//      default:
//        return null;
//    }
//  }
//
//  /// Create a [Route].
//  Route _buildRoute(RouteSettings settings, WidgetBuilder builder) =>
//      MaterialPageRoute<void>(
//        settings: settings,
//        builder: builder,
//      );
//}
