import 'package:bbuddy_app/features/auth_firebase/screens/blocs/bloc.dart';
import 'package:bbuddy_app/features/auth_firebase/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/config.dart';
import '../core.dart';

// ignore: must_be_immutable
abstract class StatelessController extends StatelessWidget {
  const StatelessController({Key? key}) : super(key: key);

  bool get auth => false;

  String get loginUrl => ApiEndpoint.appLoginUrl;

  Display view(BuildContext context);

  @override
  Widget build(BuildContext context) {
    //LoginHelper.checkLogin(context, auth: auth, loginUrl: loginUrl);
    print("inside build");
    return BlocConsumer<AppBloc, AppState>(builder: (context, appState) {
      print('$appState');
      if (appState is AppStateLoggedIn) {
        return view(context);
      } else if (appState is AppStateLoggedOut && auth) {
        return const LoginController(); // Replace with your login view widget
      } else if (appState is AppStateIsInRegistrationView) {
        return const RegisterController();
      }
      return Container();
    }, listener: (context, appState) {
      loadingAndDisplayAuthError(context, appState);
    });
  }
}

// ignore: must_be_immutable
abstract class StatefulController extends StatefulWidget {
  const StatefulController({Key? key}) : super(key: key);
}

abstract class ControllerState<T extends StatefulController> extends State<T> {
  bool get auth => false;

  String get loginUrl => ApiEndpoint.appLoginUrl;

  Display view(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(builder: (context, appState) {
      if (appState is AppStateLoggedIn) {
        return view(context);
      } else if (appState is AppStateLoggedOut && auth) {
        return const LoginController(); // Replace with your login view widget
      } else if (appState is AppStateIsInRegistrationView) {
        return const RegisterController();
      }
      return Container();
    }, listener: (context, appState) {
      loadingAndDisplayAuthError(context, appState);
    });
  }
}
