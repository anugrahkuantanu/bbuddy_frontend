import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/config.dart';
import '/features/auth_mod/screens/mobile/login_screen/login_page.dart';
import '/features/auth_mod/services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;

  runApp(MultiProvider(
    providers: appProviders,
    child: const MyApp(),
  ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     var tm = context.watch<ThemeProvider>();

//         return Consumer<UserProvider>(
//       builder: (context, userProvider, _) {
//         if (userProvider.isLoggedIn != null){
//           if (userProvider.isLoggedIn!) {
//             // User is logged in, navigate to the HomeScreen
//             return MaterialApp(
//               title: 'bbuddy',
//               debugShowCheckedModeBanner: false,
//               theme: MyTheme().lightTheme,
//               darkTheme: MyTheme().darkTheme,
//               themeMode: tm.themeMode,
//               initialRoute: '/',
//               routes: Routes().routes,
//             );
//           } else {
//             // User is not logged in, navigate to the LoginScreen
//             return LoginPage();
//           }
//         } else {
//           return Container();
//         }
//       },
//     );
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider>();

    return MaterialApp(
        title: 'bbuddy',
        debugShowCheckedModeBanner: false,
        theme: MyTheme().lightTheme,
        darkTheme: MyTheme().darkTheme,
        themeMode: tm.themeMode,
        initialRoute: '/',
        routes: Routes().routes,
      );
  }
}

