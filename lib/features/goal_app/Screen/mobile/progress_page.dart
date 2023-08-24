import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screen.dart';
import '../widgets/widget.dart';
import '../../models/model.dart';
import '../../services/service.dart';
import '../../../main_app/utils/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '/config/config.dart';



// event
abstract class ProgressEvent {}

class InitializePersonalGoal extends ProgressEvent {
  late Goal goal;
  bool generateMilestones;
  InitializePersonalGoal({required this.goal, this.generateMilestones = false});
}

class DeleteGoal extends ProgressEvent {
  final Goal goal;
  DeleteGoal ({required this.goal});
}


class DeleteMilestone extends ProgressEvent {
  final int index;
  final Goal goal;

  DeleteMilestone({
    required this.index,
    required this.goal
  });
}

class ChangeMilestoneStatus extends ProgressEvent {
  final int index;
  final bool status;
  final Goal goal;
  int finishedCount;

  ChangeMilestoneStatus({
  required this.index,
  required this.status,
  required this.goal,
  required this.finishedCount
});

}

class EditMilestone extends ProgressEvent {
  final int index;
  final String content;
  final Goal goal;

  EditMilestone({
    required this.index, 
    required this.content,
    required this.goal
    });
}

class AddSubMilestone extends ProgressEvent {
  final Goal goal;
  final Milestone milestone;
  final int index;


  AddSubMilestone({
    required this.milestone,
    required this.goal,
    required this.index
    });
}

class NavigateToChat extends ProgressEvent {
  final int goalId;

  NavigateToChat({required this.goalId});
}

class InitiateCall extends ProgressEvent {
  final int goalId;

  InitiateCall({required this.goalId});
}

class UpdateGoal extends ProgressEvent {
  final Goal goal;
  UpdateGoal({required this.goal});
}

class AddMilestone extends ProgressEvent {
  final Goal goal;
  final Milestone milestone;

  AddMilestone({required this.goal, required this.milestone});
}






// state
abstract class ProgressState{}

class ProgressLoading extends ProgressState{}

class ProgressLoaded extends ProgressState{
  final Goal goal;
  ProgressLoaded({required this.goal});
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




// bloc

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
      } else {
        newGoal = event.goal;
      }
      yield ProgressLoaded(goal: newGoal);
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
      yield ProgressLoaded(goal: event.goal);
    } catch (error) {
      yield ProgressError(errorMessage: error.toString());
    }
  }

  Stream<ProgressState> _changeMilestoneStatus(ChangeMilestoneStatus event) async* {
    try {
      event.goal.milestones[event.index].status = event.status;
      yield ProgressLoaded(goal: event.goal);
    } catch (error) {
      yield ProgressError(errorMessage: error.toString());
    }
  }

  Stream<ProgressState> _editMilestone(EditMilestone event) async* {
    try {
      event.goal.milestones[event.index].content = event.content;
      yield ProgressLoaded(goal: event.goal);
    } catch (error) {
      yield ProgressError(errorMessage: error.toString());
    }
  }

  Stream<ProgressState> _addSubMilestone(AddSubMilestone event) async* {
    try {
      event.goal.milestones[event.index].tasks.add(event.milestone);
      yield ProgressLoaded(goal: event.goal);
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
      yield ProgressLoaded(goal: event.goal);
    } catch (error) {
      yield ProgressError(errorMessage: error.toString());
    }
  }

  Stream<ProgressState> _addMilestone(AddMilestone event) async* {
    try {
      event.goal.milestones.add(event.milestone);
      yield ProgressLoaded(goal: event.goal);
    } catch (error) {
      yield ProgressError(errorMessage: error.toString());
    }
  }


}



class ProgressPage extends StatefulWidget {
  final Goal goal;
  final bool generateMilestones;
  final Function(Goal goal)? updateCallBack;

  ProgressPage({
    Key? key,
    required this.goal,
    this.generateMilestones = false,
    this.updateCallBack,
  }) : super(key: key);

  @override
  ProgressPageState createState() => ProgressPageState();
}

class ProgressPageState extends State<ProgressPage> {

  late ProgressBloc _progressBloc;

  @override
  void initState() {
    super.initState();
    _progressBloc = ProgressBloc(goal: widget.goal); // Provide necessary services
    _progressBloc.add(InitializePersonalGoal(goal: widget.goal));
  }


