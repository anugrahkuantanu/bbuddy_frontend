import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/config.dart';
import 'features/auth_mod/services/service.dart';
import '/features/reflection_app/services/service.dart';
import '/features/main_app/services/service.dart';
import 'app.dart';



void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReflectionHeading()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UserDetailsProvider(),),
        ChangeNotifierProvider(create: (_) => CounterStats()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],
      child: AppStarter(),
    ),
  );
}




// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var tm = context.watch<ThemeProvider>();

//     return Consumer<UserProvider>(
//       builder: (context, userProvider, _) {
//         if (userProvider.isLoggedIn != null) {
//           if (userProvider.isLoggedIn!) {
//             // User is logged in, navigate based on routes from RouteManager
//             return MaterialApp(
//               title: 'bbuddy',
//               debugShowCheckedModeBanner: false,
//               theme: MyTheme().lightTheme,
//               darkTheme: MyTheme().darkTheme,
//               themeMode: tm.themeMode,
//               initialRoute: App.home,  // Use App.home as the initial route
//               routes: Routes().routes,  // Get routes from the App class which extends RouteManager
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
//   }
// }
