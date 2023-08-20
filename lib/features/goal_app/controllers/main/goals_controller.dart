import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../Screen/mobile/goal_screen/goal_home.dart' as mobile;

class GoalsController extends StatelessController {
  const GoalsController({Key? key}) : super(key: key);

  @override
  // bool get auth => true;

  @override
  Display view(BuildContext context) {
    return Display(
      title: 'Goals',
      mobile: mobile.GoalHome(),
    );
  }
}
