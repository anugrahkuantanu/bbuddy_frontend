import 'package:bbuddy_app/features/auth_firebase/screens/mobile/login_screen.dart';
import 'package:bbuddy_app/features/auth_firebase/screens/mobile/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
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


// class AppStarter extends StatelessWidget {
//   final Color _primaryColor = HexColor('#FFF6EFEC');
//   final Color _colorScheme = HexColor('#FF404659');

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       builder: (context, child) {
//         return MaterialApp(
//           title: 'BBuddy',
//           theme: ThemeData(
//             primaryColor: _primaryColor,
//             colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
//                 .copyWith(primary: _colorScheme),
//             scaffoldBackgroundColor: Color(0xFFF6EFEC),
//           ),
//           home: SplashScreen(title: 'BBuddy'),
//           debugShowCheckedModeBanner: false,
//         );
//       },
//     );
//   }
// }
