import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bbuddy_app/core/core.dart';
import 'package:bbuddy_app/features/goal_app/models/model.dart';
import 'package:bbuddy_app/features/goal_app/blocs/bloc.dart';
import 'package:bbuddy_app/features/reflection_app/services/service.dart';
import 'package:bbuddy_app/features/goal_app/services/service.dart';

// Test the case when you have GoalInsufficientReflection if the bottom navigation works or not.

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final CounterStats counterStats;
  final GoalService goalService;
  final ReflectionService reflectionService;
  List<Goal> generatedGoals = [];
  List<Goal> personalGoals = [];

  GoalBloc(
      {required this.counterStats,
      required this.goalService,
      required this.reflectionService})
      : super(GoalLoading()) {
    on<LoadGoals>(_loadGoals);
    on<DeleteGoal>(_deleteGoal);
    on<CreateGeneratedGoals>(_createGeneratedGoal);
    on<CreatePersonalGoal>(_createPersonalGoal);
    on<ShowGoalError>(
        (event, emit) => emit(GoalError(errorMessage: event.errorMessage)));
  }

  Future<void> _deleteGoal(DeleteGoal event, Emitter<GoalState> emit) async {
    try {
      bool isDeleted = await goalService.deleteGoal(event.goal.id!);
      if (isDeleted) {
        if (event.goal.type == GoalType.personal) {
          personalGoals.removeWhere((goal) => goal.id == event.goal.id);
        } else if (event.goal.type == GoalType.generated) {
          generatedGoals.removeWhere((goal) => goal.id == event.goal.id);
        }
        emit(GoalDeleted(
            goal: event.goal)); // Assuming you have a GoalDeleted state
        emit(GoalLoaded(
            generatedGoals: generatedGoals, personalGoals: personalGoals));
      } else {
        emit(GoalError(errorMessage: "Failed to delete goal"));
      }
    } catch (error) {
      emit(GoalError(errorMessage: error.toString()));
    }
  }

  Future<void> _loadGoals(LoadGoals event, Emitter<GoalState> emit) async {
    emit(GoalLoading());
    try {
      final history = await goalService.getGoalHistory();
      generatedGoals = history
          .where((goal) => goal.type == GoalType.generated || goal.type == null)
          .toList();
      personalGoals =
          history.where((goal) => goal.type == GoalType.personal).toList();
      emit(GoalLoaded(
          generatedGoals: generatedGoals, personalGoals: personalGoals));
    } catch (error) {
      emit(GoalError(errorMessage: error.toString()));
    }
  }

  Future<void> _createGeneratedGoal(
      CreateGeneratedGoals event, Emitter<GoalState> emit) async {
    if (generatedGoals.isEmpty) {
      await _createNewGeneratedGoal(event.startDate, event.endDate, emit);
    } else {
      DateTime? nextCreateTime =
          generatedGoals[0].createTime?.add(const Duration(days: 7));
      var nextCreateDate = DateTime.utc(
        nextCreateTime!.year,
        nextCreateTime.month,
        nextCreateTime.day,
      );
      var today = DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      if (today.isBefore(nextCreateDate)) {
        emit(GoalCreationDenied(AppStrings.goalAlreadyCreated));
        emit(GoalLoaded(
            generatedGoals: generatedGoals, personalGoals: personalGoals));
      } else {
        await _createNewGeneratedGoal(event.startDate, event.endDate, emit);
      }
    }
  }

  Future<void> _createNewGeneratedGoal(
      DateTime? startDate, DateTime? endDate, Emitter<GoalState> emit) async {
    emit(GoalLoading());
    final counter = int.tryParse(counterStats.reflectionCounter!.value);

    if (counter! < 3) {
      int totalReflections = await reflectionService.countReflections();
      int modulo = totalReflections % 3;
      int reflectionsneeded = 3 - modulo;
      emit(GoalInsufficientReflections('$reflectionsneeded',
          'you need $reflectionsneeded more reflection(s) to generate the goal'));
      emit(GoalLoaded(
          generatedGoals: generatedGoals, personalGoals: personalGoals));
    } else {
      try {
        Goal goal = await goalService.setNewGoal(
            startDate: startDate, endDate: endDate);
        counterStats.resetReflectionCounter();
        generatedGoals.insert(0, goal);
        emit(GoalCreatedSuccessfully(goal: goal));
        emit(GoalLoaded(
            generatedGoals: generatedGoals, personalGoals: personalGoals));
      } catch (error) {
        emit(GoalError(errorMessage: error.toString()));
      }
    }
  }

  Future<void> _createPersonalGoal(
      CreatePersonalGoal event, Emitter<GoalState> emit) async {
    emit(PersonalGoalLoading());
    try {
      Goal newGoal;
      newGoal = await goalService.setPersonalGoal(event.goal);
      emit(GoalCreatedSuccessfully(goal: newGoal, closeDialog: true));
      personalGoals.insert(0, newGoal);
      emit(GoalLoaded(
          generatedGoals: generatedGoals, personalGoals: personalGoals));
    } catch (error) {
      emit(GoalError(errorMessage: error.toString()));
    }
  }
}
