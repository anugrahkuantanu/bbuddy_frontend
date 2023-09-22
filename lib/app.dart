import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'features/auth_firebase/screens/blocs/bloc.dart';
import 'features/auth_firebase/screens/screen.dart';
import 'features/auth_firebase/dialogs/dialog.dart';
import 'features/auth_firebase/loading/loading_screen.dart';
import 'features/main_app/controllers/controller.dart';
import 'config/config.dart';
import 'features/auth_firebase/screens/blocs/bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider?>();
    return ScreenUtilInit(
      builder: (context, child) {
        return BlocProvider<AppBloc>(
          create: (_) => AppBloc()
            ..add(
              const AppEventInitialize(),
            ),
          child: MaterialApp(
            title: 'Photo Library',
            // theme: ThemeData(
            //   primarySwatch: Colors.blue,
            // ),
            theme: MyTheme().lightTheme,
            darkTheme: MyTheme().darkTheme,
            themeMode: tm?.themeMode ?? ThemeMode.system,
            debugShowCheckedModeBanner: false,
            //initialRoute: '/',
            //routes: Routes().routes,
            home: BlocConsumer<AppBloc, AppState>(
              listener: (context, appState) {
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
              },
              builder: (context, appState) {
                if (appState is AppStateLoggedOut) {
                  return const LoginView();
                } else if (appState is AppStateLoggedIn) {
                  //return const PhotoGalleryView();
                  return const HomeController();
                } else if (appState is AppStateIsInRegistrationView) {
                  return const RegisterView();
                } else {
                  // this should never happen
                  return Container();
                }
              },

            ),
          ),
        );
      },
    );
  }
}
