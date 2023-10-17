import 'dart:async';
import 'package:bbuddy_app/app.dart';
import 'package:flutter/material.dart';
import '../widgets/widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;
  late Timer _navigationTimer;
  late Timer _visibilityTimer;

  @override
  void initState() {
    super.initState();

    _navigationTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MyApp()),
            (route) => false,
          );
        });
      }
    });

    _visibilityTimer = Timer(const Duration(milliseconds: 10), () {
      if (mounted) {
        setState(() {
          _isVisible = true; 
        });
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer.cancel();
    _visibilityTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
        duration: const Duration(milliseconds: 1200),
        child: Center(
          child: Container(
            height: 300.0,
            width: 300.0,
            child: LoginLogo(width: 280, height:280),
          ),
        ),
      ),
    );
  }
}
