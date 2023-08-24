import '../../../models/model.dart';

abstract class GoalState {}

class GoalLoading extends GoalState {}

class GoalHasEnoughReflections extends GoalState {
  final List<Goal> generatedGoals;
  final List<Goal> personalGoals;

  GoalHasEnoughReflections({required this.generatedGoals, required this.personalGoals});
}

class GoalInsufficientReflections extends GoalState {}

class GoalError extends GoalState {
  final String errorMessage;

  GoalError({required this.errorMessage});
}

class GoalCreationAllowed extends GoalState {}
class GoalCreationDenied extends GoalState {
  final String reason;

  GoalCreationDenied(this.reason);
}

class GoalCreatedSuccessfully extends GoalState {
  final Goal goal;

  GoalCreatedSuccessfully({required this.goal});
}

