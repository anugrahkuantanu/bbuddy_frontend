import '../../../reflection_app/services/service.dart';
import '../../../main_app/services/service.dart';
import '../../models/model.dart';
import 'dart:async';
import '../../blocs/bloc.dart';



class ReflectionResultBloc {
  final CounterStats counterStats;
  final _stateController = StreamController<ReflectionResultState>();
  StreamSink<ReflectionResultState> get _inState => _stateController.sink;
  Stream<ReflectionResultState> get state => _stateController.stream;

  final _eventController = StreamController<ReflectionResultEvent>();
  Sink<ReflectionResultEvent> get eventSink => _eventController.sink;

  ReflectionResultBloc({required this.counterStats}) {
    _eventController.stream.listen(_mapEventToState);
  }



  void _mapEventToState(ReflectionResultEvent event) async {
      if (event is LoadMoodReflections) {
          _inState.add(ReflectionResultLoading());
          if (event.reflection != null) {
              _inState.add(ReflectionResultLoaded(event.reflection!));
          } else {
              try {
                  final response = await getMoodReflections(event.topics, event.userReflections, event.heading);
                  if (response is Reflection) {
                      _inState.add(ReflectionResultLoaded(response));
                      counterStats.resetCheckInCounter();
                      counterStats.updateReflectionCounter();

                  } else {
                      _inState.add(ReflectionResultError());
                  }
              } catch (e) {
                  _inState.add(ReflectionResultError());
              }
          }
      }
  }



  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
