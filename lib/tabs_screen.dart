import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ui_ids/views/search_view.dart';
import 'package:ui_ids/views/settings_view.dart';
import 'package:ui_ids/views/scan_app.dart';
import 'package:ui_ids/models/language.dart';
//import 'package:ui_ids/views/update_view.dart';
import 'package:ui_ids/main.dart';
import 'package:ui_ids/localization/language_constants.dart';

import 'package:firebase_auth/firebase_auth.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({
    Key? key,
  }) : super(key: key);
  //static const routeName = '/tabs_screen';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late final User? currentUser;
  late final VoidCallback onChanged;

  void _changeLanguage(Language? language) async {
    Locale _locale = await setLocale(language?.languageCode);
    MyApp.setLocale(context, _locale);
  }

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      //TODO handle errors better
      log('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('SEL IDS'),
          leading: IconButton(
            icon: Icon(Icons.logout_rounded),
            onPressed: _logout,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<Language>(
                underline: SizedBox(),
                icon: Icon(
                  Icons.language,
                ),
                iconEnabledColor: Colors.black,
                onChanged: (Language? language) {
                  _changeLanguage(language);
                },
                items: Language.languageList()
                    .map<DropdownMenuItem<Language>>(
                      (e) => DropdownMenuItem<Language>(
                        value: e,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            // Text(
                            //   e.flag,
                            //   style: TextStyle(fontSize: 30),
                            // ),
                            Text(e.name)
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.document_scanner_rounded),
                text: getTranslated(context, 'scan'),
              ),
              Tab(
                icon: Icon(Icons.perm_device_info_rounded),
                text: getTranslated(context, 'device_info'),
              ),
              // Tab(
              //   icon: Icon(Icons.update_rounded),
              //   text: 'Update',
              // ),
              Tab(
                icon: Icon(Icons.settings_rounded),
                text: getTranslated(context, 'settings'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            AppScanView(),
            SearchView(),
            //UpdateView(),
            SettingsView(),
          ],
        ),
      ),
    );
  }
}