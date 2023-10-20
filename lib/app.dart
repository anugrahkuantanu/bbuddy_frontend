import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:bbuddy_app/config/config.dart';
import 'package:bbuddy_app/core/core.dart';

// main app
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider>();
    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp(
          title: 'bbuddy',
          theme: MyTheme().lightTheme,
          darkTheme: MyTheme().darkTheme,
          themeMode: tm.themeMode,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: Routes().routes,
        );
      },
    );
  }
}

// splash
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white, // or any color you prefer
        body: Center(
          child: Logo(width: 280, height: 280),
        ),
      ),
    );
  }
}
