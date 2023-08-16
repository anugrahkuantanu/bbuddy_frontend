import 'package:flutter/material.dart';
import '../screens/mobile/login_screen/login_page.dart';

class LoginController extends StatelessWidget {
  const LoginController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Login Section',
      color: Colors.blue,
      child: const LoginPage(),
    );
  }
}
