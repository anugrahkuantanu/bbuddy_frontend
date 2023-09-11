
import '../../../models/model.dart';

// state
abstract class ProgressState{}

class ProgressLoading extends ProgressState{}

class ProgressLoaded extends ProgressState{
  final Goal goal;
  // final List<Milestone> milestone;
  ProgressLoaded({
    required this.goal,
    // required this.milestone
  });
}


class ProgressError extends ProgressState{
  final String errorMessage;
  ProgressError({required this.errorMessage});
}

class GoalDeleted extends ProgressState{
  final Goal goal;
  GoalDeleted({required this.goal});
}
class NavigateToChatState extends ProgressState {
  final int goalId;

  NavigateToChatState({required this.goalId});
}

class InitiateCallState extends ProgressState {
  final int goalId;

  InitiateCallState({required this.goalId});
}