import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:bbuddy_app/config/config.dart';
import 'package:bbuddy_app/core/core.dart';
import 'package:bbuddy_app/features/goal_app/services/service.dart';
import 'package:bbuddy_app/features/reflection_app/services/service.dart';
import 'package:bbuddy_app/features/check_in_app/services/service.dart';

final locator = GetIt.instance;

Future<void> setupDependencies() async {
  Provider.debugCheckInvalidValueType = null;
  String? token = await getIdToken();
  Map<String, dynamic> headers = token != null ? {'token': token} : {};

  locator.registerLazySingleton<Http>(
      () => Http(baseUrl: ApiEndpoint.baseURL, headers: headers));
  locator.registerLazySingleton<StatsService>(() => StatsService());
  locator.registerLazySingleton<CheckInService>(() => CheckInService());
  locator.registerLazySingleton<ReflectionService>(() => ReflectionService());
  locator.registerLazySingleton<GoalService>(() => GoalService());
}
