import '../../core/classes/route_manager.dart';
import 'controllers/controller.dart';
import '../checkIn_app/controllers/controller.dart';
import '../reflection_app/controllers/controller.dart';
import '../goal_app/controllers/controller.dart';

class App extends RouteManager {
  static const String name = '';
  static const String home = App.name + '/';
  // static const String chekIn = App.name + '/checkIn';
  // static const String reflection= App.name + '/reflections';
  // static const String goals = App.name + '/goals';

  App() {
    addRoute(App.home, (context) => const HomeController());
    // addRoute(App.chekIn, (context) => const CheckInHomeController());
    // addRoute(App.reflection, (context) => const ReflectionController());
    // addRoute(App.goals, (context) => const GoalsController());
  }
}
