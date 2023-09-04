import 'dart:async';
import '../bloc.dart';

class NewReflectionBloc {
    final List topics;
    List<String> userReflections;
    final StreamController<NewReflectionState> _stateController = StreamController<NewReflectionState>.broadcast();

    NewReflectionBloc(this.topics) : userReflections = List.filled(topics.length, '') {
        _stateController.add(ReflectionInitialState(userReflections));
    }

    Stream<NewReflectionState> get stateStream => _stateController.stream;

    void add_event(NewReflectionEvent event) {
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
