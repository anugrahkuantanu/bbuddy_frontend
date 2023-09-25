import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
// import 'features/auth_firebase/screens/blocs/bloc.dart';
import 'config/config.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider>();
    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp(
          title: 'bbuddy',
          theme: MyTheme().lightTheme,
          darkTheme: MyTheme().darkTheme,
          themeMode: tm.themeMode,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: Routes().routes,
        );
      },
    );
  }
}


// home: BlocConsumer<AppBloc, AppState>(
          //   listener: (context, appState) {
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
          //     if (appState is AppStateLoggedOut) {
          //       return const LoginView();
          //     } else if (appState is AppStateLoggedIn) {
          //       //return const PhotoGalleryView();
          //       return const HomeController();
          //     } else if (appState is AppStateIsInRegistrationView) {
          //       return const RegisterView();
          //     } else {
          //       // this should never happen
          //       return Container();
          //     }
          //   },
          // ),