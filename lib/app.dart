import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/config.dart';
import 'features/auth_mod/services/service.dart';
import 'features/auth_mod/screens/screen.dart';
 

 
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider>();
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.isLoggedIn != null){
          if (userProvider.isLoggedIn!) {
            // User is logged in, navigate to the HomeScreen
            return MaterialApp(
              title: 'bbuddy',
              debugShowCheckedModeBanner: false,
              theme: MyTheme().lightTheme,
              darkTheme: MyTheme().darkTheme,
              themeMode: tm.themeMode,
              initialRoute: '/',  // Use App.home as the initial route
              routes: Routes().routes,  // Get routes from the App class which extends RouteManager
            );
          } else {
            // User is not logged in, navigate to the LoginScreen
            return LoginPage();
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class AppStarter extends StatelessWidget {
  final Color _primaryColor = HexColor('#FFF6EFEC');
  final Color _colorScheme = Color(0xFF2D425F); 
  //final Color _colorScheme = HexColor('#FF404659');

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      //designSize: Size(375, 812), // iPhone X design size
      builder: (context, child)  { 
        return MaterialApp(
        title: 'BBuddy',
        theme: ThemeData(
          primaryColor: _primaryColor,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
              .copyWith(primary: _colorScheme),
          scaffoldBackgroundColor: _colorScheme,
        ),
        home: SplashScreen(title: 'BBuddy'),
        debugShowCheckedModeBanner: false, // Remove the debug banner
      );
      },
    );
  }
}

