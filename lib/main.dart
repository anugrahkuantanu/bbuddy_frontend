import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/config.dart';
import 'features/auth_mod/services/service.dart';
import '/features/reflection_app/services/service.dart';
import '/features/main_app/services/service.dart';
import 'app.dart';

// void main() async {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ReflectionHeading()),
//         ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
//         ChangeNotifierProvider(create: (_) => UserDetailsProvider(),),
//         ChangeNotifierProvider(create: (_) => CounterStats()),
//         ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        
//       ],
//       child: ScreenUtilInit(
//         designSize: Size(375, 667), // Adjust based on your design
//         builder: (context, child) {
//           return AppStarter();
//         },
//       ),
//     ),
//   );
// }


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