  @override
  void dispose() {
    _progressBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _progressBloc,
      child: BlocConsumer<ProgressBloc, ProgressState>(
        listener: (context, state) {
          if (state is NavigateToChatState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GoalChatScreen(goalId: state.goalId!)),
          );
          }
          else if (state is GoalDeleted) {
            Navigator.pushReplacement(context, 
            MaterialPageRoute(builder: (context) => GoalHome()),
            );
          }
          else if (state is ProgressError) {
            _showDialog(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is ProgressLoading){
            return _buildLoadingUI();
          }
          else if (state is ProgressLoaded) {
            return _buildProgressUI(state.goal);
          } 
          else {
            return _buildErrorUI('Unknown Error');  // Fallback
          }
        },
      ),
    );
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingUI() {
  var tm = context.watch<ThemeProvider>();
  return Scaffold(
      backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  Widget _buildProgressUI(Goal goal) {
  int finishedCount = goal.finishedMilestoneCount();
  double text_xl = 20.0.w;
  var tm = context.watch<ThemeProvider>();
  return Scaffold(
    backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
    appBar: AppBar(
      backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
      automaticallyImplyLeading: true,
      title: Text("Progess Page"),
      actions: [
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          onPressed: () {
          _progressBloc.add(DeleteGoal(goal: widget.goal));
          // context.read<ProgressBloc>().add(DeleteGoal(goal: widget.goal));
          },
        ),
      ],
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50.w),
            GoalTrackingWidget(
              finishedCount: finishedCount,
              milestone: goal.milestones.length,
              grafikcolor: Color.fromARGB(255, 59, 157, 157),
            ),
            SizedBox(height: 20.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _progressBloc.add(NavigateToChat(goalId: goal.id!));
                    // context.read<ProgressBloc>().add(NavigateToChat(goalId: goal.id!));
                  },
                  style: ThemeHelper().buttonStyle().copyWith(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(
                          Colors.white,
                        ),
                      ),
                  child: Icon(
                    Icons.chat,
                    size: 24.0.w,
                  ),
                ),
                SizedBox(width: 35.0.w),
                ElevatedButton(
                  onPressed: () => context.read<ProgressBloc>().add(InitiateCall(goalId: goal.id!)),
                  style: ThemeHelper().buttonStyle().copyWith(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(
                          Colors.white,
                        ),
                      ),
                  child: Icon(
                    Icons.call,
                    size: 24.0.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.w),
            Padding(
              padding: EdgeInsets.only(left: 40.0.w, right: 40.0.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: Color(0xFFff9a96),
                      width: 1.50,
                    ),
                  ),
                  color: Color.fromRGBO(17, 32, 55, 1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          goal.description,
                          style: TextStyle(
                            decoration: finishedCount == goal.milestones.length
                                ? TextDecoration.lineThrough
                                : null,
                            fontSize: text_xl,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '',
                    style: TextStyle(
                      fontSize: text_xl,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => EditDialog(
                        dialogHeading: 'New Milestone',
                        initialValue: '',
                        allowNullValues: false,
                        onEdit: (content) {
                          context.read<ProgressBloc>().add(AddMilestone(goal: goal, milestone: Milestone(content: content)));
                          Navigator.of(context).pop(); 
                        }
                      ),
                    );
                  },
                  child: Text(
                    "+ New Milestone",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0.w,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.w),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: goal.milestones.length,
              itemBuilder: (context, index) {
                Milestone milestone = goal.milestones[index];
                return CheckBoxTile(
                  value: milestone.status,
                  onDelete: () {
                    context.read<ProgressBloc>().add(DeleteMilestone(goal: goal, index: index));
                  },
                  onChanged: (bool? value) {
                    if (value != null) {
                      context.read<ProgressBloc>().add(ChangeMilestoneStatus(goal: goal, index: index, status: value, finishedCount: finishedCount));
                    }
                  },
                  onEdit: (content) {
                    context.read<ProgressBloc>().add(EditMilestone(goal: goal, index: index, content: content));
                  },
                  onAdd: () {
                    // Milestone newSubMilestone = Milestone(content: "New Sub-Milestone");
                    // context.read<ProgressBloc>().add(AddSubMilestone(goal: goal, milestone: newSubMilestone, index: index));
                  },
                  onUpdateGoal: () {
                    context.read<ProgressBloc>().add(UpdateGoal(goal: goal));  // Example event to handle goal updates
                  },
                  title: milestone.content,
                  backgroundColor: Color.fromRGBO(17, 32, 55, 1.0),
                  themeColor: Colors.white,
                  tasks: milestone.tasks,
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}



  Widget _buildErrorUI(String errorMessage) {
    return Scaffold(
      backgroundColor: Color(0xFF2D425F),
      body: Center(
        child: Text(
          'Error: $errorMessage',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ),
    );
  }
}
