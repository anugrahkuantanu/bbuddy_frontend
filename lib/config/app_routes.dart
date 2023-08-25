import '../core/classes/route_manager.dart';
import '../features/auth_mod/auth_app.dart';
import '../features/main_app/app.dart';
import '../features/check_in_app/checkIn_app.dart';
import '../features/reflection_app/reflection_app.dart';
import '../features/goal_app/goal_app.dart';


class Routes extends RouteManager {
  Routes() {
    addAll(AuthApp().routes);
    addAll(App().routes);
    addAll(CheckInApp().routes);
    addAll(GoalApp().routes);
    addAll(ReflectionApp().routes);
  }
}
