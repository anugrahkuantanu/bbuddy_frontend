import 'package:dio/dio.dart';
import '/core/services/dio_util.dart';
import 'CheckInUtils.dart';
import '/config/api_endpoints.dart';
import '../models/model.dart';

class CheckInService {
  final Dio _dio = _initializeDio();

  static Dio _initializeDio() {
    final dio = Dio(BaseOptions(baseUrl: ApiEndpoint.baseURL));
    dio.interceptors.add(AuthInterceptor(dio));
    return dio;
  }

  Future<String> getCheckInResponse(String feeling, String feelingForm, String reasonEntity, String reason) async {
    try {
      final response = await _dio.post(
        '/mood_check_in',
        data: {
          'feeling': feeling,
          'feeling_form': feelingForm,
          'reason_entity': reasonEntity,
          'reason': reason
        },
      );
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        return GENERAL_ERROR_MESSAGE;
      }
    } catch (e) {
      throw Exception('Failed to get check-in response: $e');
    }
  }

  Future<void> storeCheckIn(String feeling, String feelingForm, String reasonEntity, String reason, String ai_response) async {
    final String feeling_message = "I am feeling $feeling and $feelingForm about my $reasonEntity.";
    try {
      await _dio.post(
        '/store_mood_check_in',
        data: {
          'feeling_message': feeling_message,
          'reason': reason,
          'ai_response': ai_response
        },
      );
    } catch (e) {
      throw Exception('Failed to store check-ins: $e');
    }
  }

  Future<List<CheckIn>> getCheckInHistory({int lastK = 4}) async {
    try {
      final response = await _dio.get(
        '/mood_check_in_history',
        queryParameters: {
          'last_k': lastK,
        },
      );
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
