import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:ui_ids/localization/language_constants.dart';
// import 'package:ui_ids/models/dark_theme_provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:ui_ids/models/language.dart';

import '../main.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  static const routeName = '/settings_view';

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  static const keyLanguage = 'key-language';
  bool isSwitched = false;

  void _changeLanguage(Language? language) async {
    Locale _locale = await setLocale(language?.languageCode);
    MyApp.setLocale(context, _locale);
  }

  // Widget buildLanguage() => DropDownSettingsTile<Language>(
  //       title: 'Language',
  //       settingKey: keyLanguage,
  //       selected: Language.languageList().first,
  //       values: <Language, String>{
  //         Language.languageList().first: 'English',
  //         Language.languageList().last: 'Arabic'
  //       },
  //       onChange: (Language? language) {
  //         _changeLanguage(language);
  //       },
  //     );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            SettingsGroup(
              title: getTranslated(context, 'general')!,
              children: <Widget>[
                Container(
                  child: Center(
                      child: DropdownButton<Language>(
                    iconSize: 30,
                    hint: Text((getTranslated(context, 'change_language'))!),
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
                                Text(
                                  e.flag,
                                  style: TextStyle(fontSize: 30),
                                ),
                                Text(e.name)
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  )),
                ),
              ],
            )
          ],
        ),
      ),
      // SettingsList(
      //   sections: [
      //     SettingsSection(
      //       // titlePadding: EdgeInsets.all(20),
      //       title: Text((getTranslated(context, 'general'))!),
      //       tiles: [
      //         SettingsTile(
      //           title: Text((getTranslated(context, 'language'))!),
      //           value: Text((getTranslated(context, 'lang_sub'))!),
      //           leading: Icon(Icons.language),
      //           onPressed: (BuildContext context) {},
      //         ),
      //         SettingsTile.switchTile(
      //           title: Text((getTranslated(context, 'dark_mode'))!),
      //           leading: Icon(Icons.dark_mode_outlined),
      //           initialValue: themeChange.darkTheme,
      //           onToggle: (value) {
      //             setState(() {
      //               themeChange.darkTheme = value;
      //             });
      //           },
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}