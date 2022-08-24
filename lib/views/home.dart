import 'package:flutter/material.dart';
import 'package:ui_ids/models/dark_theme_provider.dart';
import 'package:ui_ids/models/style.dart';
import 'package:ui_ids/tabs_screen.dart';
import 'package:ui_ids/views/scan_app.dart';
import 'package:ui_ids/views/search_view.dart';
import 'package:ui_ids/views/settings_view.dart';
import 'package:ui_ids/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ui_ids/localization/demo_localization.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  late final Stream<User?> _stream;
  late Locale _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    _stream = FirebaseAuth.instance.authStateChanges();
    super.initState();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _stream,
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return MaterialApp(
            title: 'SEL ',
            theme: Styles.themeData(
                themeChangeProvider.darkTheme, context), //ThemeData(
            //   primarySwatch: Colors.lime,
            //   accentColor: Colors.amber,
            //   canvasColor: Color.fromRGBO(238, 242, 242, 1),
            //   fontFamily: 'Raleway',
            //   textTheme: ThemeData.light().textTheme.copyWith(
            //       bodyText1: TextStyle(
            //         color: Color.fromRGBO(20, 51, 51, 1),
            //       ),
            //       bodyText2: TextStyle(color: Color.fromRGBO(20, 51, 51, 1), fontSize: 15,),
            //       headline1:TextStyle(
            //         fontSize: 20.0,
            //         fontFamily: 'RobotoCondensed',
            //         fontWeight: FontWeight.bold,
            //       )),
            //   visualDensity: VisualDensity.adaptivePlatformDensity,
            // ),
            //home: CategoriesScreen(),
            // locale: _locale,
            // supportedLocales: [
            //   Locale('en', 'US'),
            //   Locale('ar', 'SA')
            // ],
            // localizationsDelegates: [
            //   DemoLocalizations.delegate,
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            //   GlobalCupertinoLocalizations.delegate,
            // ],
            // localeResolutionCallback: (locale, supportedLocales) {
            //   for (var supportedLocale in supportedLocales) {
            //     if (supportedLocale.languageCode == locale!.languageCode &&
            //         supportedLocale.countryCode == locale.countryCode) {
            //       return supportedLocale;
            //     }
            //   }
            //   return supportedLocales.first;
            // },
            routes: {
              '/': (ctx) => TabsScreen(),
              SearchView.routeName: (ctx) => SearchView(),
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