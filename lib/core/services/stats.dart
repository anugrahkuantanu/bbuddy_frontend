import 'dart:convert';

import 'package:bbuddy_app/di/di.dart';
import 'package:flutter/foundation.dart';
import '../core.dart';
import '../../features/main_app/models/stats.dart';

class StatsService {
  Future<void> updateStats(UserStats? stat) async {
    final http = locator.get<Http>();
    try {
      final response =
          await http.post('/update_stats', data: jsonEncode(stat!.toJson()));
      if (response.statusCode != 200) {
        throw Exception('Failed to update stats');
      }
    } catch (e) {
      throw Exception('Failed to update stats: $e');
    }
  }

  Future<List<UserStats>> getCounterStats() async {
    final http = locator.get<Http>();
    List<UserStats> counterStats = [];
    try {
      final response = await http.get('/counter_stats');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (data.length == 2) {
          for (final item in data) {
            if (item['type'] == 'REFLECTION_COUNTER') {
              counterStats.add(UserStats.fromJson(item));
            } else {
              counterStats.add(UserStats.fromJson(item));
            }
          }
          return counterStats;
        } else {
          throw Exception('Unable to fetch data. Something went wrong');
        }
      } else {
        throw Exception('Something went wrong');
      }
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }
}

class CounterStats extends ChangeNotifier {
  UserStats? checkInCounter;
  UserStats? reflectionCounter;
  final StatsService statsService;
  bool _isLoading = true;
  String _errorMessage = '';

  CounterStats({required this.statsService});
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void checkCounterStats() async {
    if (checkInCounter == null || reflectionCounter == null) {
      try {
        _isLoading = true;
        for (final stat in await statsService.getCounterStats()) {
          if (stat.type == StatsType.CHECK_IN_COUNTER) {
            checkInCounter = stat;
          } else if (stat.type == StatsType.REFLECTION_COUNTER) {
            reflectionCounter = stat;
          } else {
            throw Exception('Unknown stat type');
          }
        }
        _isLoading = false;
      } catch (e) {
        _isLoading = false;
        _errorMessage = e.toString();
      }
    }
    notifyListeners();
  }

  void clearCounterStats() async {
    checkInCounter = null;
    reflectionCounter = null;
    notifyListeners();
  }

  void resetCheckInCounter() async {
    checkInCounter!.value = (0).toString();
    await statsService.updateStats(checkInCounter);
  }

  void resetReflectionCounter() async {
    reflectionCounter!.value = (0).toString();
    await statsService.updateStats(reflectionCounter);
  }

  void updateCheckInCounter() async {
    int? value = int.tryParse(checkInCounter!.value);
    if (value! < 3) {
      checkInCounter!.value = (value + 1).toString();
      await statsService.updateStats(checkInCounter);
    }
  }

  void updateReflectionCounter() async {
    int? value = int.tryParse(reflectionCounter!.value);
    if (value! < 3) {
      reflectionCounter!.value = (value + 1).toString();
      await statsService.updateStats(reflectionCounter);
    }
  }
}
