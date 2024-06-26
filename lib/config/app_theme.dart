import 'package:shared_preferences/shared_preferences.dart';

import '../core/classes/theme_manager.dart';
import '../core/classes/theme_provider.dart';

import 'package:flutter/material.dart';


class ThemeProvider extends BaseThemeProvider {
  int _index = 0;
  // late ThemeMode? _themeMode;
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider() {
    loadThemeMode().then((mode) {
      _themeMode = mode;
      notifyListeners();
    });
  }

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveThemeMode(mode);
    notifyListeners();
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('theme_mode', mode.index);
  }

  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return ThemeMode.values[prefs.getInt('theme_mode') ?? 1];
  }

  get index => _index;

  setNavIndex(int index) {
    _index = index;
    if (index != 0) {
      notifyListeners();
    }
  }
}

class MyTheme extends AppTheme {}


// class ThemeProvider extends BaseThemeProvider {
//   int _index = 0;
//   // late ThemeMode? _themeMode;
//   ThemeMode _themeMode = ThemeMode.dark;

//   ThemeProvider() {
//     // loadThemeMode().then((mode) {
//     //   _themeMode = mode;
//     //   notifyListeners();
//     // });
//   }

//   ThemeMode get themeMode => _themeMode;

//   @override
//   set themeMode(ThemeMode mode) {
//     _themeMode = mode;
//     notifyListeners();
//   }

//   get index => _index;

//   setNavIndex(int index) {
//     _index = index;
//     if (index != 0) {
//       notifyListeners();
//     }
//   }
// }

// class MyTheme extends AppTheme {}
