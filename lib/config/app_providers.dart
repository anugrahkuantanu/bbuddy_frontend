import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:bbuddy_app/core/core.dart';
import 'package:bbuddy_app/config/config.dart';
import 'package:bbuddy_app/di/di.dart';

import 'package:bbuddy_app/features/check_in_app/services/service.dart';
import 'package:bbuddy_app/features/goal_app/services/service.dart';
import 'package:bbuddy_app/features/goal_app/services/goal.dart';
import 'package:bbuddy_app/features/reflection_app/services/service.dart';

import 'package:bbuddy_app/features/main_app/bloc/bloc.dart';
import 'package:bbuddy_app/features/reflection_app/blocs/bloc.dart';
import 'package:bbuddy_app/features/auth_firebase/blocs/bloc.dart';
import 'package:bbuddy_app/features/goal_app/blocs/bloc.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider<ThemeProvider>(
    create: (context) => ThemeProvider(),
  ),
  ChangeNotifierProvider<GlobalStateManager>(
    create: (context) => GlobalStateManager(),
  ),
  ChangeNotifierProvider(
      create: (_) => CounterStats(statsService: locator.get<StatsService>())),
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
    ),
  ),
  BlocProvider<GoalBloc>(
      create: (context) => GoalBloc(
            counterStats: context
                .read<CounterStats>(), // Correctly accessing CounterStats
            goalService: locator.get<GoalService>(),
            reflectionService: locator.get<ReflectionService>(),
          )),
];
