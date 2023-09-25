import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bbuddy_app/features/auth_firebase/screens/blocs/bloc.dart';
import 'package:bbuddy_app/features/auth_firebase/loading/loading_screen.dart';
import 'package:bbuddy_app/features/auth_firebase/dialogs/dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// void doAuth(BuildContext context, String username, String password) async {
//   AppCache ac = AppCache();
//   ac.doLogin(username, password);
//   if (await ac.isLogin()) {
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       Nav.to(context, '/');
//       showMessage(context, 'Login Successful');
//     });
//   }
// }

// Future<Map<String, String>> authData() async {
//   AppCache ac = AppCache();
//   return ac.auth();
// }

// class LoginHelper {
//   static void checkLogin(BuildContext context,
//       {bool? auth = false, String? loginUrl = ApiEndpoint.appLoginUrl}) {
//     final appBloc = BlocProvider.of<AppBloc>(context);
//     appBloc.stream.listen((state) {
//       if (state is AppStateLoggedOut && auth! == true) {
//         Nav.to(context, loginUrl!);
//       } else if (state is AppStateLoggedIn) {
//         //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
//         Nav.to(context, '/');
//       }
//     });
//   }
// }

void doLogout(BuildContext context) async {
  context.read<AppBloc>().add(const AppEventLogOut());
}

// void checkLogin(
//   BuildContext context, {
//   bool? auth = false,
//   String? loginUrl = ApiEndpoint.appLoginUrl,
// }) {
//   AppCache ac = AppCache();
//   ac.isLogin().then((value) {
//     if (value == false && auth! == true) {
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         Nav.to(context, loginUrl!);
//       });
//     }
//   });
// }

// final appBloc = BlocProvider.of<AppBloc>(context);
// return BlocConsumer<AppBloc, AppState>(
//   listener: (context, appState) {
//     print("Yes");
//     print(appState);
//     if (appState.isLoading) {
//       LoadingScreen.instance().show(
//         context: context,
//         text: 'Loading...',
//       );
//     } else {
//       LoadingScreen.instance().hide();
//     }

//     final authError = appState.authError;
//     if (authError != null) {
//       showAuthError(
//         authError: authError,
//         context: context,
//       );
//     }
//   },
//   builder: (context, appState) {
//     if (appState is AppStateLoggedOut && auth == true) {
//       //Nav.to(conext, )
//     } else if (appState is AppStateLoggedIn) {
//       //return const PhotoGalleryView();
//       Nav.to(context, '/');
//     } else if (appState is AppStateIsInRegistrationView) {
//       //return const RegisterView();
//     } else {
//       // this should never happen
//       //return Container();
//     }
//     return Container();
//   },
// );

void loadingAndDisplayAuthError(BuildContext context, AppState appState) {
  if (appState.isLoading) {
    LoadingScreen.instance().show(
      context: context,
      text: 'Loading...',
    );
  } else {
    LoadingScreen.instance().hide();
  }

  final authError = appState.authError;
  if (authError != null) {
    showAuthError(
      authError: authError,
      context: context,
    );
  }
}

void hideLoading(BuildContext context, AppState appState) {
  if (!appState.isLoading) {
    LoadingScreen.instance().hide();
  }
}

Future<String?> getIdToken() async {
  String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
  return token;
}
