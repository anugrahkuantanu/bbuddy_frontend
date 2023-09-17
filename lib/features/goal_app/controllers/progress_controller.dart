import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../screens/screen.dart' as mobile;

import '../models/model.dart';

class ProgressController extends StatelessController {
  final Goal goal;
  final bool generateMilestones;
  final Function(Goal goal)? updateCallBack;

  const ProgressController({
    Key? key,
    required this.goal,
    this.generateMilestones = false,
    this.updateCallBack,
  }) : super(key: key);

  @override
  // bool get auth => true;

  @override
  Display view(BuildContext context) {
    return Display(
      title: 'Goals',
      mobile: mobile.ProgressPage(goal: goal, generateMilestones: generateMilestones, updateCallBack: updateCallBack),
    );
  }
}
