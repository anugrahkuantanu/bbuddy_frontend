import 'package:bbuddy_app/core/classes/route_manager.dart';
// import 'package:bbuddy_app/features/auth_firebase/screens/mobile/splash_screen.dart';
import 'controllers/controllers.dart';

class AuthFirebaseApp extends RouteManager {
  static const String name = '';
  static const String login = AuthFirebaseApp.name + '/login';
  static const String register = AuthFirebaseApp.name + '/register';
  static const String profile = AuthFirebaseApp.name + '/profile';
    static const String forget_password = AuthFirebaseApp.name + '/forget_password';

  AuthFirebaseApp() {
    addRoute(AuthFirebaseApp.login, (context) => const LoginController());
    addRoute(AuthFirebaseApp.register, (context) => const RegisterController());
    addRoute(AuthFirebaseApp.profile, (context) => const ProfileController());
    addRoute(AuthFirebaseApp.forget_password, (context) => const ForgetPasswordController());
  }
}

