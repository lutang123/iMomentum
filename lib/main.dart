import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          return MaterialApp(
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
          );
        },
      ),
    );
  }
}
