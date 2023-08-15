import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReasonScreenBloc {
  final List<String> entities = [
    'School',
    'Work',
    'Family',
    'Relationships',
    'Partner',
    'Money',
    'Health',
    'Friendship',
    'Social Media',
    'Good Sleep',
    'Career',
    'Goals',
    'Sex',
    'Boredom',
    'Addiction',
    'Food',
    'Other',
  ];

  final Map<String, IconData> iconsMap = {
    'School': Icons.school,
    'Work': Icons.work,
    'Family': Icons.family_restroom,
    'Relationships': Icons.favorite,
    'Partner': Icons.favorite_border,
    'Money': Icons.attach_money,
    'Health': Icons.health_and_safety,
    'Friendship': Icons.emoji_people,
    'Social Media': Icons.social_distance,
    'Good Sleep': Icons.nights_stay,
    'Career': Icons.work_outline,
    'Goals': Icons.check_box_outline_blank,
    'Sex': Icons.people_alt,
    'Boredom': Icons.sentiment_dissatisfied,
    'Addiction': Icons.smoking_rooms,
    'Food': Icons.fastfood,
    'Other': Icons.more_horiz,
  };

  final List<Color> buttonColors = [
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
  ];

  IconData getIcon(String entity) {
    return iconsMap[entity]!;
  }

  double computeEmojiSize(double screenWidth) {
    if (screenWidth < 380) {
      return screenWidth * 0.08.w;
    } else if (screenWidth < 400) {
      return screenWidth * 0.10.w;
    } else {
      return screenWidth * 0.09.w;
    }
  }

  double computeTextSize(double screenWidth) {
    // if (screenWidth < 380) {
    //   return 15.sp;
    // } else if (screenWidth < 400) {
    //   return 17.sp;
    // } else {
    //   return 16.sp;
    // }
    return 14.sp;
  }

  double computeHighSpace(double screenWidth, double screenHeight) {
    if (screenWidth < 380) {
      return screenHeight * 0.03;
    } else if (screenWidth < 400) {
      return screenHeight * 0.06;
    } else {
      return screenHeight * 0.04;
    }
  }
}
