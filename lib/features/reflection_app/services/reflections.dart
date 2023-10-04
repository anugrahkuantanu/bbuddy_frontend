import 'dart:convert';

import 'package:bbuddy_app/core/core.dart';
import 'package:bbuddy_app/di/di.dart';
import 'package:dio/dio.dart';
import 'package:bbuddy_app/config/config.dart';
import '../../../core/classes/dio_util.dart';
import 'package:bbuddy_app/features/reflection_app/models/reflection.dart';

class ReflectionService {
  final http = locator.get<Http>();

  Future<List> getReflectionTopics() async {
    try {
      final response = await http.get(
        '/reflection_topics',
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
    try {
      final response = await http.get(
        '/reflection_history',
        params: {
          'start_date': startDate?.toIso8601String(),
          'end_date': endDate?.toIso8601String(),
        },
      );
      if (response.statusCode == 200) {
        if (response.data is! List) {
          throw Exception('Unexpected data format received');
        }
        final List<dynamic> reflectionsJson = response.data as List<dynamic>;
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
    final response = await http.post('/mood_reflection',
        data: jsonEncode(
          {
            'topics': topics,
            'user_reflections': userReflections,
            'heading': heading
          },
        ));

    final responseData = Map<String, dynamic>.from(response.data);
    // print(responseData);
    // const responseData = {"heading": "Anxiety and Frustration in School", "topic_reflections": [{"topic": "What is causing me to feel anxious and confused about my School?", "human_insight": {"content": ""}, "ai_insights": [{"content":
    //                       "You are feeling overwhelmed by the pressures of school and money."}, {"content": "It is important to take time to manage your stress and emotions."}]}, {"topic": 
    //                       "What is causing me to feel angry and frustrated about my School?", "human_insight": {"content": ""}, "ai_insights": [{"content": 
    //                       "You are feeling overwhelmed by the demands of school and money."}, {"content": "It is understandable to feel frustrated and angry when faced with these pressures."}]}]};

    return Reflection.fromJson(responseData);
  }




  Future<int> countReflections() async {
    try {
      final response = await http.get('/count_reflections');
      if (response.statusCode == 200) {
        return response.data as int;
      } else {
        throw Exception('Failed to load check-ins');
      }
    } catch (e) {
      throw Exception('Failed to load check-ins: $e');
    }
  }
}

