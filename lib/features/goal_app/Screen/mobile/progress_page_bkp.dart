import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screen.dart';
import '../widgets/widget.dart';
import '../../models/model.dart';
import '../../services/service.dart';
import '../../../main_app/utils/helpers.dart';

@immutable
class ProgressPage extends StatefulWidget {
  late Goal goal;
  bool generateMilestones;
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
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    if (widget.generateMilestones) {
      initializePersonalGoal();
    }
  }

  Future<void> initializePersonalGoal() async {
    Goal newGoal = await setPersonalGoal(widget.goal);
    setState(() {
      widget.goal = newGoal;
      widget.generateMilestones = false;
    });
    widget.updateCallBack!(widget.goal);
  }

  onDelete(BuildContext context, Goal goal) async {
    setState(() {
      isLoading = true;
    });
    bool isDeleted = await deleteGoal(goal.id!);
    setState(() {
      isLoading = false;
    });
    if (isDeleted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GoalHome()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Something went worng!!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Perform some action when the user presses the 'OK' button.
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget build(BuildContext context) {
    Goal goal = widget.goal;
    int finishedCount = goal.finishedMilestoneCount();
    double screenWidth = MediaQuery.of(context).size.width;
    double text_m = 18.w;
    double text_xl = 20.0.w;
    Color backgroundCardColor = Colors.white;
    Color text_color = Color(0xFFff9a96);
    Color grafikcolor = Color.fromARGB(255, 59, 157, 157);
    return Scaffold(
      backgroundColor: Color(0xFF2D425F),
      appBar: AppBar(
        backgroundColor: Color(0xFF2D425F),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            isLoading
                ? CircularProgressIndicator()
                : IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Add your delete functionality here
                      onDelete(context, goal);
                    },
                  ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: widget.generateMilestones
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                // Wrap the content in SingleChildScrollView
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 50.w,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: GoalTrackingWidget(
                        finishedCount: finishedCount,
                        milestone: goal.milestones.length,
                        grafikcolor: grafikcolor,
                      ),
                    ),
                    SizedBox(height: 20.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Chat button pressed
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      GoalChatScreen(goalId: goal.id!)),
                            );
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
                          onPressed: () {
                            // Call button pressed
                          },
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
                    SizedBox(
                      height: 20.w,
                    ),
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
                                    decoration:
                                        finishedCount == goal.milestones.length
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
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // or MainAxisAlignment.start, depending on your desired layout
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
                                  setState(() {
                                    goal.milestones
                                        .add(Milestone(content: content));
                                  });
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  updateGoal(goal);
                                },
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
                        )
                      ],
                    ),
                    SizedBox(height: 20.w),
                    Container(
                      //height: 200, // Adjust the height as needed
                      child: ListView.builder(
                        shrinkWrap: true,
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount: goal.milestones.length,
                        itemBuilder: (context, index) {
                          Milestone milestone = goal.milestones[index];
                          void updateGoalCallback() {
                            updateGoal(goal);
                          }

                          return CheckBoxTile(
                            value: milestone.status,
                            onDelete: () {
                              // Remove the milestone from the list
                              setState(() {
                                goal.milestones.removeAt(index);
                              });
                              updateGoalCallback();
                            },
                            onChanged: (value) {
                              // Handle checkbox state change
                              setState(() {
                                milestone.status = value;
                                finishedCount = goal.finishedMilestoneCount();
                              });
                              updateGoalCallback();
                            },
                            onEdit: (content) {
                              // Update the milestone text
                              setState(() {
                                goal.milestones[index].content = content;
                              });
                              updateGoalCallback();
                            },
                            onAdd: () {
                              // setState(() {
                              //   milestone.tasks
                              //       .add(Milestone(content: "New Sub-Milestone"));
                              // });
                              // updateGoalCallback();
                            },
                            onUpdateGoal: updateGoalCallback,
                            title: milestone.content,
                            backgroundColor: Color.fromRGBO(17, 32, 55, 1.0),
                            themeColor: Colors.white,
                            tasks: milestone.tasks,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
