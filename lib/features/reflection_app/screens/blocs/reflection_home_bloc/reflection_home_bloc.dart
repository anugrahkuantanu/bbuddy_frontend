import 'package:bbuddy_app/core/core.dart';
import '../../../services/service.dart';
import '../../../../main_app/services/service.dart';
import '../../../models/model.dart';
import 'package:provider/provider.dart';
import '../../blocs/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../check_in_app/services/service.dart';


class ReflectionHomeBloc extends Bloc<ReflectionHomeEvent, ReflectionHomeState> {
  final CheckInService? checkInService;

  ReflectionHomeBloc({required this.checkInService}) : super(ReflectionHomeInitial()) {
  on<LoadReflectionHome>(_loadReflectionHome);
  on<CreateNewReflectionEvent>(_createNewReflection);
}

  Future<void> _loadReflectionHome(LoadReflectionHome event, Emitter<ReflectionHomeState> emit) async {
    emit(ReflectionHomeLoading());
    
    try {
      int? checkInCount = await checkInService!.countCheckIn();
      int modulo = checkInCount % 3;
      int checkInNeeded = 3 - modulo;
      if (checkInCount >= 3) {
        List<Reflection> history = await getReflectionHistory() ?? [];
        emit(ReflectionHomeHasEnoughCheckIns(history));
      } else {
        emit(ReflectionHomeInsufficientCheckIns(errorMessage: checkInNeeded.toString()));
      }
    } catch (error) {
      emit(ReflectionHomeError(AppStrings.errorLoadReflection));
    }
  }

  Future<void> _createNewReflection(CreateNewReflectionEvent event, Emitter<ReflectionHomeState> emit) async {
    try {
      final counterStats = Provider.of<CounterStats>(event.context, listen: false);
      int checkInCount = int.tryParse(counterStats.checkInCounter!.value) ?? 0;
      
      if (checkInCount < 3) {
        emit(NeedsMoreCheckIns()); // This state indicates the need for more check-ins.
      } else {
        List<Reflection> history = await getReflectionHistory() ?? [];
        emit(ReflectionHomeHasEnoughCheckIns(history));

        List reflectionTopics = await getReflectionTopics() ?? [];
        emit(NavigateToNewReflectionPage(reflectionTopics));


        // List<Reflection> history = await getReflectionHistory();
        // emit(ReflectionHomeHasEnoughCheckIns(history));

        // List reflectionTopics = await getReflectionTopics();
        // emit(NavigateToNewReflectionPage(reflectionTopics)); // This state indicates the need to navigate.
      }
    } catch (error) {
      emit(ReflectionHomeError(AppStrings.errorCreateNewReflection));
    }
  }
}