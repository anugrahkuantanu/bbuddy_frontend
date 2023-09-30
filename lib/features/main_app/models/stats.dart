enum StatsType {
  CHECK_IN_COUNTER,
  REFLECTION_COUNTER,
}

class UserStats {
  final StatsType type;
  String value;

  UserStats({required this.type, required this.value});

  factory UserStats.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String;
    final type = StatsType.values.firstWhere(
        (element) => element.toString().split('.').last == typeString);

    return UserStats(
      type: type,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'value': value,
    };
  }
}
