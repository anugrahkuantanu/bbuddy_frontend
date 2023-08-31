import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '/config/config.dart';
import '../../../core/classes/dio_util.dart';
import '../models/stats.dart';

Future<void> updateStats(UserStats? stat) async {
  final dio = Dio(BaseOptions(baseUrl: ApiEndpoint.baseURL));
  dio.interceptors.add(AuthInterceptor(dio));
  try {
    final response = await dio.post('/update_stats', data: stat!.toJson());
    if (response.statusCode != 200) {
      throw Exception('Failed to update stats');
    }
  } catch (e) {
    throw Exception('Failed to update stats: $e');
  }
}

class CounterStats extends ChangeNotifier {
  UserStats? checkInCounter;
  UserStats? reflectionCounter;

  CounterStats() {
    checkCounterStats();
  }

  void checkCounterStats() async {
    if (checkInCounter == null || reflectionCounter == null) {
      await getCounterStats();
    }
    notifyListeners();
  }

  void resetCheckInCounter() async {
    checkInCounter!.value = (0).toString();
    await updateStats(checkInCounter);
  }

  void resetReflectionCounter() async {
    reflectionCounter!.value = (0).toString();
    await updateStats(reflectionCounter);
  }

  void updateCheckInCounter() async {
    int? value = int.tryParse(checkInCounter!.value);
    if (value! < 3) {
      checkInCounter!.value = (value + 1).toString();
      await updateStats(checkInCounter);
    }
  }

  void updateReflectionCounter() async {
    int? value = int.tryParse(reflectionCounter!.value);
    if (value! < 3) {
      reflectionCounter!.value = (value + 1).toString();
      await updateStats(reflectionCounter);
    }
  }

  Future<void> getCounterStats() async {
    final dio = Dio(BaseOptions(baseUrl: ApiEndpoint.baseURL));
    dio.interceptors.add(AuthInterceptor(dio));
    try {
      final response = await dio.get('/counter_stats');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (data.length == 2) {
          for(final item in data){
            if(item['type']== 'REFLECTION_COUNTER'){
              reflectionCounter = UserStats.fromJson(item);
            } else {
                checkInCounter = UserStats.fromJson(item);
          
            }
          } 
        } else {
          throw Exception('Failed to load check-ins');
        }
      } else {
        throw Exception('Failed to load check-ins');
      }
    } catch (e) {
      throw Exception('Failed to load check-ins: $e');
    }
  }
}
