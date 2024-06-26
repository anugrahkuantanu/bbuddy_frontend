import 'dart:convert';
import '../../reflection_app/models/reflection.dart';

List<ReflectionPerTopic> parseReflections(String responseBody) {
  final List<Map<String, dynamic>> jsonList =
      List<Map<String, dynamic>>.from(jsonDecode(responseBody));
  return jsonList
      .map((Map<String, dynamic> json) => ReflectionPerTopic.fromJson(json))
      .toList();
}
