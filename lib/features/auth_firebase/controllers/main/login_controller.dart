import 'package:bbuddy_app/core/core.dart';
import 'package:flutter/material.dart';
import '../../screens/screen.dart';
//import '../screens/mobile/login_mobile_screen.dart';

class LoginController extends StatelessController {
  const LoginController({Key? key}) : super(key: key);

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
    return Display(
      title: 'Login Section',
      mobile: const LoginScreen(),
    );
  }
}
