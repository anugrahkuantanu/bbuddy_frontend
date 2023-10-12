import '../../core/classes/route_manager.dart';
import 'controllers/controller.dart';


class App extends RouteManager {
  static const String name = '';
  static const String home = App.name + '/';

  App() {
    addRoute(App.home, (context) => const HomeController());
  }
}
