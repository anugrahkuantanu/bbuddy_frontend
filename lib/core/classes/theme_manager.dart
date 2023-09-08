import '../../architect.dart';
import 'package:flutter/material.dart';

import '../../config/config.dart';

class AppTheme {
  ThemeData? light;
  ThemeData? dark;

  AppTheme([
    this.light,
    this.dark,
  ]) {
    light = light ??
        ThemeData(
          scaffoldBackgroundColor: AppColors.lightscreen[100],
          brightness: Brightness.light,
          primarySwatch: AppColors.lightscreen,
          bottomAppBarColor: Colors.white,
          appBarTheme: AppBarTheme(
            titleTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            backgroundColor: AppColors.lightscreen[100],
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: AppColors.lightscreen,
          ),
          popupMenuTheme: const PopupMenuThemeData(
            // color: AppColors.space,
            color: Color.fromARGB(255, 11, 238, 250),
            elevation: 15,
            enableFeedback: true,
          ),
          drawerTheme: const DrawerThemeData(
            backgroundColor: Color.fromARGB(255, 213, 247, 249),
            elevation: 10,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.lightscreen,
            selectedItemColor: Colors.white,
            elevation: 10,
            showSelectedLabels: true,
          ),
          bottomAppBarTheme: const BottomAppBarTheme(color: AppColors.lightscreen),
          useMaterial3: true,
        );

    dark = dark ??
        ThemeData(
          scaffoldBackgroundColor: AppColors.darkscreen,
          brightness: Brightness.dark,
          primarySwatch: Colors.yellow,
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            backgroundColor: AppColors.darkscreen,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
            buttonColor: Colors.white,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: AppColors.darkscreen[800],
            selectedItemColor: AppColors.lightscreen[500],
            elevation: 10,
            showSelectedLabels: true,
          ),
          useMaterial3: true,
        );
  }

  ThemeData get lightTheme => light!;
  ThemeData get darkTheme => dark!;

  AppTheme copyWith({
    ThemeData? light,
    ThemeData? dark,
  }) {
    return AppTheme(
      light ?? this.light,
      dark ?? this.dark,
    );
  }
}
