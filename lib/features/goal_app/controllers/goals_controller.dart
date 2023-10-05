import 'package:flutter/material.dart';

import 'package:bbuddy_app/core/core.dart';
import 'package:bbuddy_app/features/goal_app/screens/mobile/goal_home.dart'
    as mobile;

class GoalsController extends StatelessController {
  const GoalsController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    return Display(
      title: 'Goals',
      mobile: mobile.GoalHome(),
    );
  }
}
