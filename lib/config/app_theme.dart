import '../core/classes/theme_manager.dart';
import '../core/classes/theme_provider.dart';

import 'package:flutter/material.dart';

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
  int _index = 1;
  // late ThemeMode? _themeMode;
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeProvider() {
    // loadThemeMode().then((mode) {
    //   _themeMode = mode;
    //   notifyListeners();
    // });
  }

  ThemeMode get themeMode => _themeMode;

  @override
  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
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
