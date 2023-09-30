import 'dart:convert';

import 'package:bbuddy_app/core/core.dart';
import 'package:dio/dio.dart';
import '../../../core/classes/dio_util.dart';
import 'checkIn_utils.dart';
import '/config/api_endpoints.dart';
import '../models/model.dart';

class CheckInService {
  final Dio _dio = _initializeDio();
  static Dio _initializeDio() {
    final dio = Dio(BaseOptions(baseUrl: ApiEndpoint.baseURL));
    dio.interceptors.add(AuthInterceptor(dio));
    return dio;
  }


  Future<String> getCheckInResponse(String feeling, String feelingForm,
      String reasonEntity, String reason) async {
    try {
      String? token = await getIdToken();
      Http _http = Http(baseUrl: ApiEndpoint.baseURL, headers: {
        'token': token!,
      });
      final response = await _http.post('/mood_check_in',
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
      String reasonEntity, String reason, String ai_response) async {
    final String feeling_message =
        "I am feeling $feeling and $feelingForm about my $reasonEntity.";
    try {
      String? token = await getIdToken();
      Http _http =
          Http(baseUrl: ApiEndpoint.baseURL, headers: {'token': token!});
      await _http.post('/store_mood_check_in',
          data: jsonEncode({
            'feeling_message': feeling_message,
            'reason': reason,
            'ai_response': ai_response
          }));
    } catch (e) {
      throw Exception('Failed to store check-ins: $e');
    }
  }

  Future<List<CheckIn>> getCheckInHistory({int lastK = 4}) async {
    String? token = await getIdToken();
    Http _http = Http(baseUrl: ApiEndpoint.baseURL, headers: {
      'token': token!,
    });
    try {
      final response = await _http.get('/mood_check_in_history', params: {
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
      final response = await _dio.get('/count_mood_check_in');
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
