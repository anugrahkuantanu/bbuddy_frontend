import 'package:bbuddy_app/core/classes/route_manager.dart';
import 'package:bbuddy_app/agreement_screen.dart';
import 'controllers/controllers.dart';

class AuthFirebaseApp extends RouteManager {
  static const String name = '';
  static const String login = AuthFirebaseApp.name + '/login';
  static const String register = AuthFirebaseApp.name + '/register';
  static const String profile = AuthFirebaseApp.name + '/profile';
  static const String forgetPassword = AuthFirebaseApp.name + '/forget_password';
  static const String intro = AuthFirebaseApp.name + '/agreement';

  AuthFirebaseApp() {
    addRoute(AuthFirebaseApp.login, (context) => const LoginController());
    addRoute(AuthFirebaseApp.register, (context) => const RegisterController());
    addRoute(AuthFirebaseApp.profile, (context) => const ProfileController());
    addRoute(AuthFirebaseApp.intro, (context) => const Agreementscreen());
    addRoute(AuthFirebaseApp.forgetPassword,
        (context) => const ForgetPasswordController());
  }
}
