//TEST FIREBASE
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'package:provider/provider.dart';
import 'config/config.dart';
import 'features/auth_mod/services/service.dart';
import '/features/main_app/services/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth_firebase/screens/blocs/bloc.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyAvbdc-AC1ZBqdoQMLCIYRXBRDGVVrps3M',
      appId: '1:528052100662:web:3c890e8b4cb21866ea4297',
      messagingSenderId: '528052100662',
      projectId: 'bbuddy-c1de3',
      authDomain: 'bbuddy-c1de3.firebaseapp.com',
      storageBucket: 'bbuddy-c1de3.appspot.com',
    ));
  }
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => ReflectionHeading()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (_) => UserDetailsProvider(),
        ),
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
  // runApp(
  //   const MyApp(),
  // );
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




