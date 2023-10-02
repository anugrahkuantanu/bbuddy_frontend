import 'package:bbuddy_app/features/auth_firebase/blocs/app_bloc.dart';
import 'package:bbuddy_app/features/auth_firebase/blocs/app_event.dart';
import 'package:bbuddy_app/features/auth_mod/services/login.dart';
import 'package:bbuddy_app/features/check_in_app/services/checkin_service.dart';
import 'package:bbuddy_app/features/main_app/bloc/checkin_history_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../core/core.dart';
import 'app_theme.dart';
import 'package:bbuddy_app/di/di.dart';
import 'package:bbuddy_app/features/goal_app/blocs/goal_bloc/goal_bloc.dart';
import 'package:bbuddy_app/features/goal_app/blocs/goal_bloc/goal_event.dart';
import 'package:bbuddy_app/features/goal_app/services/goal.dart';
import 'package:bbuddy_app/features/reflection_app/blocs/reflection_home_bloc/reflection_home_bloc.dart';
import 'package:bbuddy_app/features/reflection_app/blocs/reflection_home_bloc/reflection_home_event.dart';
import 'package:bbuddy_app/features/reflection_app/services/reflections.dart';
import 'package:bbuddy_app/config/config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider<ThemeProvider>(
    create: (context) => ThemeProvider(),
  ),
  ChangeNotifierProvider<GlobalStateManager>(
    create: (context) => GlobalStateManager(),
  ),
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
];
