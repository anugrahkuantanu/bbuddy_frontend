import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReasonPageBloc {
  final List<String> entities = [
    'School',
    'Work',
    'Family',
    'Relation-ships',
    'Partner',
    'Money',
    'Health',
    'Friend-ship',
    'Social Media',
    'Good Sleep',
    'Career',
    'Goals',
    'Sex',
    'Boredom',
    'Addict-ion',
    'Food',
    'Other',
  ];

  final Map<String, IconData> iconsMap = {
    'School': Icons.school,
    'Work': Icons.work,
    'Family': Icons.family_restroom,
    'Relation-ships': Icons.favorite,
    'Partner': Icons.favorite_border,
    'Money': Icons.attach_money,
    'Health': Icons.health_and_safety,
    'Friend-ship': Icons.emoji_people,
    'Social Media': Icons.social_distance,
    'Good Sleep': Icons.nights_stay,
    'Career': Icons.work_outline,
    'Goals': Icons.check_box_outline_blank,
    'Sex': Icons.people_alt,
    'Boredom': Icons.sentiment_dissatisfied,
    'Addict-ion': Icons.smoking_rooms,
    'Food': Icons.fastfood,
    'Other': Icons.more_horiz,
  };

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
