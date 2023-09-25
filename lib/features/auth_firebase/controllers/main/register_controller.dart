import 'package:flutter/material.dart';
import 'package:bbuddy_app/core/core.dart';
import '../../screens/screen.dart';

class RegisterController extends StatelessController {
  const RegisterController({Key? key}) : super(key: key);

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
    return Display(
      title: 'Register',
      mobile: const RegisterView(),
    );
  }
}
