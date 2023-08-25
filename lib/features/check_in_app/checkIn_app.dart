import '../../core/classes/route_manager.dart';
import 'controllers/controller.dart';

class CheckInApp extends RouteManager {
  static const String name = '';
  static const String chekIn = CheckInApp.name + '/checkIn';

  CheckInApp() {
    addRoute(CheckInApp.chekIn, (context) => const CheckInHomeController());
  }
}
