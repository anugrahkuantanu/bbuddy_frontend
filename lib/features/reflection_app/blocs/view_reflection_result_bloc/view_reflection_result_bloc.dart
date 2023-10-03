import '../../services/service.dart';
import '../../../main_app/services/service.dart';
import 'dart:async';
import '../../blocs/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewReflectionResultBloc
  extends Bloc<ViewReflectionResultEvent, ViewReflectionResultState> {
  final CounterStats counterStats;
  final ReflectionService reflectionService;

  ViewReflectionResultBloc(
      {required this.counterStats, required this.reflectionService})
      : super(ReflectionResultInitialState()) {
    // on<FetchReflectionHeadingEvent>(_fetchReflectionHeadingEvent);
    on<LoadMoodReflectionsEvent>(_loadMoodReflectionsEvent);
  }

  Future<void> _loadMoodReflectionsEvent(LoadMoodReflectionsEvent event,
    Emitter<ViewReflectionResultState> emit) async {
    emit(ReflectionResultLoadingState());

    if (event.reflection != null) {
      emit(ReflectionResultLoadedState(event.reflection!));
    } else {
      try {
        final response = await reflectionService.getMoodReflections(event.topics, event.userReflections, event.heading);
        emit(ReflectionResultLoadedState(response));
        counterStats.resetCheckInCounter();
        counterStats.updateReflectionCounter();
      } catch (e) {
        emit(ReflectionResultErrorState());
      }
    }
  }
}
