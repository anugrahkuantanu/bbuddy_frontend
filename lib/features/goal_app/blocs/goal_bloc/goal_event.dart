import 'package:bbuddy_app/features/goal_app/models/goal.dart';

abstract class GoalEvent {}

class LoadGoals extends GoalEvent {}

class CreateNewGoal extends GoalEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  CreateNewGoal({this.startDate, this.endDate});
}

class CreateGeneratedGoals extends GoalEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  CreateGeneratedGoals({this.startDate, this.endDate});
}

class CreatePersonalGoal extends GoalEvent {
  final Goal goal;
  CreatePersonalGoal({required this.goal});
}

class DeleteGoal extends GoalEvent {
  final Goal goal;
  DeleteGoal({required this.goal});
}

class ShowGoalError extends GoalEvent {
  final String errorMessage;

  ShowGoalError({required this.errorMessage});
}

class CountReflections extends GoalEvent {}

class ResetGoal extends GoalEvent {}
