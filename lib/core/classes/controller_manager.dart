import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:bbuddy_app/config/config.dart';
import 'package:bbuddy_app/core/core.dart';
import 'package:bbuddy_app/features/auth_firebase/blocs/bloc.dart';
import 'package:bbuddy_app/features/goal_app/blocs/bloc.dart';
import 'package:bbuddy_app/features/main_app/bloc/bloc.dart';
import 'package:bbuddy_app/features/reflection_app/blocs/bloc.dart';

// ignore: must_be_immutable
abstract class StatelessController extends StatelessWidget {
  const StatelessController({Key? key}) : super(key: key);

  bool get auth => false;

  String get loginUrl => ApiEndpoint.appLoginUrl;

  Display view(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(listener: (context, appState) {
      if (appState.authError == null && !appState.isLoading) {
        if (appState is AppStateLoggedIn) {
          // init stats (counterStats) provider
          final counterStats =
              Provider.of<CounterStats>(context, listen: false);
          counterStats.checkCounterStats();

          // init check in history bloc
          context.read<CheckInHistoryBloc>().add(FetchCheckInHistoryEvent());

          // init reflection bloc
          context
              .read<ReflectionHomeBloc>()
              .add(InitializeReflectionHomeEvent());
          // init goal bloc
          final goalBloc = context.read<GoalBloc>();
          goalBloc.add(LoadGoals());
          goalBloc.add(CountReflections());

          //Navigation to the main app
          Nav.toNamed(context, '/');
        } else if (appState is AppStateLoggedOut) {
          Nav.toNamed(context, '/login');
        } else if (appState is AppStateIsInRegistrationView) {
          Nav.toNamed(context, '/register');
        }
        hideLoading(context, appState);
      } else if (appState.isLoading || appState.authError != null) {
        loadingAndDisplayAuthError(context, appState);
      }
    }, builder: (context, appState) {
      return view(context);
    });
  }
}
