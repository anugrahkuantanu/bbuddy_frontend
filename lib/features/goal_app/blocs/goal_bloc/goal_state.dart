import '../../models/model.dart';

//state

abstract class GoalState {}

class GoalLoading extends GoalState {}

class PersonalGoalLoading extends GoalState {}

class GoalHasEnoughReflections extends GoalState {
  final List<Goal> generatedGoals;
  final List<Goal> personalGoals;

  GoalHasEnoughReflections(
      {required this.generatedGoals, required this.personalGoals});
}

class GoalHasNotEnoughReflections extends GoalState {
  final List<Goal> personalGoals;

  GoalHasNotEnoughReflections({required this.personalGoals});
}

class GoalError extends GoalState {
  final String errorMessage;

  GoalError({required this.errorMessage});
}

class GoalCreationAllowed extends GoalState {}

class GoalCreationDenied extends GoalState {
  final String reason;

  GoalCreationDenied(this.reason);
}

class GoalInsufficientReflections extends GoalState {
  final String reason;
  final String errorMessage;

  GoalInsufficientReflections(this.reason, this.errorMessage);
}

class GoalCreatedSuccessfully extends GoalState {
  final Goal goal;
  final bool closeDialog;
  GoalCreatedSuccessfully({required this.goal, this.closeDialog = false});
}

class GoalLoaded extends GoalState {
  final List<Goal> generatedGoals;
  final List<Goal> personalGoals;
  GoalLoaded({required this.generatedGoals, required this.personalGoals});
}

class GoalDeleted extends GoalState {
  final Goal goal;
  GoalDeleted({required this.goal});
}
