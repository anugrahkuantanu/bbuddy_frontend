import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bbuddy_app/config/config.dart';
import 'package:bbuddy_app/core/core.dart';
import 'package:bbuddy_app/features/main_app/screens/screen.dart' as mobile;

class HomeController extends StatelessController {
  final String _title = 'Home Page';
  const HomeController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    // Navigation Bug Fixes
    var tm = context.read<ThemeProvider?>();
    tm?.setNavIndex(0);
    return Display(
      title: _title,
      mobile: const mobile.HomePage(),
    );
  }
}
