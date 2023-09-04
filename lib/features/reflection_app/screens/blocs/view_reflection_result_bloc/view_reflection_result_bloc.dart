import '../../../services/service.dart';
import '../../../../main_app/services/service.dart';
import '../../../models/model.dart';
import 'dart:async';
import '../../blocs/bloc.dart';



class ViewReflectionResultBloc {
  final CounterStats counterStats;
  final _stateController = StreamController<ViewReflectionResultState>();
  StreamSink<ViewReflectionResultState> get _inState => _stateController.sink;
  Stream<ViewReflectionResultState> get state => _stateController.stream;

  final _eventController = StreamController<ViewReflectionResultEvent>();
  Sink<ViewReflectionResultEvent> get eventSink => _eventController.sink;

  ViewReflectionResultBloc({required this.counterStats}) {
    _eventController.stream.listen(_mapEventToState);
  }



  void _mapEventToState(ViewReflectionResultEvent event) async {
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
