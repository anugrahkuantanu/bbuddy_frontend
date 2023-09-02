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

  GoalBloc({required this.counterStats}) : super(GoalLoading());

  @override
  Stream<GoalState> mapEventToState(GoalEvent event) async* {
    if (event is LoadGoals) {
      yield* _loadGoals();
    } else if (event is CreateGeneratedGoals) {
      yield* _createGeneratedGoals(event.startDate, event.endDate);
    } else if (event is ShowGoalError) {
      yield GoalError(errorMessage: event.errorMessage);
    } else if (event is CountReflections) {
      yield* _countReflections();
    } else if (event is CreateNewGoal) {
      yield* _createNewGoal(event.startDate, event.endDate);
    }
  }

  Stream<GoalState> _loadGoals() async* {
    yield GoalLoading();
    try {
      final history = await getGoalHistory();
      generatedGoals = history
          .where((goal) => goal.type == GoalType.generated || goal.type == null)
          .toList();
      final personalGoals = history.where((goal) => goal.type == GoalType.personal).toList();
      if (generatedGoals.isEmpty) {
        yield GoalInsufficientReflections();
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
        yield GoalCreationDenied('goalAlreadyCreated');
      } else {
        yield* _createNewGoal(startDate, endDate);
      }
    }
  }

  Stream<GoalState> _countReflections() async* {
    if (generatedGoals.isEmpty) {
      int totalReflections = await countReflections();
      if (totalReflections < 3) {
        yield GoalInsufficientReflections();
      } else {
        yield GoalHasEnoughReflections(generatedGoals: generatedGoals, personalGoals: []);
      }
    } else {
      yield GoalHasEnoughReflections(generatedGoals: generatedGoals, personalGoals: []);
    }
  }

  Stream<GoalState> _createNewGoal(DateTime? startDate, DateTime? endDate) async* {
    yield GoalLoading();
    if (int.tryParse(counterStats.reflectionCounter!.value)! < 3) {
      yield GoalInsufficientReflections();
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
