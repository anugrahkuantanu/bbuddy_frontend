import 'package:flutter/material.dart';
import '/config/config.dart';

class CheckInHomeBloc {
  final List<Map<String, dynamic>> feelings = [
    {"name": "Angry", "emoji": "😠"},
    {"name": "Anxious", "emoji": "😟"},
    {"name": "Embarrassed", "emoji": "😳"},
    {"name": "Happy", "emoji": "😊"},
    {"name": "Hurt", "emoji": "😢"},
    {"name": "Sad", "emoji": "😔"},
  ];

  Color getTextColor(ThemeProvider tm) {
    return tm.isDarkMode ? AppColors.textlight : AppColors.textdark;
  }

  Color getBackgroundColor(ThemeProvider tm) {
      return (tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100])!;
  }

  Color getAppBarColor(ThemeProvider tm) {
      return (tm.isDarkMode ? AppColors.darkscreen[800] : AppColors.lightscreen)!;
  }


  double computeEmojiSize(double screenWidth) {
    return screenWidth * 0.12;
  }

  double computeTextSize(double screenWidth) {
    return screenWidth > 414 ? 16 : 18;
  }

  double computeButtonHeight(double screenWidth, double screenHeight) {
    return screenWidth > 414 ? screenHeight * 0.09 : screenHeight * 0.1;
  }
}