import 'dart:convert';

import 'package:dio/dio.dart';
import '/core/services/constants.dart';
import '/core/services/dio_util.dart';
import '../../features/checkIn_app/models/main/goal.dart';
import '../../features/checkIn_app/models/message.dart';
import 'package:flutter/material.dart';

Future<List<Goal>> getGoalHistory() async {
  final dio = Dio(BaseOptions(baseUrl: baseURL));
  // code here
  dio.interceptors.add(AuthInterceptor(dio));
  try {
    final response = await dio.get(
      '/goal_history',
    );
    if (response.statusCode == 200) {
      final List<dynamic> goalsJson = response.data;
      //print(response.data);
      final List<Goal> goals =
          goalsJson.map((goalJson) => Goal.fromJson(goalJson)).toList();
      return goals;
    } else {
      throw Exception('Failed to load goals');
    }
  } catch (e) {
    throw Exception('Failed to load goals: $e');
  }
}

Future<Goal> setNewGoal({DateTime? startDate, DateTime? endDate}) async {
  final dio = Dio(BaseOptions(baseUrl: baseURL));
  // code here
  dio.interceptors.add(AuthInterceptor(dio));
  try {
    final response = await dio.get(
      '/set_new_goal',
      queryParameters: {
        'start_date': startDate?.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
      },
    );

    final goalJson = Map<String, dynamic>.from(response.data);

    Goal goal = Goal.fromJson(goalJson);

    return goal;
  } catch (e) {
    throw Exception('Failed to load goal: $e');
  }
}

Future<void> updateGoal(Goal goal) async {
  final dio = Dio(BaseOptions(baseUrl: baseURL));
  dio.interceptors.add(AuthInterceptor(dio));
  try {
    final response = await dio.post(
      '/update_goal',
      data: goal.toJson(),
    );
    
  } catch (e) {
    throw Exception('Failed to update goal: $e');
  }
}

Future<bool> deleteGoal(int goalId) async {
  try{
    final dio = Dio(BaseOptions(baseUrl: baseURL));
    dio.interceptors.add(AuthInterceptor(dio));
    final response = await dio.delete('/delete_goal/$goalId');
    if (response.statusCode == 200){
      return true;
    } else {
      return false;
    }
  }
  catch (error) {
    throw Exception('Failed to delete goal: $error');
  }
}

Future<Goal> setPersonalGoal(Goal goal) async {
  final dio = Dio(BaseOptions(baseUrl: baseURL));
  dio.interceptors.add(AuthInterceptor(dio));
  try {
    final response = await dio.post(
      '/set_personal_goal',
      data: goal.toJson(),
    );
    Goal newGoal = Goal.fromJson(response.data);
    return newGoal;
  } catch (e) {
    throw Exception('Failed to update goal: $e');
  }
}

Stream<List<Message>> fetchChatHistory(int goalId, int page, int pageSize) async* {
  try {
    final dio = Dio(BaseOptions(baseUrl: baseURL));
    final response = await dio.get('/chat_history/$goalId', queryParameters: {
      'page': page,
      'page_size': pageSize,
    });

    if (response.statusCode == 200) {
      List<dynamic> json = response.data;
      List<Message> fetchedMessages = json.map((message) => Message(
        text: message['data']['content'], isBot: message['type'] == 'ai')).toList();
      yield fetchedMessages;
    } else {
      throw Exception('Failed to fetch chat history');
    }
  } catch (error) {
    throw Exception('Failed to fetch chat history: $error');
  }
}
