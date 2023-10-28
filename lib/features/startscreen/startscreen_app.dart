import 'package:bbuddy_app/core/classes/route_manager.dart';
import 'package:bbuddy_app/features/startscreen/screen/agreement_screen.dart';
import 'package:bbuddy_app/features/startscreen/screen/introduction_screen.dart';

class StartscreenApp extends RouteManager {
  static const String name = '';
  static const String agreement = StartscreenApp.name + '/agreement';
  static const String intro = StartscreenApp.name + '/intro';

  StartscreenApp() {
    addRoute(StartscreenApp.agreement, (context) => const Agreementscreen());
    addRoute(StartscreenApp.intro, (context) => MyIntroScreen());
  }
}