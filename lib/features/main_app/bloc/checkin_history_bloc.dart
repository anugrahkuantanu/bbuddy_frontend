
import 'package:bbuddy_app/features/check_in_app/models/check_in.dart';
import 'package:bbuddy_app/features/check_in_app/services/checkin_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class CheckInHistoryBloc
    extends Bloc<CheckInHistoryEvent, CheckInHistoryState> {
  final CheckInService checkInService;

  CheckInHistoryBloc(this.checkInService)
      : super(CheckInHistoryLoadingState()) {
    on<FetchCheckInHistoryEvent>(_onFetchCheckInHistoryEvent);
  }

  Future<void> _onFetchCheckInHistoryEvent(
      FetchCheckInHistoryEvent event, Emitter<CheckInHistoryState> emit) async {
    emit(CheckInHistoryLoadingState());

    try {
      List<CheckIn> checkIns = await checkInService.getCheckInHistory();
      emit(CheckInHistoryLoadedState(checkIns));
    } catch (error) {
      emit(CheckInHistoryErrorState("Something went wrong !!!"));
    }
  }

  List<String> parseHumanMessage(String text) {
    List<String> sentences = text.split(".");
    List<String> words = sentences[0].split(" ");
    String feelingForm = words[5];
    return [
      feelingForm.replaceFirst(feelingForm[0], feelingForm[0].toUpperCase()),
      sentences.sublist(1, sentences.length).join()
    ];
  }

  List<String> chekinHistory(String text) {
    List<String> sentences = text.split(".");
    List<String> words = sentences[0].split(" ");
    List<String> chekinHistoryList = [words[3], words[5], words[8]];
    for (int i = 1; i < sentences.length; i++) {
      chekinHistoryList.add(sentences[i]);
    }
    return chekinHistoryList;
  }
}