import '../models/checkIn.dart';
import '../models/model.dart';
import 'package:dio/dio.dart';
import '/core/services/constants.dart';
import '/core/services/dio_util.dart';


Future<String> getCheckInResponse(String feeling, String feelingForm,
    String reasonEntity, String reason) async {
  final dio = Dio(BaseOptions(baseUrl: baseURL));
  dio.interceptors.add(AuthInterceptor(dio));
  final response = await dio.post(
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
    return 'Something went wrong, please try again later.';
  }
}

Future<void> storeCheckIn(String feeling, String feelingForm,
    String reasonEntity, String reason, String ai_response) async {
  final String feeling_message =
      "I am feeling ${feeling} and ${feelingForm} about my ${reasonEntity}.";

  final dio = Dio(BaseOptions(baseUrl: baseURL));
  dio.interceptors.add(AuthInterceptor(dio));
  try {
    final response = await dio.post(
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
  final dio = Dio(BaseOptions(baseUrl: baseURL));
  dio.interceptors.add(AuthInterceptor(dio));
  try {
    final response = await dio.get(
      '/mood_check_in_history',
      queryParameters: {
        'last_k': lastK,
      },
    );
    if (response.statusCode == 200) {
      List jsonList = response.data;
      //print(response.data);
      List<CheckIn> pastCheckIns =
          List.generate(jsonList.length ~/ 2, (index) {
        int startIndex = index * 2;
        return CheckIn(
          humanMessage: Message(
            text: jsonList[startIndex]["data"]["content"],
            isBot: jsonList[startIndex]["type"]=="ai",
          ),
          aiMessage: Message(
            text: jsonList[startIndex + 1]["data"]["content"],
            isBot: jsonList[startIndex]["type"]=="ai",
          ),
        );
      });
      return pastCheckIns;
    } else {
      throw Exception('Failed to load check-ins');
    }
  } catch (e) {
    throw Exception('Failed to load check-ins: $e');
  }
}

Future<int> countCheckIn() async {
  final dio = Dio(BaseOptions(baseUrl: baseURL));
  dio.interceptors.add(AuthInterceptor(dio));
  try {
    final response = await dio.get('/count_mood_check_in');
    if (response.statusCode == 200) {
      return response.data as int;
    } else {
      throw Exception('Failed to load check-ins');
    }
  } catch (e) {
    throw Exception('Failed to load check-ins: $e');
  }
}
