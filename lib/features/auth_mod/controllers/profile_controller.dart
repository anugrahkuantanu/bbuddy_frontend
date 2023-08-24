import 'package:flutter/material.dart';

import '../screens/mobile/login_screen/screen.dart';

class ProfileController extends StatelessWidget {
  const ProfileController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Profile Section',
      color: Colors.blue,
      child: ProfilePage(),
    );
  }
}
