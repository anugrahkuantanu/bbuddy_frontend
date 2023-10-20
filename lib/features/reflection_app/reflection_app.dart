import 'package:bbuddy_app/features/reflection_app/models/reflection.dart';
import 'package:flutter/material.dart';

import '../../core/classes/route_manager.dart';
import 'controllers/controller.dart';

class ReflectionApp extends RouteManager {
  static const String name = '';
  static const String reflection = ReflectionApp.name + '/reflections';
  static const String newreflection = ReflectionApp.name + '/newreflections';
  static const String viewreflection = ReflectionApp.name + '/viewreflections';

  ReflectionApp() {
    addRoute(ReflectionApp.reflection, (context) => const ReflectionController());
    // addRoute(ReflectionApp.reflection, (context) => const ReflectionController());
      addRoute(ReflectionApp.newreflection, (context) {
      final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final List<dynamic> topics = args['topics'];
      return NewReflectionController(topics: topics);
    });

    addRoute(ReflectionApp.viewreflection, (context) {
      // Retrieve the arguments.
      final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      // Extract the parameters.
      final List<dynamic> topics = args['topics'];
      final List? userReflections = args['userReflections'];
      final Reflection? reflection = args['reflection'];

      // Pass the parameters to ViewReflectionController.
      return ViewReflectionController(
        topics: topics,
        userReflections: userReflections,
        reflection: reflection,
      );
    });
  }
}
