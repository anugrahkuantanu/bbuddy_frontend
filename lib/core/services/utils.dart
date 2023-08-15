import 'dart:convert';
import '../models/main/reflection.dart';

List<ReflectionPerTopic> parseReflections(String responseBody) {
    print(responseBody);
  final List<Map<String, dynamic>> jsonList =
      List<Map<String, dynamic>>.from(jsonDecode(responseBody));
  return jsonList
      .map((Map<String, dynamic> json) => ReflectionPerTopic.fromJson(json))
      .toList();
}