import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../Screens/mobile/goal_screen/goal_home.dart' as mobile;
// import '../../Screens/desktop/news.dart' as desktop;
// import '../../Screens/tablet/news.dart' as tablet;

class GoalsController extends StatelessController {
  const GoalsController({Key? key}) : super(key: key);

  @override
  bool get auth => true;

  @override
  Display view(BuildContext context) {
    return Display(
      title: 'Goals',
      mobile: const mobile.GoalHome(),
      // tabletLandscape: const tablet.News(),
      // desktop: const desktop.News(),
    );
  }
}
