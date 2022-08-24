import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:provider/provider.dart';
import 'package:ui_ids/localization/demo_localization.dart';
import 'package:ui_ids/login.dart';
import 'package:ui_ids/models/dark_theme_provider.dart';
import 'package:ui_ids/tabs_screen.dart';
import 'package:ui_ids/views/scan_app.dart';
import 'package:ui_ids/views/search_view.dart';
import 'package:ui_ids/views/settings_view.dart';

import 'localization/language_constants.dart';
import 'models/style.dart';
import '';
// import 'package:ui_ids/router/custom_router.dart';
// import 'package:ui_ids/router/route_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp fbApp = await Firebase.initializeApp();
  // await Settings.init(cacheProvider: SharePreferenceCache());
  runApp(MyApp(fbApp: fbApp));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.fbApp}) : super(key: key);
  final FirebaseApp fbApp;
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyFirebaseAppState? state =
        context.findAncestorStateOfType<_MyFirebaseAppState>();
    state!.setLocale(newLocale);
  }

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      this._locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong !"),
          );
        }
        //if (snapshot.connectionState == ConnectionState.done) {
        return MyFirebaseApp(fbApp: widget.fbApp);
        // }
        // return Material(
        //   child: Center(
        //     child: CircularProgressIndicator.adaptive(),
        //   ),
        // );
      },
    );
  }
}

class MyFirebaseApp extends StatefulWidget {
  MyFirebaseApp({Key? key, required this.fbApp}) : super(key: key);
  final FirebaseApp fbApp;
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyFirebaseAppState? state =
        context.findAncestorStateOfType<_MyFirebaseAppState>();
    state!.setLocale(newLocale);
  }

  @override
  _MyFirebaseAppState createState() => _MyFirebaseAppState();
}

class _MyFirebaseAppState extends State<MyFirebaseApp> {
  late final Stream<User?> _stream;

  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _stream = FirebaseAuth.instance.authStateChanges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _stream,
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return MaterialApp(
            title: 'SEL ',
            theme: ThemeData(
              primarySwatch: Colors.lime,
              accentColor: Colors.amber,
              canvasColor: Color.fromRGBO(238, 242, 242, 1),
              fontFamily: 'Raleway',
              textTheme: ThemeData.light().textTheme.copyWith(
                  bodyText1: TextStyle(
                    color: Color.fromRGBO(20, 51, 51, 1.0),
                  ),
                  bodyText2: TextStyle(
                    color: Color.fromRGBO(20, 51, 51, 1.0),
                    fontSize: 15,
                  ),
                  headline1: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            //home: CategoriesScreen(),
            locale: _locale,
            supportedLocales: [Locale('en', 'US'), Locale('ar', 'SA')],
            localizationsDelegates: [
              DemoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale!.languageCode &&
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            routes: {
              '/': (ctx) => TabsScreen(),
              AppScanView.routeName: (ctx) => AppScanView(),
              SettingsView.routeName: (ctx) => SettingsView(),
              Login.routeName: (ctx) => Login(),
            },
            initialRoute: snapshot.hasData ? '/' : Login.routeName,
            onGenerateRoute: (settings) {
              print(settings.arguments);
              return MaterialPageRoute(builder: (ctx) => SearchView());
            },
            onUnknownRoute: (settings) {
              return MaterialPageRoute(builder: (ctx) => SearchView());
            },
          );
        }

        return Material(
          child: Center(
            child: SizedBox(
              height: 40,
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        );
      },
    );
  }
}