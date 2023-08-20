import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import '../../../../reflection_app/services/service.dart';
import 'package:provider/provider.dart';
import '../../../../main_app/services/service.dart';
import 'dart:async';
import '../../../services/service.dart';
import '../../../models/model.dart';
import '../../screen.dart';
import '../../../widgets/widget.dart';

class GoalHome extends StatefulWidget {
  const GoalHome({
    Key? key,
  }) : super(key: key);

  @override
  State<GoalHome> createState() => GoalHomeState();
}

class GoalHomeState extends State<GoalHome> {
  //late List<Goal> history;
  late List<Goal> generatedGoals;
  late List<Goal> personalGoals;
  bool _isLoading = true;
  bool _hasEnoughReflections = false;
  int count = 0;

  final String notEnoughReflectionsForGoals =
      "You don't have enough reflections to generate a new goal. Please generate more reflections consistently so we can help and recommend better goals for you.";
  final String goalAlreadyCreated =
      "You have already created a goal this week. Please focus on achieving the milestones for that goal. We will recommend a new goal next week, based on your reflections. We are also working on support for multiple goals. We appreciate your patience.";

  @override
  void initState() {
    super.initState();
    loadPage();
  }

  Future<void> loadPage() async {
    final history = await getGoalHistory();
    generatedGoals = history
        .where((goal) => goal.type == GoalType.generated || goal.type == null)
        .toList();
    loadGeneratedGoals();
    
    personalGoals =
        history.where((goal) => goal.type == GoalType.personal).toList();
  }

  void loadGeneratedGoals() async {
    if (generatedGoals.isEmpty) {
      int totalReflections = await countReflections();
      if (totalReflections < 3) {
        count = (totalReflections > 0) ? (3 - totalReflections) : 0;
        setState(() {
          _hasEnoughReflections = false;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasEnoughReflections = true;
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _hasEnoughReflections = true;
        _isLoading = false;
      });
    }
  }

  void newGoal(BuildContext context) {
    if (generatedGoals.isEmpty) {
      createNewGoal(context);
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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                goalAlreadyCreated,
                maxLines: 7,
                //overflow: TextOverflow.ellipsis,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        createNewGoal(context);
      }
    }
  }

  Future<void> createNewGoal(BuildContext context,
      {DateTime? startDate, DateTime? endDate}) async {
    setState(() {
      _isLoading = true;
    });

    // Fetch the results
    final counter_stats = Provider.of<CounterStats>(context, listen: false);
    if (int.tryParse(counter_stats.reflectionCounter!.value)! < 3) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              notEnoughReflectionsForGoals,
              maxLines: 5,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      Goal goal = await setNewGoal(startDate: startDate, endDate: endDate);
      counter_stats.resetReflectionCounter();
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProgressPage(goal: goal)),
      );
    }
  }

  Widget buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Color(0xFF2D425F),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildGoalsScreen() {
    double screenWidth = MediaQuery.of(context).size.width;

    ScreenUtil.init(context, designSize: Size(414, 896));
    double textSizeHeadline = 20.sp;
    double textSize = 18.sp;

    return Scaffold(
      backgroundColor: Color(0xFF2D425F),
      appBar: AppBar(
        backgroundColor: Color(0xFF2D425F),
        elevation:
            0, // Remove the line dividing the AppBar and the rest of the screen
        title: Text(
          'Goals',
          style: TextStyle(
            color: Colors.white, // Set the color of the font to white
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(18.w, 28.w, 10.w, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "AI generated goal",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.w,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  newGoal(context);
                                },
                                child: Text(
                                  "+ Create Goal",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14.0.w,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          height: 176.w,
                          child: GridView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 16.0,
                              crossAxisSpacing: 16.0,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: generatedGoals.length,
                            itemBuilder: (context, index) {
                              return Card(
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(20),
                                // ),
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
                                    //gradient: getRandomGradient(colorDictionary),
                                    // Use the random gradient
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProgressPage(
                                              goal: generatedGoals[index]),
                                        ),
                                      );
                                    },
                                    child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                           padding: const EdgeInsets.fromLTRB(8.0, 18.0, 8.0, 8.0),
                                            child: Text(
                                              generatedGoals[index].description,
                                              style: TextStyle(
                                                decoration: generatedGoals[index]
                                                            .finishedMilestoneCount() ==
                                                        generatedGoals[index]
                                                            .milestones
                                                            .length
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                                //color: Colors.black,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: textSizeHeadline,
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
                        ),
                        SizedBox(height: 28.h),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "personal goal",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.w,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.w),
                          child: PersonalGoal(goals: personalGoals),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*Widget buildNoReflectionsScreen() {
    const text_color = Colors.white;
    return Scaffold(
      backgroundColor: Color(0xFF2D425F),
      body: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 18.0,
              color: text_color,
            ),
            children: [
              TextSpan(
                text: 'You need\n\n',
              ),
              TextSpan(
                text: count > 0 ? '$count' : '3',
                style: TextStyle(
                  fontSize: 52.0,
                  fontWeight: FontWeight.bold,
                  color: text_color,
                ),
              ),
              TextSpan(
                style: TextStyle(
                  fontSize: 18.0,
                  color: text_color,
                ),
                text: '\n\nReflection(s) to set a Goal',
              ),
            ],
          ),
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return buildLoadingScreen();
    } else {
      return buildGoalsScreen();
    }
  }

  void onSeeAllTapped() {}

  void onDepressionHealingTapped() {}

  void onSearchIconTapped() {}

  // Function to generate a random color
  List<List<Color>> colorDictionary = [
    [
      Color.fromARGB(255, 151, 217, 181),
      Color(0xFF65DC9A)
    ], // Blue and Light Blue
    [
      Color.fromARGB(255, 244, 180, 178),
      Color(0xFFFF9A96)
    ], // Green and Light Green
    [
      Color.fromARGB(255, 227, 204, 119),
      Color.fromARGB(255, 234, 207, 101)
    ], // Yellow and Light Yellow
    [
      Color.fromARGB(255, 144, 211, 246),
      Color(0xFF74CEFF)
    ], // Purple and Light Purple
    [
      Color.fromARGB(255, 134, 210, 200),
      Color(0xFF69DCCD)
    ], // Pink and Light Pink
    [
      Color.fromARGB(255, 195, 163, 244),
      Color(0xFFB484FE)
    ], // Pink and Light Pink
  ];

  Color getRandomColor(List<List<Color>> colorDictionary) {
    final random = Random();
    final index = random.nextInt(colorDictionary.length);
    final colorList = colorDictionary[index];
    final baseColor = colorList[0];
    final lightColor = colorList[1];
    return random.nextBool() ? baseColor : lightColor;
  }

  Gradient getRandomGradient(List<List<Color>> colorDictionary) {
    final random = Random();
    final index = random.nextInt(colorDictionary.length);
    final baseColor = colorDictionary[index][0];
    final lightColor = colorDictionary[index][1];
    return LinearGradient(
      colors: [baseColor, lightColor],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );
  }
}
