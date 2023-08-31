import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/config.dart';
import 'features/auth_mod/services/service.dart';
import 'features/auth_mod/screens/screen.dart';
import 'features/main_app/app.dart';
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider>();
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.isLoggedIn != null) {
          if (userProvider.isLoggedIn!) {
            // User is logged in, navigate to the appropriate screen
            return MaterialApp(
              title: 'bbuddy',
              debugShowCheckedModeBanner: false,
              theme: MyTheme().lightTheme,
              darkTheme: MyTheme().darkTheme,
              themeMode: tm.themeMode,
              initialRoute: App.home, // Use the initial route from the App class
              routes: Routes().routes, // Use the routes from the Routes class
              onUnknownRoute: (settings) => MaterialPageRoute(builder: (_) => NotFoundScreen()),
            );
          } else {
            // User is not logged in, show login screen
            return MaterialApp(
              title: 'bbuddy',
              debugShowCheckedModeBanner: false,
              theme: MyTheme().lightTheme,
              darkTheme: MyTheme().darkTheme,
              themeMode: tm.themeMode,
              home: LoginPage(),
            );
          }
        } else {
          return Container(); // Return any placeholder while checking login status
        }
      },
    );
  }
}

class AppStarter extends StatelessWidget {
  final Color _primaryColor = HexColor('#FFF6EFEC');
  final Color _colorScheme = Color(0xFF2D425F);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp(
          title: 'BBuddy',
          theme: ThemeData(
            primaryColor: _primaryColor,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(primary: _colorScheme),
            scaffoldBackgroundColor: _colorScheme,
          ),
          home: SplashScreen(title: 'BBuddy'),
          debugShowCheckedModeBanner: false, // Remove the debug banner
        );
      },
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not Found'),
      ),
      body: Center(
        child: Text('404 - Page Not Found'),
      ),
    );
  }
}