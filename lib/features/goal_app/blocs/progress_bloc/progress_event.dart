import '../../models/model.dart';

abstract class ProgressEvent {}

class InitializePersonalGoal extends ProgressEvent {
  late Goal goal;
  bool generateMilestones;
  InitializePersonalGoal({required this.goal, this.generateMilestones = false});
}

class DeleteGoal extends ProgressEvent {
  final Goal goal;
  DeleteGoal({required this.goal});
}

class DeleteMilestone extends ProgressEvent {
  final int index;
  final Goal goal;

  DeleteMilestone({required this.index, required this.goal});
}

class ChangeMilestoneStatus extends ProgressEvent {
  final int index;
  final bool status;
  final Goal goal;
  int finishedCount;

  ChangeMilestoneStatus(
      {required this.index,
      required this.status,
      required this.goal,
      required this.finishedCount});
}

class EditMilestone extends ProgressEvent {
  final int index;
  final String content;
  final Goal goal;

  EditMilestone(
      {required this.index, required this.content, required this.goal});
}

class AddSubMilestone extends ProgressEvent {
  final Goal goal;
  final Milestone milestone;
  final int index;

  AddSubMilestone(
      {required this.milestone, required this.goal, required this.index});
}

class NavigateToChat extends ProgressEvent {
  final String goalId;

  NavigateToChat({required this.goalId});
}

class InitiateCall extends ProgressEvent {
  final String goalId;

  InitiateCall({required this.goalId});
}

class UpdateGoal extends ProgressEvent {
  final Goal goal;
  final List<Milestone> milestone;

  UpdateGoal({required this.goal, required this.milestone});
}

class AddMilestone extends ProgressEvent {
  final Goal goal;
  final Milestone milestone;

  AddMilestone({required this.goal, required this.milestone});
}
