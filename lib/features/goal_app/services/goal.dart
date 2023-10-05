import 'dart:convert';

import 'package:bbuddy_app/di/di.dart';
import 'package:bbuddy_app/features/goal_app/models/model.dart';
import 'package:bbuddy_app/core/core.dart';

class GoalService {
  final http = locator.get<Http>();

  Future<List<Goal>> getGoalHistory() async {
    // code here
    try {
      final response = await http.get(
        '/goal_history',
      );
      if (response.statusCode == 200) {
        final List<dynamic> goalsJson = response.data;
        final List<Goal> goals =
            goalsJson.map((goalJson) => Goal.fromJson(goalJson)).toList();
        return goals;
      } else {
        throw Exception('Failed to load goals');
      }
    } catch (e) {
      throw Exception('Failed to load goals');
    }
  }

  Future<Goal> setNewGoal({DateTime? startDate, DateTime? endDate}) async {
    // code here
    try {
      final response = await http.get(
        '/set_new_goal',
        params: {
          'start_date': startDate?.toIso8601String(),
          'end_date': endDate?.toIso8601String(),
        },
      );

      final goalJson = Map<String, dynamic>.from(response.data);
      //print(goalJson);

      Goal goal = Goal.fromJson(goalJson);

      return goal;
    } catch (e) {
      throw Exception('Failed to load goal');
    }
  }

  // Future<Goal> setNewGoal({DateTime? startDate, DateTime? endDate}) async {
  //   // code here
  //   try {
  //     const goalJsonString = """{
  //           "create_time": null,
  //           "description": "Take time to manage your stress and emotions by addressing your feelings and finding ways to cope.",
  //           "type": "generated",
  //           "milestones": [
  //               {"content": "Identify the sources of stress in my life", "status": null},
  //               {"content": "Develop a plan to address the sources of stress", "status": null},
  //               {"content": "Set aside time each day to practice relaxation techniques", "status": null},
  //               {"content": "Find a support system to talk to about my feelings", "status": null},
  //               {"content": "Create a list of activities that help me cope with stress", "status": null}
  //           ],
  //           "id": "EVlGvHIIbGKPk61NIwyA"
  //       }""";

  //     // Convert the JSON string to a Map
  //     final goalJson = json.decode(goalJsonString);

  //     Goal goal = Goal.fromJson(goalJson);

  //     return goal;
  //   } catch (e) {
  //     throw Exception('Failed to load goal');
  //   }
  // }

  Future<void> updateGoal(Goal goal) async {
    try {
      await http.post('/update_goal', data: jsonEncode(goal.toJson()));
    } catch (e) {
      throw Exception('Failed to update goal');
    }
  }

  Future<bool> deleteGoal(String goalId) async {
    try {
      final response = await http.delete('/delete_goal/$goalId');
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw Exception('Failed to delete goal');
    }
  }

  Future<Goal> setPersonalGoal(Goal goal) async {
    try {
      final response = await http.post(
        '/set_personal_goal',
        data: jsonEncode(goal.toJson()),
      );
      Goal newGoal = Goal.fromJson(response.data);
      return newGoal;
    } catch (e) {
      throw Exception('Failed to create new goal');
    }
  }
}

Stream<List<Message>> fetchChatHistory(
    String goalId, int page, int pageSize) async* {
  final http = locator.get<Http>();
  try {
    final response = await http.get('/chat_history/$goalId', params: {
      'page': page,
      'page_size': pageSize,
    });

    if (response.statusCode == 200) {
      List<dynamic> json = response.data;
      List<Message> fetchedMessages = json
          .map((message) => Message(
              text: message['data']['content'], isBot: message['type'] == 'ai'))
          .toList();
      yield fetchedMessages;
    } else {
      throw Exception('Failed to fetch chat history');
    }
  } catch (error) {
    throw Exception('Failed to fetch chat history');
  }
}
