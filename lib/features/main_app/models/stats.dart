enum StatsType {
  CHECK_IN_COUNTER,
  REFLECTION_COUNTER,
}

class UserStats {
  final int id;
  final StatsType type;
  String value;

  UserStats({required this.id, required this.type, required this.value});

  factory UserStats.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String;
    final type = StatsType.values.firstWhere(
        (element) => element.toString().split('.').last == typeString);

    return UserStats(
      id: json['id'] as int,
      type: type,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'value': value,
    };
  }
}
