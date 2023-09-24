import 'package:bbuddy_app/core/classes/route_manager.dart';
import 'controllers/controllers.dart';

class AuthFirebaseApp extends RouteManager {
  static const String name = '';
  static const String login = AuthFirebaseApp.name + '/login';
  static const String register = AuthFirebaseApp.name + '/register';
  AuthFirebaseApp() {
    addRoute(AuthFirebaseApp.login, (context) => const LoginController());
    addRoute(AuthFirebaseApp.register, (context) => const RegisterController());
  }
}
