import 'package:flutter/material.dart';

import 'package:bbuddy_app/core/core.dart';
import 'package:bbuddy_app/features/goal_app/screens/screen.dart' as mobile;

import 'package:bbuddy_app/features/goal_app/models/model.dart';

class ProgressController extends StatelessController {
  final Goal goal;
  final Function(Goal goal)? updateCallBack;

  const ProgressController({
    Key? key,
    required this.goal,
    this.updateCallBack,
  }) : super(key: key);

  @override
  // bool get auth => true;

  @override
  Display view(BuildContext context) {
    return Display(
      title: 'Goals',
      mobile: mobile.ProgressPage(goal: goal, updateCallBack: updateCallBack),
    );
  }
}
