import 'package:flutter/material.dart';
import '../../models/model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../screens/screen.dart';


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
      Color(0xFFb383ff),
      Color(0xFF65dc99),
      Color(0xFFff9a96),
      Color(0xFF68d0ff)
    ];
    return cardColors[index];
  }

  void updateCallBack(Goal goal){
    setState(() {
      widget.goals![0] = goal;
    });
  }

  void onTap(Goal? goal) {
    if (goal != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProgressPage(goal: goal),
          ));
    } else {
      showDialog(
        context: context,
        builder: (context) => EditDialog(
          dialogHeading: 'New Goal',
          initialValue: '',
          allowNullValues: false,
          onEdit: (content) {
            Goal newGoal = Goal(
                description: content, type: GoalType.personal, milestones: []);
            setState(() {
              widget.goals!.insert(0, newGoal);
            });
            Navigator.of(context).pop(); // Close the dialog
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProgressPage(goal: newGoal, generateMilestones: true, updateCallBack: updateCallBack,)
                        ),
                      );
          },
        ),
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
          physics: NeverScrollableScrollPhysics(),
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
    );
  }
}
