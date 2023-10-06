import '../bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class NewReflectionBloc extends Bloc<NewReflectionEvent, NewReflectionState> {
  final List topics;
  List<String> userReflections;

  NewReflectionBloc(this.topics)
      : userReflections = List.filled(topics.length, ''),
        super(ReflectionInitialState(userReflections: List.filled(topics.length, ''))) {
    on<UpdateReflectionEvent>(_updateReflection);
    on<SubmitReflectionEvent>(_submitReflection);
  }
  
  void _updateReflection(UpdateReflectionEvent event, Emitter<NewReflectionState> emit) {
    userReflections[event.index] = event.value;
    emit(ReflectionUpdatedState(userReflections: userReflections));
  }

  void _submitReflection(SubmitReflectionEvent event, Emitter<NewReflectionState> emit) {
    emit(ReflectionSubmittedState(topics: topics, userReflections: userReflections));
  }
}

