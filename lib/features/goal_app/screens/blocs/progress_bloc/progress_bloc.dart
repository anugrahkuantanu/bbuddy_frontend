import '../../../services/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../bloc.dart';

import '../../../models/model.dart';


class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final Goal goal;


  ProgressBloc({required this.goal}) : super(ProgressLoading());

  @override
  Stream<ProgressState> mapEventToState(ProgressEvent event) async* {
    if (event is InitializePersonalGoal) {
      yield* _initializePersonalGoal(event);
    } else if (event is DeleteGoal) {
      yield* _deleteGoal(event);
    } else if (event is DeleteMilestone) {
      yield* _deleteMilestone(event);
    } else if (event is ChangeMilestoneStatus) {
      yield* _changeMilestoneStatus(event);
    } else if (event is EditMilestone) {
      yield* _editMilestone(event);
    } else if (event is AddSubMilestone) {
      yield* _addSubMilestone(event);
    } else if (event is NavigateToChat) {
      yield* _navigateToChat(event);
    } else if (event is InitiateCall) {
      yield* _initiateCall(event);
    } else if (event is UpdateGoal) {
      yield* _updateGoal(event);
    } else if (event is AddMilestone) {
      yield* _addMilestone(event);
    }
  }

  Stream<ProgressState> _initializePersonalGoal(InitializePersonalGoal event) async* {
    yield ProgressLoading();
    try {
      Goal newGoal;
      if (event.generateMilestones) {
        newGoal = await setPersonalGoal(event.goal);
        event.generateMilestones = false;
      } else {
        newGoal = event.goal;
      }
      yield ProgressLoaded(goal: event.goal, milestone: newGoal.milestones);
      //MUSST BE PROVED
    } catch (error) {
      yield ProgressError(errorMessage: error.toString());
    }
  }

  Stream<ProgressState> _deleteGoal(DeleteGoal event) async* {
    try {
      bool isDeleted = await deleteGoal(event.goal.id!);
      if (isDeleted) {
        yield GoalDeleted(goal: event.goal);
      } else {
        yield ProgressError(errorMessage: "Failed to delete goal");
      }
    } catch (error) {
      yield ProgressError(errorMessage: error.toString());
    }
  }

  Stream<ProgressState> _deleteMilestone(DeleteMilestone event) async* {
    try {
      event.goal.milestones.removeAt(event.index);
      yield ProgressLoaded(goal: event.goal, milestone: event.goal.milestones);
    } catch (error) {
      yield ProgressError(errorMessage: error.toString());
    }
  }

  Stream<ProgressState> _changeMilestoneStatus(ChangeMilestoneStatus event) async* {
    try {
      event.goal.milestones[event.index].status = event.status;
      yield ProgressLoaded(goal: event.goal, milestone: event.goal.milestones);
    } catch (error) {
      yield ProgressError(errorMessage: error.toString());
    }
  }

  Stream<ProgressState> _editMilestone(EditMilestone event) async* {
    try {
      event.goal.milestones[event.index].content = event.content;
      yield ProgressLoaded(goal: event.goal, milestone: event.goal.milestones);
    } catch (error) {
      yield ProgressError(errorMessage: error.toString());
    }
  }

  Stream<ProgressState> _addSubMilestone(AddSubMilestone event) async* {
    try {
      event.goal.milestones[event.index].tasks.add(event.milestone);
      yield ProgressLoaded(goal: event.goal, milestone: event.goal.milestones);
    } catch (error) {
      yield ProgressError(errorMessage: error.toString());
    }
  }

  Stream<ProgressState> _navigateToChat(NavigateToChat event) async* {
    try {
      // Here, we'll directly navigate to the chat page, but it's not the best practice.
      // Instead, you could use a separate navigation manager or handle this in the UI listener.
      yield NavigateToChatState(goalId: event.goalId);
    } catch (error) {
      yield ProgressError(errorMessage: error.toString());
    }
  }

  Stream<ProgressState> _initiateCall(InitiateCall event) async* {
    try {
      // Similar to the navigateToChat function, this can be handled in the UI listener.
      yield InitiateCallState(goalId: event.goalId);
    } catch (error) {
      yield ProgressError(errorMessage: error.toString());
    }
  }

  Stream<ProgressState> _updateGoal(UpdateGoal event) async* {
    try {
      yield ProgressLoaded(goal: event.goal, milestone: event.milestone);
    } catch (error) {
      yield ProgressError(errorMessage: error.toString());
    }
  }

  Stream<ProgressState> _addMilestone(AddMilestone event) async* {
    try {
      event.goal.milestones.add(event.milestone);
      yield ProgressLoaded(goal: event.goal, milestone: event.goal.milestones);
    } catch (error) {
      yield ProgressError(errorMessage: error.toString());
    }
  }
}





