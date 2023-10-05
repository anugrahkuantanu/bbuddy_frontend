import 'package:bbuddy_app/core/utils/app_strings.dart';
import 'package:bbuddy_app/features/check_in_app/services/checkin_service.dart';
import 'package:bbuddy_app/features/reflection_app/blocs/reflection_bloc/reflection_event.dart';
import 'package:bbuddy_app/features/reflection_app/blocs/reflection_bloc/reflection_state.dart';
import 'package:bbuddy_app/features/reflection_app/models/reflection.dart';
import 'package:bbuddy_app/features/reflection_app/services/reflections.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReflectionBloc extends Bloc<ReflectionEvent, ReflectionState> {
  final CheckInService checkInService;
  final ReflectionService reflectionService;

  ReflectionBloc({
    required this.checkInService,
    required this.reflectionService,
  }) : super(ReflectionInitial()) {
    on<InitializeReflectionHomeEvent>(_onInitializeReflectionHome);
    on<CreateNewReflectionEvent>(_onCreateNewReflection);
    on<SubmitReflectionEvent>(_onSubmitReflection);
  }

  Future<void> _onInitializeReflectionHome(
    InitializeReflectionHomeEvent event,
    Emitter<ReflectionState> emit,
  ) async {
    emit(ReflectionLoading());
    try {
      int? checkInCount = await checkInService.countCheckIn();
      if (checkInCount >= 3) {
        List<Reflection> history = await reflectionService.getReflectionHistory();
        emit(ReflectionHasEnoughCheckIns(history));
      } else {
        emit(ReflectionInsufficientCheckIns(
            errorMessage: checkInCount > 0 ? checkInCount.toString() : '3'));
      }
    } catch (error) {
      emit(ReflectionError(AppStrings.errorLoadReflection));
    }
  }

  Future<void> _onCreateNewReflection(
    CreateNewReflectionEvent event,
    Emitter<ReflectionState> emit,
  ) async {
    try {
      int checkInCount = 3; // You may fetch this from your services or any other logic
      if (checkInCount < 3) {
        emit(NeedsMoreCheckIns());
      } else {
        List reflectionTopics = await reflectionService.getReflectionTopics();
        emit(NavigateToNewReflectionPage(reflectionTopics));
      }
    } catch (error) {
      emit(ReflectionError(AppStrings.errorCreateNewReflection));
    }
  }

  Future<void> _onSubmitReflection(
    SubmitReflectionEvent event,
    Emitter<ReflectionState> emit,
  ) async {
    emit(ReflectionSubmittedState(topics: event.topics, userReflections: event.userReflections));
  }
}
