import 'package:bbuddy_app/di/di.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bbuddy_app/app.dart';
import 'package:provider/provider.dart';
import 'package:bbuddy_app/config/config.dart';
Future main() async {
  // ignore: unused_local_variable
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
  setupDependencies();
  runApp(
    MultiProvider(
      providers: appProviders,
      // child: const MyApp(),
      child: AppStarter(),
    ),
  );
}
