import 'package:bbuddy_app/features/reflection_app/blocs/reflection_home_bloc/reflection_home_bloc.dart';
import 'package:bbuddy_app/features/reflection_app/blocs/reflection_home_bloc/reflection_home_event.dart';
import 'package:bbuddy_app/features/reflection_app/blocs/reflection_home_bloc/reflection_home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/core.dart';
import '../widgets/widget.dart';

class ReflectionHome extends StatefulWidget {
  final int selectedIndex;

  const ReflectionHome({
    Key? key,
    this.selectedIndex = 1,
  }) : super(key: key);

  @override
  _ReflectionHomeState createState() => _ReflectionHomeState();
}

class _ReflectionHomeState extends State<ReflectionHome> {
  Widget? _currentView;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReflectionHomeBloc, ReflectionHomeState>(
      listener: (context, state) {
        if (state is NavigateToNewReflectionPage) {
          Nav.toNamed(context, '/newreflections',
              arguments: {'topics': state.reflectionTopics});
        }
        if (state is NeedsMoreCheckIns) {
          DialogHelper.showDialogMessage(context,
              message: AppStrings.reflectionCheckInMessage,
              title: AppStrings.notEnoughtCheckInTitel);
        }
      },
      builder: (context, state) {
        if (state is ReflectionHomeLoading) {
          _currentView = const LoadingUI();
        } else if (state is ReflectionHomeHasEnoughCheckIns) {
          _currentView = _buildHasEnoughCheckInsUI(state.history);
        } else if (state is ReflectionHomeInsufficientCheckIns) {
          _currentView = NotEnoughtCheckIn(
              title: 'Reflection',
              response: state.neededCheckInCount.toString());
        } else if (state is ReflectionHomeError) {
          _currentView = ErrorUI(errorMessage: state.errorMessage);
        }
        return _currentView ?? Container(); // Fallback
      },
    );
  }

  Widget _buildHasEnoughCheckInsUI(List history) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflections'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16.0.w, right: 16.w, left: 16.w),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.0.w,
            crossAxisSpacing: 16.0.w,
            childAspectRatio: 0.75,
          ),
          itemCount: history.length,
          itemBuilder: (context, index) {
            final reflection = history[index]!;
            return ReflectionCard(
              heading: history[index].heading!,
              // topicReflections: history[index].topicReflections ?? [],
              topicReflections: history[index].topicReflections!,
              reflection: reflection,
              onTap: (topics, reflection) {
                Nav.to(
                  context,
                  '/viewreflections',
                  arguments: {
                    'topics': topics
                        .map((reflectionPerTopic) => reflectionPerTopic.topic)
                        .toList(),
                    'reflection': reflection,
                  },
                );
              },
              cardWidth: 200.w,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context
              .read<ReflectionHomeBloc>()
              .add(CreateNewReflectionEvent(context));
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
