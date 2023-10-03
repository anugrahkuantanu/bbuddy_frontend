import 'package:bbuddy_app/features/check_in_app/models/check_in.dart';

abstract class CheckInHistoryState {}

class CheckInHistoryLoadingState extends CheckInHistoryState {}

class CheckInHistoryLoadedState extends CheckInHistoryState {
  final List<CheckIn> pastCheckIns;

  CheckInHistoryLoadedState(this.pastCheckIns);
}

class CheckInHistoryErrorState extends CheckInHistoryState {
  final String errorMessage;

  CheckInHistoryErrorState(this.errorMessage);
}
