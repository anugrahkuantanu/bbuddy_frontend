//TEST FIREBASE
import 'dart:convert';

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
import 'features/check_in_app/screens/bloc/checkIn_home_bloc/checkIn_home_bloc.dart';
import 'features/check_in_app/screens/bloc/feelings_form_bloc/feeling_form_bloc.dart';
import 'features/check_in_app/services/checkIn_service.dart';
import 'features/goal_app/models/goal.dart';
import 'features/goal_app/screens/blocs/goal_bloc/goal_bloc.dart';
import 'features/goal_app/screens/blocs/progress_bloc/progress_bloc.dart';
import 'features/goal_app/screens/blocs/progress_bloc/progress_state.dart';
import 'features/reflection_app/screens/blocs/reflection_home_bloc/reflection_home_bloc.dart';
import 'features/reflection_app/screens/blocs/reflection_home_bloc/reflection_home_state.dart';

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
    MultiBlocProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => ReflectionHeading()),
        BlocProvider<FeelingBloc>(create: (context) => FeelingBloc()),
        BlocProvider<GoalBloc>(create: (context) => GoalBloc(counterStats: CounterStats())),
        BlocProvider<ReflectionHomeBloc>(create: (context) => ReflectionHomeBloc(checkInService: CheckInService())),
        BlocProvider<AppBloc>(
            create: (_) => AppBloc()
              ..add(
                const AppEventInitialize(),
              )),
        ],
      child:  MultiProvider(
      providers: [
         ChangeNotifierProvider(create: (_) => CounterStats()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
         ChangeNotifierProvider(
          create: (_) => UserDetailsProvider(),
         ),
      ],
        
      
      child: const MyApp(),
    ),
  )
  );
  // runApp(
  //   const MyApp(),
  // );
}







