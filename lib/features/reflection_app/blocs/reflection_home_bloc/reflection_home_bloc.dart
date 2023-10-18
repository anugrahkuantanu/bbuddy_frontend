import 'package:bbuddy_app/core/core.dart';
import '../../services/service.dart';
import '../../models/model.dart';
import 'package:provider/provider.dart';
import '../../blocs/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../check_in_app/services/service.dart';

class ReflectionHomeBloc
    extends Bloc<ReflectionHomeEvent, ReflectionHomeState> {
  final CheckInService checkInService;
  final ReflectionService reflectionService;

  ReflectionHomeBloc(
      {required this.checkInService, required this.reflectionService})
      : super(ReflectionHomeInitial()) {
    on<InitializeReflectionHomeEvent>(_onInitializeReflectionHomeEvent);
    on<CreateNewReflectionEvent>(_createNewReflection);
    on<UpdateNeedCheckInCount>(_updatedNeededCheckInCount);
  }

  Future<void> _onInitializeReflectionHomeEvent(
      InitializeReflectionHomeEvent event,
      Emitter<ReflectionHomeState> emit) async {
    emit(ReflectionHomeLoading());
    try {
      int? checkInCount = await checkInService.countCheckIn();
      if (checkInCount >= 3) {
        List<Reflection> history =
            await reflectionService.getReflectionHistory();
        emit(ReflectionHomeHasEnoughCheckIns(history));
      } else {
        emit(ReflectionHomeInsufficientCheckIns(
            neededCheckInCount: checkInCount > 0 ? checkInCount : 3));
      }
    } catch (error) {
      emit(ReflectionHomeError(AppStrings.errorLoadReflection));
    }
  }

  Future<void> _createNewReflection(
      CreateNewReflectionEvent event, Emitter<ReflectionHomeState> emit) async {
    emit(ReflectionHomeLoading());
    try {
      final counterStats =
          Provider.of<CounterStats>(event.context, listen: false);
      int checkInCount = int.tryParse(counterStats.checkInCounter!.value) ?? 0;
      //int checkInCount =3;

      if (checkInCount < 3) {
        emit(
            NeedsMoreCheckIns()); // This state indicates the need for more check-ins.
      } else {
        emit(ReflectionHomeLoading());
        List reflectionTopics = await reflectionService.getReflectionTopics();
        emit(NavigateToNewReflectionPage(reflectionTopics));
      }
    } catch (error) {
      emit(ReflectionHomeError(AppStrings.errorCreateNewReflection));
    }
  }

  Future<void> _updatedNeededCheckInCount(
      UpdateNeedCheckInCount event, Emitter<ReflectionHomeState> emit) async {
    if (event.neededCheckInCount > 0) {
      emit(ReflectionHomeInsufficientCheckIns(
          neededCheckInCount: event.neededCheckInCount));
    } else {
      emit(ReflectionHomeHasEnoughCheckIns([]));
    }
  }
}
