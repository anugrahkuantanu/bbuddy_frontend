import 'package:bbuddy_app/core/core.dart';

import '../bloc.dart';
import '../../../../reflection_app/services/service.dart';
import '../../../services/service.dart';
import '../../../models/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    on<CreateGeneratedGoals>(_createGeneratedGoals);
    on<CreateNewGoal>(_createPersonalNewGoal);
    on<ShowGoalError>(
        (event, emit) => emit(GoalError(errorMessage: event.errorMessage)));
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
      if (generatedGoals.isEmpty) {
        // emit(GoalHasNotEnoughReflections(personalGoals: personalGoals));
        emit(GoalHasEnoughReflections(
            generatedGoals: [], personalGoals: personalGoals));
      } else {
        emit(GoalHasEnoughReflections(
            generatedGoals: generatedGoals, personalGoals: personalGoals));
      }
    } catch (error) {
      emit(GoalError(errorMessage: error.toString()));
    }
  }

  Future<void> _createGeneratedGoals(
      CreateGeneratedGoals event, Emitter<GoalState> emit) async {
    if (generatedGoals.isEmpty) {
      await _createNewGoal(event.startDate, event.endDate, emit);
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
      } else {
        await _createNewGoal(event.startDate, event.endDate, emit);
      }
    }
  }

  Future<void> _createPersonalNewGoal(
      CreateNewGoal event, Emitter<GoalState> emit) async {
    _createNewGoal(event.startDate, event.endDate, emit);
  }

  // Future<void> _createNewGoal(CreateNewGoal event, Emitter<GoalState> emit) async {
  Future<void> _createNewGoal(
      DateTime? startDate, DateTime? endDate, Emitter<GoalState> emit) async {
    emit(GoalLoading());
    if (int.tryParse(counterStats.reflectionCounter!.value)! < 3) {
      int totalReflections = await reflectionService.countReflections();
      int modulo = totalReflections % 3;
      int reflectionsneeded = 3 - modulo;
      emit(GoalInsufficientReflections('$reflectionsneeded',
          'you need $reflectionsneeded more reflection(s) to generate the goal'));
    } else {
      try {
        Goal goal = await goalService.setNewGoal(
            startDate: startDate, endDate: endDate);
        counterStats.resetReflectionCounter();
        generatedGoals.add(goal);
        emit(GoalCreatedSuccessfully(goal: goal));
      } catch (error) {
        emit(GoalError(errorMessage: error.toString()));
      }
    }
  }
}



// import '../bloc.dart';
// import '../../../../reflection_app/services/service.dart';
// import '../../../../main_app/services/service.dart';
// import 'dart:async';
// import '../../../services/service.dart';
// import '../../../models/model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class GoalBloc extends Bloc<GoalEvent, GoalState> {
//   final CounterStats counterStats;
//   List<Goal> generatedGoals = [];
//   List<Goal> personalGoals= [];

//   GoalBloc({required this.counterStats}) : super(GoalLoading());

//   @override
  // Stream<GoalState> mapEventToState(GoalEvent event) async* {
  //   if (event is LoadGoals) {
  //     yield* _loadGoals();
  //   } else if (event is CreateGeneratedGoals) {
  //     yield* _createGeneratedGoals(event.startDate, event.endDate);
  //   } else if (event is ShowGoalError) {
  //     yield GoalError(errorMessage: event.errorMessage);
  //   } 
  //   else if (event is CreateNewGoal) {
  //     yield* _createNewGoal(event.startDate, event.endDate);
  //   }else if (event is ResetGoal) {
  //     yield* _loadGoals(); // Replace with your initial state
  //   }

  // }

//   Stream<GoalState> _loadGoals() async* {
//     yield GoalLoading();
//     try {
//       final history = await getGoalHistory();
//       generatedGoals = history
//           .where((goal) => goal.type == GoalType.generated || goal.type == null)
//           .toList();
//       personalGoals = history.where((goal) => goal.type == GoalType.personal).toList();
//       if (generatedGoals.isEmpty) {
//         yield GoalHasNotEnoughReflections(personalGoals: personalGoals);
//       } else {
//         yield GoalHasEnoughReflections(generatedGoals: generatedGoals, personalGoals: personalGoals);
//       }
//     } catch (error) {
//       yield GoalError(errorMessage: error.toString());
//     }
//   }

  // Stream<GoalState> _createGeneratedGoals(DateTime? startDate, DateTime? endDate) async* {
  //   if (generatedGoals.isEmpty) {
  //     yield* _createNewGoal(startDate, endDate);
  //   } else {
  //     DateTime? nextCreateTime = generatedGoals[0].createTime?.add(const Duration(days: 7));
  //     var nextCreateDate = DateTime.utc(
  //       nextCreateTime!.year,
  //       nextCreateTime.month,
  //       nextCreateTime.day,
  //     );
  //     var today = DateTime.utc(
  //       DateTime.now().year,
  //       DateTime.now().month,
  //       DateTime.now().day,
  //     );
  //     if (today.isBefore(nextCreateDate)) {
  //       yield GoalCreationDenied('You have been created the goal this week');
  //     } else {
  //       yield* _createNewGoal(startDate, endDate);
  //     }
  //   }
  // }

//   Stream<GoalState> _createNewGoal(DateTime? startDate, DateTime? endDate) async* {
//     yield GoalLoading();
//     if (int.tryParse(counterStats.reflectionCounter!.value)! < 3) { //test
//       int totalReflections = await countReflections();
//       int modulo = totalReflections % 3;
//       int reflectionsneeded = 3 - modulo;
//       yield GoalInsufficientReflections('${reflectionsneeded}', 'you need ${reflectionsneeded} reflection(s)');
//     } else {
//       try {
//         Goal goal = await setNewGoal(startDate: startDate, endDate: endDate);
//         counterStats.resetReflectionCounter();
//         generatedGoals.add(goal);
//         yield GoalCreatedSuccessfully(goal: goal);
//       } catch (error) {
//         yield GoalError(errorMessage: error.toString());
//       }
//     }
//   }
// }