import '/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/model.dart';
import '../screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/bloc.dart';
import '../../controllers/controller.dart';

// ignore: must_be_immutable
class GoalHome extends StatelessWidget {
  List<Goal>? personalGoals;
  List<Goal>? generatedGoals;

  GoalHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<GoalBloc, GoalState>(
      listener: (context, state) {
        if (state is GoalCreatedSuccessfully) {
          if (state.closeDialog) {
            Navigator.pop(context);
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProgressController(goal: state.goal),
            ),
          );
        } else if (state is GoalInsufficientReflections) {
          DialogHelper.showDialogMessage(context,
              message: state.errorMessage,
              title: AppStrings.insufficientReflections);
        } else if (state is GoalCreationDenied) {
          DialogHelper.showDialogMessage(context,
              message: state.reason, title: AppStrings.goalCreatedTitel);
        }
      },
      child: BlocBuilder<GoalBloc, GoalState>(
        builder: (context, state) {
          if (state is GoalLoading) {
            return const LoadingUI();
          } else if (state is GoalLoaded) {
            personalGoals = state.personalGoals;
            generatedGoals = state.generatedGoals;
            return _buildFullGoalUI(
                context, state.generatedGoals, state.personalGoals);
          } else if (state is GoalError) {
            return ErrorUI(errorMessage: state.errorMessage);
          }
          return _buildFullGoalUI(
              context, generatedGoals!, personalGoals!); // Default state
        },
      ),
    );
  }

  Widget _buildFullGoalUI(BuildContext context, List<Goal> generatedGoals,
      List<Goal> personalGoals) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Goals',
        ),
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
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.w,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<GoalBloc>()
                                      .add(CreateGeneratedGoals());
                                },
                                child: Text(
                                  "+ Create Goal",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .color,
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
                                            context
                                                .read<GoalBloc>()
                                                .add(CreateGeneratedGoals());
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
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .color,
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
