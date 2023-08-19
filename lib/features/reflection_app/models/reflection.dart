import '../services/reflections.dart';

class BaseInsight {
  final String content;

  BaseInsight({required this.content});

  String type() {
    throw UnimplementedError();
  }
  
  factory BaseInsight.fromJson(Map<String, dynamic> json) {
    return BaseInsight(content: json['content'] as String);
  }
}

class HumanInsight extends BaseInsight {
  HumanInsight({required content}) : super(content: content);

  @override
  String type() {
    return "human";
  }
  factory HumanInsight.fromJson(Map<String, dynamic> json) {
    return HumanInsight(content: json['content'] as String);
  }

}

class AIInsight extends BaseInsight {
  AIInsight({required content}) : super(content: content);

  @override
  String type() {
    return "ai";
  }
  factory AIInsight.fromJson(Map<String, dynamic> json) {
    return AIInsight(
        content: json['content'] as String,
    );
  }

}


class ReflectionPerTopic {
  final String topic;
  final HumanInsight humanInsight;
  final List<AIInsight> aiInsights;

  ReflectionPerTopic({
    required this.topic,
    required this.humanInsight,
    required this.aiInsights,
  });
  
  factory ReflectionPerTopic.fromJson(Map<String, dynamic> json) {
    return ReflectionPerTopic(
      topic: json['topic'] as String,
      humanInsight: HumanInsight.fromJson(json['human_insight']),
      aiInsights: List<AIInsight>.from(
        json['ai_insights'].map((ai) => AIInsight.fromJson(ai)),
      ),
    );
  }
}

class Reflection {
  final String heading;
  final List<ReflectionPerTopic> topicReflections;
  
  Reflection({
    required this.heading,
    required this.topicReflections,
   });

  factory Reflection.fromJson(Map<String, dynamic> json) {
    return Reflection(
      heading: json['heading'] as String,
      topicReflections: List<ReflectionPerTopic>.from(
        json['topic_reflections'].map((topic) => ReflectionPerTopic.fromJson(topic)),
      ),
    );
  }
}

