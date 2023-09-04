abstract class GoalEvent {}

class LoadGoals extends GoalEvent {}

class CreateNewGoal extends GoalEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  CreateNewGoal({this.startDate, this.endDate});
}

class ShowGoalError extends GoalEvent {
  final String errorMessage;

  ShowGoalError({required this.errorMessage});
}


class CreateGeneratedGoals extends GoalEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  CreateGeneratedGoals({this.startDate, this.endDate});
}

class CountReflections extends GoalEvent {}

class ResetGoal extends GoalEvent {}

