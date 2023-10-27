import 'package:bbuddy_app/features/auth_firebase/auth_firebase_app.dart';
import 'package:bbuddy_app/features/startscreen/startscreen_app.dart';

import '../core/classes/route_manager.dart';
import '../features/main_app/app.dart';
import '../features/check_in_app/checkIn_app.dart';
import '../features/reflection_app/reflection_app.dart';
import '../features/goal_app/goal_app.dart';
import 'package:flutter/widgets.dart';

class Routes extends RouteManager {
  Routes() {
    //addAll(AuthApp().routes);
    addAll(AuthFirebaseApp().routes);
    addAll(StartscreenApp().routes);
    addAll(App().routes);
    addAll(CheckInApp().routes);
    addAll(GoalApp().routes);
    addAll(ReflectionApp().routes);
  }

  WidgetBuilder? getRoute(String? routeName) {
    return routes[routeName];
  }
}
