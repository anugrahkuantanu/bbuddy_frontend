import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/widget.dart';
import '../../../check_in_app/services/service.dart';
import '../../../check_in_app/models/check_in.dart';
import '../../../check_in_app/screens/screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CheckInHistoryEvent {}

class FetchCheckInHistoryEvent extends CheckInHistoryEvent {}

// STATE
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

class CheckInHistoryCard extends StatelessWidget {
  final Color? textColor;
  final CheckInHistoryBloc bloc;
  final List<Color> cardColors = [
    const Color(0xFF65dc99),
    const Color(0xFFb383ff),
    const Color(0xFF68d0ff),
    const Color(0xFFff9a96),
  ];

  CheckInHistoryCard({
    Key? key,
    required this.bloc,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckInHistoryBloc, CheckInHistoryState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is CheckInHistoryLoadingState) {
          return Center(
            child: SizedBox(
              width: 50.0.w,
              height: 50.0.w,
              child: const CircularProgressIndicator(),
            ),
          );
        } else if (state is CheckInHistoryLoadedState) {
          final pastCheckIns = state.pastCheckIns;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 19.w,
                mainAxisExtent: 150.w,
                mainAxisSpacing: 19.w,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(4, (index) {
                if (index < pastCheckIns.length) {
                  final checkIn = pastCheckIns[index];
                  final history = bloc
                      .chekinHistory(checkIn.messages[0].text.toLowerCase());
                  return CheckInCard(
                    gradientStartColor: cardColors[index % cardColors.length],
                    gradientEndColor: cardColors[index % cardColors.length],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            feeling: history[0],
                            feelingForm: history[1],
                            reasonEntity: history[2],
                            reason: history.last,
                            isPastCheckin: true,
                            aiResponse: checkIn.messages[1].text,
                          ),
                        ),
                      );
                    },
                    title: bloc.parseHumanMessage(checkIn.messages[0].text)[0],
                    body: bloc.parseHumanMessage(checkIn.messages[0].text)[1],
                    text_color: textColor ?? Colors.white,
                  );
                } else {
                  // This is where you return a card with "No check-ins available"
                  return CheckInCard(
                    gradientStartColor: cardColors[index % cardColors.length],
                    gradientEndColor: cardColors[index % cardColors.length],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CheckInHome()),
                      );
                    },
                    title: 'No check-ins available',
                    body: 'No check-ins available',
                    text_color: textColor ?? Colors.white,
                  );
                }
              }),
            ),
          );
        } else if (state is CheckInHistoryErrorState) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 30.w),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                height: 300.h, // Adjusting for the Padding
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    state.errorMessage,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0.w,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Container(); // default return, can be an empty container or some placeholder
      },
    );
  }
}
