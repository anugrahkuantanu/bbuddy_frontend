import 'package:flutter/material.dart';

class LoginLogo extends StatelessWidget {
  final double? height;
  final double? width;

  LoginLogo({this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ClipOval(
          child: Image.asset(
            'assets/images/BBuddy_logo2.png',
            width: width ?? 180,
            height: height ?? 180,
          ),
        ),
      ),
    );
  }
}
