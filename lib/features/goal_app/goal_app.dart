import '../../core/classes/route_manager.dart';
import 'controllers/controller.dart';

class GoalApp extends RouteManager {
  static const String name = '';
  static const String goals = GoalApp.name + '/goals';

  GoalApp() {
    addRoute(GoalApp.goals, (context) => const GoalsController());
  }
}
