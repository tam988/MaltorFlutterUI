import 'package:flutter/cupertino.dart';

import 'dark_theme_preference.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  DarkThemeProvider(){
    _darkTheme = false;
    darkThemePreference = DarkThemePreference();
    getPreferences();
  }

  getPreferences() async{
    _darkTheme = await darkThemePreference.getTheme();
    notifyListeners();
  }

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}