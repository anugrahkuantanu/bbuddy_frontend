import '../core/classes/theme_manager.dart';
import '../core/classes/theme_provider.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class ThemeProvider extends BaseThemeProvider {
//   int _index = 0;

//   get index => _index;

//   setNavIndex(int index) {
//     _index = index;
//     if (index != 0) {
//       notifyListeners();
//     }
//   }
// }




class ThemeProvider extends BaseThemeProvider {
  int _index = 0;
  // late ThemeMode? _themeMode;
  ThemeMode? _themeMode = ThemeMode.system;


  ThemeProvider() {
    // print("ThemeProvider constructor called");
    loadThemeMode().then((mode) {
      // print("Theme loaded: $mode");
      _themeMode = mode;
      notifyListeners();
    });
  }

  //   Future<void> initProvider() async {
  //   _themeMode = await loadThemeMode();
  //   notifyListeners();
  // }


  ThemeMode get themeMode => _themeMode?? ThemeMode.system;

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
    return ThemeMode.values[prefs.getInt('theme_mode') ?? 0];
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