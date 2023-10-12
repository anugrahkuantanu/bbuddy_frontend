import 'dart:convert';

import 'package:bbuddy_app/di/di.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../core.dart';
import '../../features/main_app/models/stats.dart';

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

class CounterStats extends ChangeNotifier {
  UserStats? checkInCounter;
  UserStats? reflectionCounter;
  bool _isLoading = true;
  String _errorMessage = '';

  CounterStats();
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void checkCounterStats() async {
    if (checkInCounter == null || reflectionCounter == null) {
      try {
        _isLoading = true;
        await getCounterStats();
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
    final http = locator.get<Http>();
    try {
      final response = await http.get('/counter_stats');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (data.length == 2) {
          for (final item in data) {
            if (item['type'] == 'REFLECTION_COUNTER') {
              reflectionCounter = UserStats.fromJson(item);
            } else {
              checkInCounter = UserStats.fromJson(item);
            }
          }
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
