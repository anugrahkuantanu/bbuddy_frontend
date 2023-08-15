import 'dart:async';

// import 'package:Bbuddy/app.dart';
import 'package:flutter/material.dart';

import '../login_screen/login_page.dart';
import '../../../services/login.dart';
import '../../../models/model.dart';
import '../../../../../main.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  _SplashScreenState() {
    new Timer(const Duration(milliseconds: 2500), () {
      setState(() {
        //_decideNavigation();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyApp()),
          (route) => false,
        );
      });
    });

    new Timer(Duration(milliseconds: 10), () {
      setState(() {
        _isVisible =
            true; // Now it is showing fade effect and navigating to Login page
      });
    });
  }

  /*void _decideNavigation() async {
    Token? accessToken = await getAccessToken();
    if (accessToken != null) {
      //print(accessToken.toJson());
      // Navigate to the app's home page
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
        (route) => false,
      );
    } else {
      // Navigate to the login screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).primaryColor
          ],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(0.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: Duration(milliseconds: 1200),
        child: Center(
          child: Container(
            height: 300.0,
            width: 300.0,
            child: Center(
              child: ClipOval(
                child: Image.asset(
                  //'assets/images/BBuddy_logo.png',
                  'assets/images/BBuddy_logo2.png', //replace with your image path
                  width: 280,
                  height: 280,
                  //fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
