import 'package:flutter/material.dart';
import '../../../services/service.dart';
import '../../../../main_app/services/service.dart';
import '../../../models/model.dart';
import 'package:provider/provider.dart';
import '../../blocs/bloc.dart';
import '../../screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../check_in_app/services/service.dart';


class ReflectionHomeBloc extends Bloc<ReflectionHomeEvent, ReflectionHomeState> {
  final CheckInService checkInService;

  ReflectionHomeBloc({required this.checkInService}) : super(ReflectionHomeInitial());

  @override
  Stream<ReflectionHomeState> mapEventToState(ReflectionHomeEvent event) async* {
      if (event is LoadReflectionHome) {
          yield* _loadReflectionHome();
      } else if (event is CreateNewReflectionEvent) {
          yield* _createNewReflection(event.context);
      }
  }

 Stream<ReflectionHomeState> _loadReflectionHome() async* {
    yield ReflectionHomeLoading();
    
    try {
      int checkInCount = await checkInService.countCheckIn();
      if (checkInCount >= 3) {
        List<Reflection> history = await getReflectionHistory(); 
        yield ReflectionHomeHasEnoughCheckIns(history);
      } else {
        yield ReflectionHomeInsufficientCheckIns();
      }
    } catch (error) {
      yield ReflectionHomeError("Failed to load reflection home.");
    }
  }

  Stream<ReflectionHomeState> _createNewReflection(BuildContext context) async* {
      try {
          final counterStats = Provider.of<CounterStats>(context, listen: false);
          int checkInCount = int.tryParse(counterStats.checkInCounter!.value) ?? 0;
        
          if (checkInCount < 3) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                      return AlertDialog(
                          content: Text(
                              "You need at least 3 check-ins to create a new reflection.",
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
              List<Reflection> history = await getReflectionHistory();
              yield ReflectionHomeHasEnoughCheckIns(history);
              List reflectionTopics = await getReflectionTopics();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewReflection(topics: reflectionTopics),
                  ),
              );
          }
      } catch (error) {
          yield ReflectionHomeError("An error occurred while trying to create a new reflection.");
      }
  }
}