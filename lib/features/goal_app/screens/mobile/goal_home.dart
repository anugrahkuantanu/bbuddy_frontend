import '/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../main_app/services/service.dart';
import '../../models/model.dart';
import '../screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/config/config.dart';
import '../blocs/bloc.dart';



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
    final counterStats = Provider.of<CounterStats>(context, listen: false);
    _bloc = GoalBloc(counterStats: counterStats);
    _bloc.add(LoadGoals());
    _bloc.add(CountReflections());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,  // Use the already-initialized _bloc
      child: BlocConsumer<GoalBloc, GoalState>(
        listener: (context, state) {
            if (state is GoalCreatedSuccessfully) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProgressPage(goal: state.goal)),
            ).then((result) {
                _bloc.add(ResetGoal());
            });
          }else if (state is GoalInsufficientReflections) {
            _showDialog(context, state.reason);
          } else if (state is GoalCreationDenied) {
            _showDialog(context, state.reason);
          } else if (state is GoalError) {
            _showDialog(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is GoalLoading) {
            return LoadingUI(title:"Goals");
          }else if (state is GoalHasNotEnoughReflections){
            // return _buildJustPersonalGoalUI(state.personalGoals);
            return _buildFullGoalUI([], state.personalGoals);
          } else if (state is GoalHasEnoughReflections) {
            return _buildFullGoalUI(state.generatedGoals, state.personalGoals);
            // return _buildFullGoalUI(state.generatedGoals, state.personalGoals, true);
          } else if (state is GoalInsufficientReflections) {
            // return _buildInsufficientReflectionsUI();
            return NotEnoughtReflection(response: state.reason);
          }else if (state is GoalCreationDenied) {
            return NotEnoughtReflection(response: state.reason);
          }
           else if (state is GoalError) {
            return ErrorUI(errorMessage: state.errorMessage);
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

  Widget _buildFullGoalUI(List<Goal> generatedGoals, List<Goal> personalGoals) {
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
                                  // context.read<GoalBloc>().add(CreateGeneratedGoals());
                                  _bloc.add(CreateGeneratedGoals());
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
                        (generatedGoals.isNotEmpty) 
                          ? GeneratedGoalsCard(generatedGoals: generatedGoals)
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Card(
                                color: Colors.white,
                                child: Container(
                                  height: 70.0,  // set height to 30px
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                                      child: TextButton(
                                        onPressed: () {
                                          _bloc.add(CreateGeneratedGoals());
                                        },
                                        child: Text(
                                          'Hey there, \nyou dont have any generated Goal.',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,  // adjust the font size as needed
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
}
