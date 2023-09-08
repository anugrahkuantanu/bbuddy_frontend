import 'package:bbuddy_app/features/features.dart';
import 'package:flutter/material.dart';
import '../screens/screen.dart';
//import '../screens/mobile/login_mobile_screen.dart';


class SplashController extends StatelessWidget {
  const SplashController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.blue,
      child: SplashScreen(title: '',),
    );
  }
}
