import 'dart:convert';
import 'dart:async';
import 'package:bbuddy_app/core/core.dart';
import 'package:bbuddy_app/di/di.dart';
import 'package:bbuddy_app/features/check_in_app/services/service.dart';
import 'package:bbuddy_app/features/check_in_app/models/model.dart';

class CheckInService {
  final http = locator.get<Http>();

  Future<String> getCheckInResponse(String feeling, String feelingForm,
      String reasonEntity, String reason) async {
    try {
      final response = await http.post('/mood_check_in',
          data: jsonEncode({
            'feeling': feeling,
            'feeling_form': feelingForm,
            'reason_entity': reasonEntity,
            'reason': reason
          }));

      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        return GENERAL_ERROR_MESSAGE;
      }
    } catch (e) {
      throw Exception('Failed to get check-in response: $e');
    }
  }

  Future<void> storeCheckIn(String feeling, String feelingForm,
      String reasonEntity, String reason, String aiResponse) async {
    final String feelingMessage =
        "I am feeling $feeling and $feelingForm about my $reasonEntity.";
    try {
      await http.post('/store_mood_check_in',
          data: jsonEncode({
            'feeling_message': feelingMessage,
            'reason': reason,
            'ai_response': aiResponse
          }));
    } catch (e) {
      throw Exception('Failed to store check-ins: $e');
    }
  }

  Future<List<CheckIn>> getCheckInHistory({int lastK = 4}) async {
    try {
      final response = await http.get('/mood_check_in_history', params: {
        'last_k': lastK,
      });
      if (response.statusCode == 200) {
        return parseCheckInList(response.data);
      } else {
        throw Exception('Failed to load check-ins');
      }
    } catch (e) {
      throw Exception('Failed to load check-ins: $e');
    }
  }

  Future<int> countCheckIn() async {
    try {
      final response = await http.get('/count_mood_check_in', params: {});
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
