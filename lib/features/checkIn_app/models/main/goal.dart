/*class Milestone {
  String content;
//  List<Milestone> tasks;

  Milestone({required this.content});

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    return data;
  }
}*/

class Milestone {
  String content;
  bool? status;
  List<Milestone> tasks;

  Milestone({
    required this.content,
    this.status,
    this.tasks = const [],
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    List<Milestone> tasks = <Milestone>[];
    if (json['tasks'] != null) {
      var tasksJson = json['tasks'] as List<dynamic>;
      tasks =
          tasksJson.map((taskJson) => Milestone.fromJson(taskJson)).toList();
    }

    return Milestone(
      content: json['content'],
      status: json['status'],
      tasks: tasks,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['tasks'] = tasks.map((task) => task.toJson()).toList();
    data['status'] = status;
    return data;
  }
}

enum GoalType {
  personal,
  generated,
}

class Goal {
  int? id;
  DateTime? createTime;
  String description;
  GoalType? type;
  List<Milestone> milestones;

  Goal(
      {this.id,
      this.createTime,
      this.type,
      required this.description,
      required this.milestones});

  factory Goal.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String?;
    final type = typeString != null
        ? GoalType.values.firstWhere(
            (element) => element.toString().split('.').last == typeString)
        : null;
    return Goal(
      id: json['id'],
      createTime: json['create_time'] != null
          ? DateTime.parse(json['create_time'])
          : null,
      type: type,
      description: json['description'],
      milestones: List<Milestone>.from(
          json['milestones'].map((x) => Milestone.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    if (type != null) {
      data['type'] = type.toString().split('.').last;
    }
    data['create_time'] = createTime?.toIso8601String();
    data['description'] = description;
    data['milestones'] = List<dynamic>.from(milestones.map((x) => x.toJson()));
    return data;
  }

  int finishedMilestoneCount() {
    int count = 0;
    for (var milestone in milestones) {
      if (milestone.status == true) {
        count++;
      }
    }
    return count;
  }
}
