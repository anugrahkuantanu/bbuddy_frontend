import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CheckInHomeEvent {}

class UpdateUIEvent extends CheckInHomeEvent {}


abstract class CheckInHomeState {}

class InitialCheckInState extends CheckInHomeState {}

class UpdateUIState extends CheckInHomeState {}


class CheckInHomeBloc extends Bloc<CheckInHomeEvent, CheckInHomeState> {
  final List<Map<String, dynamic>> feelings = [
    {"name": "Angry", "emoji": "😠"},
    {"name": "Anxious", "emoji": "😟"},
    {"name": "Embarrassed", "emoji": "😳"},
    {"name": "Happy", "emoji": "😊"},
    {"name": "Hurt", "emoji": "😢"},
    {"name": "Sad", "emoji": "😔"},
  ];

  CheckInHomeBloc() : super(InitialCheckInState()) {
    on<UpdateUIEvent>((event, emit) async {
      emit(UpdateUIState());
    });
  }
}