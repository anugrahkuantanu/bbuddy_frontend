//TEST FIREBASE
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './firebase_options.dart';
import 'app.dart';
import 'package:provider/provider.dart';
import 'config/config.dart';
import 'features/auth_mod/services/service.dart';
import '/features/main_app/services/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth_firebase/screens/blocs/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      providers: [
        // Other providers
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UserDetailsProvider()),
        ChangeNotifierProvider(create: (_) => CounterStats()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        BlocProvider<AppBloc>(
            create: (_) => AppBloc()
              ..add(
                const AppEventInitialize(),
              )),
      ],
      child: const MyApp(),
    ),
  );
}




// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   Provider.debugCheckInvalidValueType = null;
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ReflectionHeading()),
//         ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
//         ChangeNotifierProvider(create: (_) => UserDetailsProvider(),),
//         ChangeNotifierProvider(create: (_) => CounterStats()),
//         ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
//       ],
//       child: AppStarter(),
//     ),
//   );
// }


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   Provider.debugCheckInvalidValueType = null;
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
//         ChangeNotifierProvider(create: (_) => UserDetailsProvider(),),
//         ChangeNotifierProvider(create: (_) => CounterStats()),
//         ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
//       ],
//       child: AppStarter(),
//     ),
//   );
// }




