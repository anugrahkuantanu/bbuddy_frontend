import '/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../main_app/services/service.dart';
import '../../models/model.dart';
import '../screen.dart';
import '../widgets/widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/bloc.dart';
import '/config/config.dart';




// UI

class GoalHome extends StatefulWidget {
  const GoalHome({Key? key}) : super(key: key);

  @override
  State<GoalHome> createState() => _GoalHomeState();
}

class _GoalHomeState extends State<GoalHome> {
  
  late final GoalBloc _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
Widget build(BuildContext context) {
  return BlocProvider(
    create: (context) {
      final counterStats = Provider.of<CounterStats>(context, listen: false);
      final _bloc = GoalBloc(counterStats: counterStats);
      _bloc.add(LoadGoals());
      // _bloc.add(CountReflections());
      return _bloc;
    },
    child: BlocConsumer<GoalBloc, GoalState>(
      listener: (context, state) {
        if (state is GoalCreatedSuccessfully) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProgressPage(goal: state.goal)),
          );
        } else if (state is GoalInsufficientReflections) {
          _showDialog(context, 'You do not have enough reflections for goals.');
        } else if (state is GoalCreationDenied) {
          _showDialog(context, state.reason);
        } else if (state is GoalError) {
          _showDialog(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is GoalLoading) {
          return _buildLoadingUI();
        } else if (state is GoalHasEnoughReflections) {
          return _buildHasEnoughReflectionsUI(state.generatedGoals, state.personalGoals);
        } else if (state is GoalInsufficientReflections) {
          return _buildInsufficientReflectionsUI();
        } else if (state is GoalError) {
          return _buildErrorUI(state.errorMessage);
        } else {
          return Container(); // Fallback
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
        content: Text(
          message,
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

  Widget _buildHasEnoughReflectionsUI(List<Goal> generatedGoals, List<Goal> personalGoals) {
    ScreenUtil.init(context, designSize: const Size(414, 896));
    var tm = context.watch<ThemeProvider>();
    return Scaffold(
      backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
      appBar: AppBar(
        backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
        elevation: 0,
        actions: actionsMenuLogin(context),
        title: Text('Goals', style: TextStyle(color: tm.isDarkMode ? AppColors.textlight : AppColors.textdark)),
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
                                  color: tm.isDarkMode ? AppColors.textlight : AppColors.textdark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.w,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<GoalBloc>().add(CreateGeneratedGoals());
                                },
                                child: Text(
                                  "+ Create Goal",
                                  style: TextStyle(
                                    color: tm.isDarkMode ? AppColors.textlight : AppColors.textdark,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14.0.w,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        GeneratedGoalsCard(generatedGoals: generatedGoals), 
                        SizedBox(height: 28.h),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "personal goal",
                              style: TextStyle(
                                color: tm.isDarkMode ? AppColors.textlight : AppColors.textdark,
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
      bottomNavigationBar: BottomBar(),





    );
  }

  Widget _buildInsufficientReflectionsUI() {
    return Scaffold(
      backgroundColor: Color(0xFF2D425F),
      body: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(fontSize: 18.0.w, color: Colors.white),
            children: [
              TextSpan(text: 'You need\n\n'),
              TextSpan(
                text: '3',
                style: TextStyle(fontSize: 52.0.w, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              TextSpan(
                style: TextStyle(fontSize: 18.0.w, color: Colors.white),
                text: '\n\nReflection(s) to set a Goal',
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
