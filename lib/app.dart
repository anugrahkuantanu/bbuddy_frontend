import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
// import 'features/auth_firebase/screens/blocs/bloc.dart';
import 'config/config.dart';

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

