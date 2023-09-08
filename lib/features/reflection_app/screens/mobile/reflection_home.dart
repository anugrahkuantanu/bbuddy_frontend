import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../check_in_app/services/service.dart';
import 'view_reflection_results.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/core.dart';
import '../blocs/bloc.dart';
import '../widgets/widget.dart';


class ReflectionHome extends StatefulWidget {
  final int selectedIndex;

  ReflectionHome({Key? key, this.selectedIndex = 1}) : super(key: key);

  @override
  _ReflectionHomeState createState() => _ReflectionHomeState();
}

class _ReflectionHomeState extends State<ReflectionHome> {
  late final ReflectionHomeBloc _bloc;
  
  

  @override
  void initState() {
    super.initState();
    _bloc = ReflectionHomeBloc(checkInService: CheckInService());
    _bloc.add(LoadReflectionHome());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocBuilder<ReflectionHomeBloc, ReflectionHomeState>(
        builder: (context, state) {
            if (state is ReflectionHomeLoading) {
            return LoadingUI(title: "Reflections");
          } else if (state is ReflectionHomeHasEnoughCheckIns) {
            return _buildHasEnoughCheckInsUI(state.history);
          } else if (state is ReflectionHomeInsufficientCheckIns) {
              return NotEnoughtCheckIn(title:'Reflection', response: state.errorMessage);
            // return _buildInsufficientCheckInsUI(state.errorMessage);
          } else if (state is ReflectionHomeError) {
            return ErrorUI(errorMessage: state.errorMessage);
          }
          return Container(); // Fallback
          }
      ),
    );
  }


  Widget _buildHasEnoughCheckInsUI(List history) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: actionsMenu(context),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
          return 
           ReflectionCard(
              heading: history[index].heading!,
              // topicReflections: history[index].topicReflections ?? [],
              topicReflections: history[index].topicReflections!,
              reflection: reflection,
              onTap: (topics, reflection) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewReflectionResults(
                      topics: topics.map((reflectionPerTopic) => reflectionPerTopic.topic).toList(),
                      reflection: reflection,

                    ),
                  ),
                );
              },
              cardWidth: 200.w,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _bloc.add(CreateNewReflectionEvent(context));

        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
