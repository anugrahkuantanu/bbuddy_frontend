import 'package:bbuddy_app/features/auth_firebase/auth_firebase_app.dart';

/// In this file we will be writing all API Endpoints using this application

class ApiEndpoint {
  // static const String baseURL = 'http://localhost:8000';
  static const String baseURL = 'https://api.bbuddy.ai';
  // static const String baseWSURL = 'ws://localhost:8000/ws';
  static const String baseWSURL = 'wss://api.bbuddy.ai';

  // Apps Internals Links
  static const appLoginUrl = AuthFirebaseApp.login;
  //static const appRegiaterUrl = AuthApp.register;
  //static const appForgetUrl = AuthApp.forget;
  //static const appProfileUrl = AuthApp.profile;
}
