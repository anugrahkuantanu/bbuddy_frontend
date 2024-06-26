import 'package:bbuddy_app/features/auth_firebase/screens/mobile/profile_page.dart' as mobile;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../../config/config.dart';
import '../../../../../core/core.dart';


class ProfileController extends StatelessController {
  final String _title = 'Home Page';
  const ProfileController({Key? key}) : super(key: key);

  @override
  bool get auth => true;

  @override
  Display view(BuildContext context) {
    // Navigation Bug Fixes
    var tm = context.read<ThemeProvider>();
    tm.setNavIndex(0);

    return Display(
      title: _title,
      mobile: const mobile.ProfilePage(),
    );
  }
}
