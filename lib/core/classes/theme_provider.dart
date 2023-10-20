import 'package:flutter/material.dart';

class BaseThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void setThemeMode(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}


// import 'dart:async';

// class ThemeBloc {
//   // 1. Define the stream controller and stream for theme mode
//   final _themeController = StreamController<ThemeMode>();
//   Stream<ThemeMode> get themeStream => _themeController.stream;

//   // 2. Define the sink for theme change requests
//   final _setThemeController = StreamController<bool>();
//   Sink<bool> get setThemeSink => _setThemeController.sink;

//   ThemeBloc() {
//     // Default theme is light
//     _themeController.add(ThemeMode.light);

//     // Whenever there's a new value in _setThemeController, update the theme
//     _setThemeController.stream.listen((isDark) {
//       _themeController.add(isDark ? ThemeMode.dark : ThemeMode.light);
//     });
//   }

//   void dispose() {
//     _themeController.close();
//     _setThemeController.close();
//   }
// }


// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Provider<ThemeBloc>(
//       create: (context) => ThemeBloc(),
//       dispose: (context, bloc) => bloc.dispose(),
//       child: MaterialApp(
//         title: 'BLoC Theme Management',
//         home: MyHomePage(),
//       ),
//     );
//   }
// }


// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final themeBloc = Provider.of<ThemeBloc>(context);

//     return StreamBuilder<ThemeMode>(
//       stream: themeBloc.themeStream,
//       builder: (context, snapshot) {
//         return MaterialApp(
//           themeMode: snapshot.data,
//           darkTheme: ThemeData.dark(),
//           theme: ThemeData.light(),
//           home: Scaffold(
//             body: Center(
//               child: Switch(
//                 value: snapshot.data == ThemeMode.dark,
//                 onChanged: (value) {
//                   themeBloc.setThemeSink.add(value);
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
