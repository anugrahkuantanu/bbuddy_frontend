import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../screens/screen.dart' as mobile;

class HomeController extends StatelessController {
  final String _title = 'Home Page';
  const HomeController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    // Navigation Bug Fixes
    // TODO: Check this nav index why we need to do this
    //var tm = context.read<ThemeProvider?>();
    //tm?.setNavIndex(0);
    return Display(
      title: _title,
      mobile: const mobile.HomePage(),
    );
  }
}
