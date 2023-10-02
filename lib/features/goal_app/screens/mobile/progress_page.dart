import 'package:bbuddy_app/di/di.dart';
import 'package:bbuddy_app/features/goal_app/services/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screen.dart';
import '../../models/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/utils/utils.dart';
import '../../blocs/bloc.dart';

class ProgressPage extends StatefulWidget {
  final Goal goal;
  final bool generateMilestones;
  final Function(Goal goal)? updateCallBack;

  const ProgressPage({
    Key? key,
    required this.goal,
    // this.generateMilestones = false,
    required this.generateMilestones,
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

    _progressBloc = ProgressBloc(
        goal: widget.goal,
        goalService: locator.get<GoalService>()); // Provide necessary services
    _progressBloc.add(InitializePersonalGoal(
        goal: widget.goal, generateMilestones: widget.generateMilestones));
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
              MaterialPageRoute(
                  builder: (context) => GoalChatPage(goalId: state.goalId)),
            );
          } else if (state is GoalDeleted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const GoalHome()),
            );
          } else if (state is ProgressError) {
            _showDialog(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is ProgressLoading) {
            return LoadingUI();
          } else if (state is ProgressLoaded) {
            return _buildProgressUI(state.goal);
          } else {
            return const ErrorUI(
                errorMessage: "Some error occurred"); // Fallback
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
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressUI(Goal goal) {
    int finishedCount = goal.finishedMilestoneCount();
    double textXl = 20.0.w;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back), // add your custom icon here
        //   onPressed: () {
        //     Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => GoalHome()),
        //   );
        //  },
        // ),
        title: const Text("Progess Page"),
        actions: [
          IconButton(
            icon: const Icon(
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
                grafikcolor: const Color.fromARGB(255, 59, 157, 157),
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
                          backgroundColor: MaterialStateProperty.all<Color>(
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
                    onPressed: () => context
                        .read<ProgressBloc>()
                        .add(InitiateCall(goalId: goal.id!)),
                    style: ThemeHelper().buttonStyle().copyWith(
                          backgroundColor: MaterialStateProperty.all<Color>(
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
                      side: const BorderSide(
                        color: Color(0xFFff9a96),
                        width: 1.50,
                      ),
                    ),
                    color: const Color.fromRGBO(17, 32, 55, 1.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            goal.description,
                            style: TextStyle(
                              decoration:
                                  finishedCount == goal.milestones.length
                                      ? TextDecoration.lineThrough
                                      : null,
                              fontSize: textXl,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '',
                      style: TextStyle(
                        fontSize: textXl,
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
                              _progressBloc.add(AddMilestone(
                                  goal: goal,
                                  milestone: Milestone(content: content)));
                              // context.read<ProgressBloc>().add(AddMilestone(goal: goal, milestone: Milestone(content: content)));
                              Navigator.of(context).pop();
                            }),
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
                physics: const NeverScrollableScrollPhysics(),
                itemCount: goal.milestones.length,
                itemBuilder: (context, index) {
                  Milestone milestone = goal.milestones[index];
                  List<Milestone> milestones = goal.milestones;
                  return CheckBoxTile(
                    value: milestone.status,
                    onDelete: () {
                      _progressBloc
                          .add(DeleteMilestone(goal: goal, index: index));
                    },
                    onChanged: (bool? value) {
                      if (value != null) {
                        _progressBloc.add(ChangeMilestoneStatus(
                            goal: goal,
                            index: index,
                            status: value,
                            finishedCount: finishedCount));
                      }
                    },
                    onEdit: (content) {
                      _progressBloc.add(EditMilestone(
                          goal: goal, index: index, content: content));
                    },
                    onAdd: () {
                      // Milestone newSubMilestone = Milestone(content: "New Sub-Milestone");
                      // context.read<ProgressBloc>().add(AddSubMilestone(goal: goal, milestone: newSubMilestone, index: index));
                    },
                    onUpdateGoal: () {
                      _progressBloc.add(UpdateGoal(
                          goal: goal,
                          milestone: milestones)); // NEED TO BE CHECK AGAIN
                    },
                    title: milestone.content,
                    backgroundColor: const Color.fromRGBO(17, 32, 55, 1.0),
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
}
