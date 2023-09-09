import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  double computeEmojiSize(double screenWidth) {
    return screenWidth * 0.12.w;
  }

  double computeTextSize(double screenWidth) {
    return screenWidth > 414 ? 16.sp : 18.sp;
  }

  double computeButtonHeight(double screenWidth, double screenHeight) {
    return screenWidth > 414 ? screenHeight * 0.09 : screenHeight * 0.1;
  }
}