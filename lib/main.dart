import 'package:bbuddy_app/di/di.dart';
import 'package:bbuddy_app/features/goal_app/screens/blocs/goal_bloc/goal_bloc.dart';
import 'package:bbuddy_app/features/goal_app/screens/blocs/goal_bloc/goal_event.dart';
import 'package:bbuddy_app/features/goal_app/services/goal.dart';
import 'package:bbuddy_app/features/reflection_app/screens/blocs/reflection_home_bloc/reflection_home_bloc.dart';
import 'package:bbuddy_app/features/reflection_app/screens/blocs/reflection_home_bloc/reflection_home_event.dart';
import 'package:bbuddy_app/features/reflection_app/services/reflections.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bbuddy_app/app.dart';
import 'package:provider/provider.dart';
import 'package:bbuddy_app/config/config.dart';
import 'features/auth_mod/services/service.dart';
import '/features/main_app/services/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth_firebase/screens/blocs/bloc.dart';
import 'package:bbuddy_app/features/main_app/screens/mobile/checkin_history_card.dart';
import 'features/check_in_app/services/service.dart';

Future main() async {
  // ignore: unused_local_variable
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
  setupDependencies();
  runApp(
    MultiProvider(
      providers: [
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
        BlocProvider<CheckInHistoryBloc>(
            create: (_) => CheckInHistoryBloc(locator.get<CheckInService>())),
        BlocProvider<ReflectionHomeBloc>(
          create: (context) => ReflectionHomeBloc(
            checkInService: locator.get<CheckInService>(),
            reflectionService: locator.get<ReflectionService>(),
          )..add(InitializeReflectionHomeEvent()),
        ),
        BlocProvider<GoalBloc>(
          create: (context) => GoalBloc(
            counterStats: context.read<CounterStats>(),  // Correctly accessing CounterStats
            goalService: locator.get<GoalService>(),
            reflectionService: locator.get<ReflectionService>(),
          )..add(LoadGoals())..add(CountReflections()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
