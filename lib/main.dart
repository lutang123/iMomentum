import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iMomentum/screens/iMeditate/utils/utils.dart';
import 'package:iMomentum/app/services/auth.dart';
import 'package:provider/provider.dart';
import 'app/landing_and_signIn/landing_page.dart';

void main() {
  //TODO: What is this for ??
  loadLicenses();
  // Ensure services are loaded before the widgets get loaded
  WidgetsFlutterBinding.ensureInitialized();
  // Restrict device orientiation to portraitUp
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'iMomentum',
        theme: ThemeData.dark().copyWith(
          canvasColor: Colors.transparent,
          primaryColor: Colors.white,
          bottomSheetTheme:
              BottomSheetThemeData(backgroundColor: Colors.transparent),
        ),
//        localizationsDelegates: [
//          S.delegate,
//          globalMaterialLocalizations.delegate,
//          globalWidgetsLocalizations.delegate,
//        ],
//        supportedLocales: S.delegate.supportedLocales,
//
//      builder: (context, widget) {
//        //TODO: What is this for ??
//        return ResponsiveWrapper.builder(
//          widget,
////          maxWidth: 1200,
////          minWidth: 450,
//          defaultScale: true,
////            breakpoints: [
////              ResponsiveBreakpoint(breakpoint: 450, name: MOBILE),
////              ResponsiveBreakpoint(
////                  breakpoint: 800, name: TABLET, autoScale: true),
////              ResponsiveBreakpoint(
////                  breakpoint: 1000, name: TABLET, autoScale: true),
////              ResponsiveBreakpoint(breakpoint: 1200, name: DESKTOP),
////              ResponsiveBreakpoint(
////                  breakpoint: 2460, name: "4K", autoScale: true),
////            ],
//          background: Container(
//            color: isDark(context) ? bgDark : fgDark,
//          ),
//        );
//      },
//        theme: lightTheme,
//        darkTheme: darkTheme,
//        themeMode: ThemeMode.system,
        home: LandingPage(),

//        // ignore: missing_return
//        onGenerateRoute: (settings) {
//          if (settings.name == '/') {
//            return PageRoutes.fade(() => LoadingScreen());
////                MainScreen(startingAnimation: true));
//          }
//        },
      ),
    );
  }
}

//import 'package:flutter/material.dart';
//import 'screens/first_loading/loading_screen.dart';
////https://flutter.dev/docs/cookbook/images/fading-in-images
//
//void main() {
//  runApp(MyApp());
//}
//
//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      title: 'Note',
//      theme: ThemeData.dark().copyWith(
//        canvasColor: Colors.transparent,
////        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.black54),
//      ),
//
//      home: LoadingLocation(),
////      routes: {
////        '/': (context) => LoadingLocation(),
////        '/calendar': (context) => Calender(),
////        '/todos': (context) => ToDos(),
////        '/notes': (context) => screens.Notes(),
////      },
//    );
//  }
//}
