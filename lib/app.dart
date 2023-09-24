import 'package:bbuddy_app/architect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
// import 'features/auth_firebase/screens/blocs/bloc.dart';
import 'features/auth_firebase/screens/blocs/bloc.dart';
import 'features/auth_firebase/screens/screen.dart';
import 'features/auth_firebase/dialogs/dialog.dart';
import 'features/auth_firebase/loading/loading_screen.dart';
import 'features/main_app/controllers/controller.dart';
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
        );
      },
    );
  }
}


class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not Found'),
      ),
      body: Center(
        child: Text('404 - Page Not Found'),
      ),
    );
  }
}


// class MyApp extends StatelessWidget {
//   const MyApp({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var tm = context.watch<ThemeProvider?>();
//     return ScreenUtilInit(
//       builder: (context, child) {
//         return BlocProvider<AppBloc>(
//           create: (_) => AppBloc()
//             ..add(
//               const AppEventInitialize(),
//             ),
//           child: MaterialApp(
//             title: 'Photo Library',
//             debugShowCheckedModeBanner: false,
//             theme: MyTheme().lightTheme,
//             darkTheme: MyTheme().darkTheme,
//             themeMode: tm?.themeMode ?? ThemeMode.system,
//             initialRoute: '/',
//             onGenerateRoute: (settings) {
//               var routeBuilder = Routes().getRoute(settings.name);
//               if (routeBuilder != null) {
//                 return MaterialPageRoute(builder: routeBuilder);
//               }
//               return MaterialPageRoute(builder: (_) => NotFoundScreen());
//             },
//             onUnknownRoute: (settings) => MaterialPageRoute(builder: (_) => NotFoundScreen()),
//             home: BlocConsumer<AppBloc, AppState>(
//               listener: (context, appState) {
//                 if (appState.isLoading) {
//                   LoadingScreen.instance().show(
//                     context: context,
//                     text: 'Loading...',
//                   );
//                 } else {
//                   LoadingScreen.instance().hide();
//                 }

//                 final authError = appState.authError;
//                 if (authError != null) {
//                   showAuthError(
//                     authError: authError,
//                     context: context,
//                   );
//                 }
//               },
//               builder: (context, appState) {
//                 if (appState is AppStateLoggedOut) {
//                   return const LoginView();
//                 } else if (appState is AppStateLoggedIn) {
//                   return const HomeController();
//                 } else if (appState is AppStateIsInRegistrationView) {
//                   return const RegisterView();
//                 } 
//                 return Container();
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }





// class MyApp extends StatelessWidget {
//   const MyApp({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var tm = context.watch<ThemeProvider?>();
//     return ScreenUtilInit(
//       builder: (context, child) {
//         return BlocProvider<AppBloc>(
//           create: (_) => AppBloc()
//             ..add(
//               const AppEventInitialize(),
//             ),
//           child: MaterialApp(
//             title: 'bbuddy',
//             theme: MyTheme().lightTheme,
//             darkTheme: MyTheme().darkTheme,
//             themeMode: tm?.themeMode ?? ThemeMode.system,
//             debugShowCheckedModeBanner: false,
//             initialRoute: '/',
//             routes: Routes().routes,
//             home: BlocConsumer<AppBloc, AppState>(
//               listener: (context, appState) {
//                 if (appState.isLoading) {
//                   LoadingScreen.instance().show(
//                     context: context,
//                     text: 'Loading...',
//                   );
//                 } else {
//                   LoadingScreen.instance().hide();
//                 }

//                 final authError = appState.authError;
//                 if (authError != null) {
//                   showAuthError(
//                     authError: authError,
//                     context: context,
//                   );
//                 }
//               },
//               builder: (context, appState) {
//                 if (appState is AppStateLoggedOut) {
//                   return const LoginView();
//                 } else if (appState is AppStateLoggedIn) {
//                   //return const PhotoGalleryView();
//                   // return const HomeController();
//                   Nav.to(context,'/');
//                 } else if (appState is AppStateIsInRegistrationView) {
//                   return const RegisterView();
//                 } 
//                 return Container();
//               },

//             ),
//           ),
//         );
//       },
//     );
//   }
// }

