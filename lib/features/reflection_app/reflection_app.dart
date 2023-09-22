import '../../core/classes/route_manager.dart';
import 'controllers/controller.dart';

class ReflectionApp extends RouteManager {
  static const String name = '';
  static const String reflection = ReflectionApp.name + '/reflections';

  ReflectionApp() {
    addRoute(
        ReflectionApp.reflection, (context) => const ReflectionController());
  }
}
