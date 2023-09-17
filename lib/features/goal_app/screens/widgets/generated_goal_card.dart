import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/model.dart';
import '../../screens/screen.dart';
import '../../controllers/controller.dart';

class GeneratedGoalsCard extends StatelessWidget {
  final List<Goal?> generatedGoals;

  GeneratedGoalsCard({required this.generatedGoals});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 176.w,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 0.75,
        ),
        itemCount: generatedGoals.length,
        itemBuilder: (context, index) {
          final goal = generatedGoals[index];

          if (goal == null) {
            return Center(child: Text('Goal not Available'));
          }
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: Color(0xFFff9a96),
                width: 1.50,
              ),
            ),
            elevation: 4,
            child: Container(
              alignment: Alignment.center,
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromRGBO(17, 32, 55, 1.0),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProgressController(goal: goal,),
                      ),
                    );
                  },
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 18.0, 8.0, 8.0),
                            child: Text(
                              goal.description,
                              style: TextStyle(
                                decoration: goal.finishedMilestoneCount() == goal.milestones.length
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,  // Adjust the font size if needed
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

