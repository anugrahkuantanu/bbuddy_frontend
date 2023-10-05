import '../../services/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../bloc.dart';
import '../../models/model.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  Goal goal;
  GoalService goalService;
  ProgressBloc({required this.goal, required this.goalService})
      : super(ProgressLoading()) {
    on<InitializePersonalGoal>(_initializePersonalGoal);
    on<DeleteMilestone>(_deleteMilestone);
    on<ChangeMilestoneStatus>(_changeMilestoneStatus);
    on<EditMilestone>(_editMilestone);
    on<AddSubMilestone>(_addSubMilestone);
    on<NavigateToChat>(_navigateToChat);
    on<UpdateGoal>(_updateGoal);
    on<AddMilestone>(_addMilestone);
  }

  Future<void> _initializePersonalGoal(
      InitializePersonalGoal event, Emitter<ProgressState> emit) async {
    emit(ProgressLoading());
    try {
      emit(ProgressLoaded(goal: event.goal));
    } catch (error) {
      emit(ProgressError(errorMessage: error.toString()));
    }
  }

  Future<void> _deleteMilestone(
      DeleteMilestone event, Emitter<ProgressState> emit) async {
    try {
      event.goal.milestones.removeAt(event.index);
      goalService.updateGoal(event
          .goal); // Assuming updateGoal is a function you have defined elsewhere
      emit(ProgressLoaded(goal: event.goal));
    } catch (error) {
      emit(ProgressError(errorMessage: error.toString()));
    }
  }

  Future<void> _changeMilestoneStatus(
      ChangeMilestoneStatus event, Emitter<ProgressState> emit) async {
    try {
      event.goal.milestones[event.index].status = event.status;
      goalService.updateGoal(event.goal);
      emit(ProgressLoaded(goal: event.goal));
    } catch (error) {
      emit(ProgressError(errorMessage: error.toString()));
    }
  }

  Future<void> _editMilestone(
      EditMilestone event, Emitter<ProgressState> emit) async {
    try {
      event.goal.milestones[event.index].content = event.content;
      goalService.updateGoal(event.goal);
      emit(ProgressLoaded(goal: event.goal));
    } catch (error) {
      emit(ProgressError(errorMessage: error.toString()));
    }
  }

  Future<void> _addSubMilestone(
      AddSubMilestone event, Emitter<ProgressState> emit) async {
    try {
      event.goal.milestones[event.index].tasks.add(event.milestone);
      goalService.updateGoal(event.goal);
      emit(ProgressLoaded(goal: event.goal));
    } catch (error) {
      emit(ProgressError(errorMessage: error.toString()));
    }
  }

  Future<void> _navigateToChat(
      NavigateToChat event, Emitter<ProgressState> emit) async {
    try {
      emit(NavigateToChatState(
          goalId: event.goalId)); // Assuming you have a NavigateToChatState
    } catch (error) {
      emit(ProgressError(errorMessage: error.toString()));
    }
  }

  Future<void> _updateGoal(
      UpdateGoal event, Emitter<ProgressState> emit) async {
    try {
      goalService.updateGoal(event.goal);
      emit(ProgressLoaded(goal: event.goal));
    } catch (error) {
      emit(ProgressError(errorMessage: error.toString()));
    }
  }

  Future<void> _addMilestone(
      AddMilestone event, Emitter<ProgressState> emit) async {
    try {
      event.goal.milestones.add(event.milestone);
      goalService.updateGoal(event.goal);
      emit(ProgressLoaded(goal: event.goal));
    } catch (error) {
      emit(ProgressError(errorMessage: error.toString()));
    }
  }
}
