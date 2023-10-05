import 'package:bbuddy_app/features/goal_app/blocs/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../screens/screen.dart';
import '../../controllers/controller.dart';

// ignore: must_be_immutable
class PersonalGoal extends StatefulWidget {
  List<Goal>? goals;

  PersonalGoal({
    Key? key,
    this.goals = const [],
  }) : super(key: key);

  @override
  _PersonalGoalState createState() => _PersonalGoalState();
}

class _PersonalGoalState extends State<PersonalGoal> {
  Color _getGradientEndColor(int index) {
    List<Color> cardColors = [
      const Color(0xFFb383ff),
      const Color(0xFF65dc99),
      const Color(0xFFff9a96),
      const Color(0xFF68d0ff)
    ];
    return cardColors[index];
  }

  void updateCallBack(Goal goal) {
    setState(() {
      widget.goals![0] = goal;
    });
  }

  void onTap(Goal? goal) {
    if (goal != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProgressController(goal: goal),
          ));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return BlocBuilder<GoalBloc, GoalState>(
            builder: (context, state) {
              String initialValue = '';
              return state is PersonalGoalLoading
                  ? EditDialog(
                      dialogHeading: 'New Goal',
                      initialValue: initialValue,
                      allowNullValues: false,
                      onEdit: (content) {},
                      errorString: "Goal can't be empty",
                      isSaving: true,
                    )
                  : EditDialog(
                      dialogHeading: 'New Goal',
                      initialValue: initialValue,
                      allowNullValues: false,
                      onEdit: (content) {
                        Goal newGoal = Goal(
                            description: content,
                            type: GoalType.personal,
                            milestones: []);
                        initialValue = content;
                        //Navigator.of(context).pop();
                        context.read<GoalBloc>().add(CreatePersonalGoal(
                              goal: newGoal,
                            ));
                      },
                      errorString: "Goal can't be empty",
                      isSaving: false,
                    );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final goalsLength = widget.goals?.length ?? 0;
    final displayGoals = goalsLength < 4
        ? widget.goals! +
            List<Goal>.filled(
                4 - goalsLength, Goal(description: '', milestones: []))
        : widget.goals!;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20.w,
          childAspectRatio: 1.0,
          mainAxisSpacing: 20.w,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(4, (index) {
            final goal = displayGoals[index];
            return PersonalCard(
              onTap: () {
                if (index < goalsLength) {
                  onTap(goal);
                } else {
                  onTap(null);
                }
              },
              title: goal.description.isNotEmpty ? goal.description : null,
              titlesize: 15.w,
              icon: index >= goalsLength ? Icons.add : null,
              gradientStartColor: _getGradientEndColor(index),
              gradientEndColor: _getGradientEndColor(index),
            );
          }),
        ),
      ),
      //),
    );
  }
}
