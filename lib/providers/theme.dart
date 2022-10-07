
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light_mode = ThemeData(
  brightness: Brightness.light,
);

ThemeData dark_mode = ThemeData(
  brightness: Brightness.dark,
);

class ThemeChanger with ChangeNotifier {
  final String key = "theme";
   SharedPreferences? _preferences;
  late bool isDark = false;
  var _themeMode = ThemeMode.light;

  get getTheme => _themeMode;

  ThemeChanger(){
    isDark = true;
    _loadFromPreferences();
  }
  _initialPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
  }
  _savePreferences()async {
    await _initialPreferences();
    _preferences?.setBool(key, isDark);
  }
  _loadFromPreferences() async {
    await _initialPreferences();
    isDark = _preferences?.getBool(key) ?? true;
    notifyListeners();
  }

  setTheme(themeMode) {
    isDark = !isDark;
    _themeMode = themeMode;
    _savePreferences();
    notifyListeners();
  }
  toggleChangeTheme() {
    isDark = !isDark;
    _savePreferences();
    notifyListeners();
  }

}

