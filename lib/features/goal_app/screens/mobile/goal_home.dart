import 'package:bbuddy_app/di/di.dart';
import 'package:bbuddy_app/features/goal_app/services/service.dart';
import 'package:bbuddy_app/features/reflection_app/services/service.dart';

import '/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/model.dart';
import '../screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/config/config.dart';
import '../blocs/bloc.dart';
import '../../controllers/controller.dart';

class GoalHome extends StatefulWidget {
  const GoalHome({Key? key}) : super(key: key);

  @override
  State<GoalHome> createState() => _GoalHomeState();
}

class _GoalHomeState extends State<GoalHome> {
  late final GoalBloc _bloc;
  Widget? _currentView;

  @override
  void initState() {
    super.initState();
    final counterStats = Provider.of<CounterStats>(context, listen: false);
    _bloc = GoalBloc(
        counterStats: counterStats,
        goalService: locator.get<GoalService>(),
        reflectionService: locator.get<ReflectionService>());
    _bloc.add(LoadGoals());
    _bloc.add(CountReflections());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<GoalBloc, GoalState>(
        listener: (context, state) {
          if (state is GoalCreatedSuccessfully) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProgressController(goal: state.goal)),
            );
          } else if (state is GoalInsufficientReflections) {
            DialogHelper.showDialogMessage(context,
                message: state.errorMessage,
                title: AppStrings.insufficientReflections);
          } else if (state is GoalCreationDenied) {
            DialogHelper.showDialogMessage(context,
                message: state.reason, title: AppStrings.goalCreatedTitel);
          } else if (state is GoalError) {
            DialogHelper.showDialogMessage(context,
                message: state.errorMessage);
          }
        },
        child: BlocBuilder<GoalBloc, GoalState>(
          builder: (context, state) {
            if (state is GoalLoading) {
              return LoadingUI();
            } else if (state is GoalHasNotEnoughReflections) {
              _currentView = _buildFullGoalUI([], state.personalGoals);
            } else if (state is GoalHasEnoughReflections) {
              _currentView =
                  _buildFullGoalUI(state.generatedGoals, state.personalGoals);
            }
            return _currentView ??
                Container(); // Always return the current view
          },
        ),
      ),
    );
  }

  Widget _buildFullGoalUI(List<Goal> generatedGoals, List<Goal> personalGoals) {
    ScreenUtil.init(context, designSize: const Size(414, 896));
    var tm = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: actionsMenuLogin(context),
        title: Text('Goals',
            style: TextStyle(
                color:
                    tm.isDarkMode ? AppColors.textlight : AppColors.textdark)),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
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
                                  color: tm.isDarkMode
                                      ? AppColors.textlight
                                      : AppColors.textdark,
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
                                    color: tm.isDarkMode
                                        ? AppColors.textlight
                                        : AppColors.textdark,
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
                                  child: SizedBox(
                                    height: 70.0, // set height to 30px
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w),
                                        child: TextButton(
                                          onPressed: () {
                                            _bloc.add(CreateGeneratedGoals());
                                          },
                                          child: Text(
                                            AppStrings.dontHaveAnyGeneratedGoal,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14
                                                  .w, // adjust the font size as needed
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
                                color: tm.isDarkMode
                                    ? AppColors.textlight
                                    : AppColors.textdark,
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
