import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '/config/config.dart';
import '../../goal_app/services/dio_util.dart';
import '../models/reflection.dart';

Future<List> getReflectionTopics() async {
  final dio = Dio(BaseOptions(baseUrl: ApiEndpoint.baseURL));
  dio.interceptors.add(AuthInterceptor(dio));

  try {
    final response = await dio.get(
      '/reflection_topics',
      //queryParameters: {'session_id': session_id},
    );
    if (response.statusCode == 200) {
      return response.data["questions"];
    } else {
      throw Exception('Failed to load check-ins');
    }
  } catch (e) {
    throw Exception('Failed to load check-ins: $e');
  }
}

Future<List<Reflection>> getReflectionHistory(
    {DateTime? startDate, DateTime? endDate}) async {
  final dio = Dio(BaseOptions(baseUrl: ApiEndpoint.baseURL));
  // code here
  dio.interceptors.add(AuthInterceptor(dio));
  try {
    final response = await dio.get(
      '/reflection_history',
      queryParameters: {
        'start_date': startDate?.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> reflectionsJson = response.data;
      final List<Reflection> reflections = reflectionsJson
          .map((reflectionJson) => Reflection.fromJson(reflectionJson))
          .toList();
      return reflections;
    } else {
      throw Exception('Failed to load reflections');
    }
  } catch (e) {
    throw Exception('Failed to load reflections: $e');
  }
}

Future<Reflection> getMoodReflections(
    List topics, List? userReflections, String heading) async {
  final dio = Dio(BaseOptions(baseUrl: ApiEndpoint.baseURL));
  dio.interceptors.add(AuthInterceptor(dio));
  final response = await dio.post(
    '/mood_reflection',
    data: {
      'topics': topics,
      'user_reflections': userReflections,
      'heading': heading
    },
  );

  final responseData = Map<String, dynamic>.from(response.data);

  return Reflection.fromJson(responseData);
}

class ReflectionHeading extends ChangeNotifier {
  String heading = '';

  String get result => heading;

  final dio = Dio();

  Future<void> fetchHeading(List topics) async {
    final response = await dio.post(
      '$ApiEndpoint.baseURL/reflection_heading',
      data: {'topics': topics},
    );
    if (response.statusCode == 200) {
      heading = response.data["heading"];
      notifyListeners();
    } else {
      throw Exception('Failed to load data');
    }
  }
}

Future<int> countReflections() async {
  final dio = Dio(BaseOptions(baseUrl: ApiEndpoint.baseURL));
  dio.interceptors.add(AuthInterceptor(dio));
  try {
    final response = await dio.get('/count_reflections');
    if (response.statusCode == 200) {
      return response.data as int;
    } else {
      throw Exception('Failed to load check-ins');
    }
  } catch (e) {
    throw Exception('Failed to load check-ins: $e');
  }
}