// class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
//   final Goal goal;

//   ProgressBloc({required this.goal}) : super(ProgressLoading());

//   @override
//   Stream<ProgressState> mapEventToState(ProgressEvent event) async* {
//     if (event is InitializePersonalGoal) {
//       yield* _initializePersonalGoal(event);
//     } else if (event is DeleteGoal) {
//       yield* _deleteGoal(event);
//     } else if (event is DeleteMilestone) {
//       yield* _deleteMilestone(event);
//     } else if (event is ChangeMilestoneStatus) {
//       yield* _changeMilestoneStatus(event);
//     } else if (event is EditMilestone) {
//       yield* _editMilestone(event);
//     } else if (event is AddSubMilestone) {
//       yield* _addSubMilestone(event);
//     } else if (event is NavigateToChat) {
//       yield* _navigateToChat(event);
//     } else if (event is InitiateCall) {
//       yield* _initiateCall(event);
//     } else if (event is UpdateGoal) {
//       yield* _updateGoal(event);
//     } else if (event is AddMilestone) {
//       yield* _addMilestone(event);
//     }
//   }

//   Stream<ProgressState> _initializePersonalGoal(InitializePersonalGoal event) async* {
//     yield ProgressLoading();
//     try {
//       Goal newGoal;
//       if (event.generateMilestones) {
//         newGoal = await setPersonalGoal(event.goal);
//         event.generateMilestones = false;
//       } else {
//         newGoal = event.goal;
//       }
//       yield ProgressLoaded(goal: newGoal);
//     } catch (error) {
//       yield ProgressError(errorMessage: error.toString());
//     }
//   }

//   Stream<ProgressState> _deleteGoal(DeleteGoal event) async* {
//     try {
//       bool isDeleted = await deleteGoal(event.goal.id!);
//       if (isDeleted) {
//         yield GoalDeleted(goal: event.goal);
//       } else {
//         yield ProgressError(errorMessage: "Failed to delete goal");
//       }
//     } catch (error) {
//       yield ProgressError(errorMessage: error.toString());
//     }
//   }

//   Stream<ProgressState> _deleteMilestone(DeleteMilestone event) async* {
//     try {
//       event.goal.milestones.removeAt(event.index);
//       yield ProgressLoaded(goal: event.goal);
//     } catch (error) {
//       yield ProgressError(errorMessage: error.toString());
//     }
//   }

//   Stream<ProgressState> _changeMilestoneStatus(ChangeMilestoneStatus event) async* {
//     try {
//       event.goal.milestones[event.index].status = event.status;
//       yield ProgressLoaded(goal: event.goal);
//     } catch (error) {
//       yield ProgressError(errorMessage: error.toString());
//     }
//   }

//   Stream<ProgressState> _editMilestone(EditMilestone event) async* {
//     try {
//       event.goal.milestones[event.index].content = event.content;
//       yield ProgressLoaded(goal: event.goal);
//     } catch (error) {
//       yield ProgressError(errorMessage: error.toString());
//     }
//   }

//   Stream<ProgressState> _addSubMilestone(AddSubMilestone event) async* {
//     try {
//       event.goal.milestones[event.index].tasks.add(event.milestone);
//       yield ProgressLoaded(goal: event.goal);
//     } catch (error) {
//       yield ProgressError(errorMessage: error.toString());
//     }
//   }

//   Stream<ProgressState> _navigateToChat(NavigateToChat event) async* {
//     try {
//       // Here, we'll directly navigate to the chat page, but it's not the best practice.
//       // Instead, you could use a separate navigation manager or handle this in the UI listener.
//       yield NavigateToChatState(goalId: event.goalId);
//     } catch (error) {
//       yield ProgressError(errorMessage: error.toString());
//     }
//   }

//   Stream<ProgressState> _initiateCall(InitiateCall event) async* {
//     try {
//       // Similar to the navigateToChat function, this can be handled in the UI listener.
//       yield InitiateCallState(goalId: event.goalId);
//     } catch (error) {
//       yield ProgressError(errorMessage: error.toString());
//     }
//   }

//   Stream<ProgressState> _updateGoal(UpdateGoal event) async* {
//     try {
//       yield ProgressLoaded(goal: event.goal);
//     } catch (error) {
//       yield ProgressError(errorMessage: error.toString());
//     }
//   }

//   Stream<ProgressState> _addMilestone(AddMilestone event) async* {
//     try {
//       event.goal.milestones.add(event.milestone);
//       yield ProgressLoaded(goal: event.goal);
//     } catch (error) {
//       yield ProgressError(errorMessage: error.toString());
//     }
//   }
// }
