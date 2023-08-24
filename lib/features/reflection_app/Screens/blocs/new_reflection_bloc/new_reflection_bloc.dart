import 'dart:async';
import '../bloc.dart';

class ReflectionBloc {
    final List topics;
    List<String> userReflections;
    final StreamController<ReflectionState> _stateController = StreamController<ReflectionState>.broadcast();

    ReflectionBloc(this.topics) : userReflections = List.filled(topics.length, '') {
        _stateController.add(ReflectionInitialState(userReflections));
    }

    Stream<ReflectionState> get stateStream => _stateController.stream;

    void add_event(ReflectionEvent event) {
        if (event is UpdateReflectionEvent) {
            userReflections[event.index] = event.value;
            _stateController.add(ReflectionUpdatedState(userReflections));
        } else if (event is SubmitReflectionEvent) {
            _stateController.add(ReflectionSubmittedState(topics, userReflections));
        }
    }

    void dispose() {
        _stateController.close();
    }
}
