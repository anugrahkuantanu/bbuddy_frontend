import '../bloc.dart';
import '../../../../reflection_app/services/service.dart';
import '../../../../main_app/services/service.dart';
import 'dart:async';
import '../../../services/service.dart';
import '../../../models/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final CounterStats counterStats;
  List<Goal> generatedGoals = [];
  List<Goal> personalGoals= [];

  GoalBloc({required this.counterStats}) : super(GoalLoading());

  @override
  Stream<GoalState> mapEventToState(GoalEvent event) async* {
    if (event is LoadGoals) {
      yield* _loadGoals();
    } else if (event is CreateGeneratedGoals) {
      yield* _createGeneratedGoals(event.startDate, event.endDate);
    } else if (event is ShowGoalError) {
      yield GoalError(errorMessage: event.errorMessage);
    } 
    else if (event is CreateNewGoal) {
      yield* _createNewGoal(event.startDate, event.endDate);
    }else if (event is ResetGoal) {
      yield* _loadGoals(); // Replace with your initial state
    }

  }

  Stream<GoalState> _loadGoals() async* {
    yield GoalLoading();
    try {
      final history = await getGoalHistory();
      generatedGoals = history
          .where((goal) => goal.type == GoalType.generated || goal.type == null)
          .toList();
      personalGoals = history.where((goal) => goal.type == GoalType.personal).toList();
      if (generatedGoals.isEmpty) {
        yield GoalHasNotEnoughReflections(personalGoals: personalGoals);
      } else {
        yield GoalHasEnoughReflections(generatedGoals: generatedGoals, personalGoals: personalGoals);
      }
    } catch (error) {
      yield GoalError(errorMessage: error.toString());
    }
  }

  Stream<GoalState> _createGeneratedGoals(DateTime? startDate, DateTime? endDate) async* {

    if (generatedGoals.isEmpty) {
      yield* _createNewGoal(startDate, endDate);
    } else {
      DateTime? nextCreateTime = generatedGoals[0].createTime?.add(const Duration(days: 7));
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
        yield GoalCreationDenied('You have been created the goal this week');
      } else {
        yield* _createNewGoal(startDate, endDate);
      }
    //   if (today.isBefore(nextCreateDate)) {
    //     yield* _createNewGoal(startDate, endDate);
    //   } else {
    //     yield* _createNewGoal(startDate, endDate);
    //   }
    }
  }

  Stream<GoalState> _createNewGoal(DateTime? startDate, DateTime? endDate) async* {
    yield GoalLoading();
    if (int.tryParse(counterStats.reflectionCounter!.value)! < 3) { //test
      int totalReflections = await countReflections();
      int modulo = totalReflections % 3;
      int reflectionsneeded = 3 - modulo;
      yield GoalInsufficientReflections('${reflectionsneeded}', 'you need ${reflectionsneeded} reflection(s)');
    } else {
      try {
        Goal goal = await setNewGoal(startDate: startDate, endDate: endDate);
        counterStats.resetReflectionCounter();
        generatedGoals.add(goal);
        yield GoalCreatedSuccessfully(goal: goal);
      } catch (error) {
        yield GoalError(errorMessage: error.toString());
      }
    }
  }
}