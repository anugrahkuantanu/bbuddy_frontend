import '../../models/model.dart';

// state
abstract class ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final Goal goal;
  ProgressLoaded({
    required this.goal,
  });
}

class ProgressError extends ProgressState {
  final String errorMessage;
  ProgressError({required this.errorMessage});
}

class NavigateToChatState extends ProgressState {
  final String goalId;

  NavigateToChatState({required this.goalId});
}
