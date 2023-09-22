import '../../../services/service.dart';
import '../../../../main_app/services/service.dart';
import '../../../models/model.dart';
import 'dart:async';
import '../../blocs/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




class ViewReflectionResultBloc extends Bloc<ViewReflectionResultEvent, ViewReflectionResultState> {
  final CounterStats counterStats;
  final Future<String> Function(List topics) fetchHeading;

  ViewReflectionResultBloc({
    required this.counterStats, required this.fetchHeading
  }) : super(ReflectionResultInitialState()) {
    on<FetchReflectionHeadingEvent>(_fetchReflectionHeadingEvent);
    on<LoadMoodReflectionsEvent>(_loadMoodReflectionsEvent);
  }

  Future<void> _loadMoodReflectionsEvent(LoadMoodReflectionsEvent event, Emitter<ViewReflectionResultState> emit) async {
    emit(ReflectionResultLoadingState());

    if (event.reflection != null) {
      emit(ReflectionResultLoadedState(event.reflection!));
    } else {
      try {
        final response = await getMoodReflections(event.topics, event.userReflections, event.heading);
        if (response is Reflection) {
          emit(ReflectionResultLoadedState(response));
          counterStats.resetCheckInCounter();
          counterStats.updateReflectionCounter();
        } else {
          emit(ReflectionResultErrorState());
        }
      } catch (e) {
        emit(ReflectionResultErrorState());
      }
    }
  }

  Future<void> _fetchReflectionHeadingEvent(
  FetchReflectionHeadingEvent event,
    Emitter<ViewReflectionResultState> emit) async {
    try {
      final heading = await fetchHeading(event.topics); // Use the refactored service method
      emit(ReflectionHeadingLoadedState(heading));
    } catch (e) {
      emit(ReflectionHeadingErrorState(e.toString()));
    }
  }
}


