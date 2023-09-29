import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/widget.dart';
import '../../../check_in_app/services/service.dart';
import '../../../check_in_app/models/check_in.dart';
import '../../../check_in_app/screens/screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


abstract class CheckInHistoryEvent {}

class FetchCheckInHistoryEvent extends CheckInHistoryEvent {}


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





class CheckInHistoryBloc extends Bloc<CheckInHistoryEvent, CheckInHistoryState> {
  final CheckInService checkInService;

  CheckInHistoryBloc(this.checkInService) : super(CheckInHistoryLoadingState()) {
    on<FetchCheckInHistoryEvent>(_onFetchCheckInHistoryEvent);
  }

Future<void> _onFetchCheckInHistoryEvent(
    FetchCheckInHistoryEvent event, Emitter<CheckInHistoryState> emit) async {
    emit(CheckInHistoryLoadingState());

    try {
        List<CheckIn> checkIns = await checkInService.getCheckInHistory();
        emit(CheckInHistoryLoadedState(checkIns));
    } catch (error) {
        emit(CheckInHistoryErrorState(error.toString()));
    }
}


  List<String> parseHumanMessage(String text) {
    List<String> sentences = text.split(".");
    List<String> words = sentences[0].split(" ");
    String FeelingForm = words[5];
    return [
      FeelingForm.replaceFirst(FeelingForm[0], FeelingForm[0].toUpperCase()),
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





class CheckInHistoryCard extends StatefulWidget {
  final Color? textColor;
  final CheckInHistoryBloc bloc;

  const CheckInHistoryCard({
    Key? key,
    required this.bloc,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  _CheckInHistoryCardState createState() => _CheckInHistoryCardState();
}

class _CheckInHistoryCardState extends State<CheckInHistoryCard> {
  final List<Color> cardColors = [
    Color(0xFF65dc99),
    Color(0xFFb383ff),
    Color(0xFF68d0ff),
    Color(0xFFff9a96),
  ];

  @override
  void initState() {
    super.initState();
    widget.bloc.add(FetchCheckInHistoryEvent());
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckInHistoryBloc, CheckInHistoryState>(
      bloc: widget.bloc,
      builder: (context, state) {
        if (state is CheckInHistoryLoadingState) {
          return Center(
            child: SizedBox(
              width: 50.0.w,
              height: 50.0.w,
              child: const CircularProgressIndicator(),
            ),
          );
        } else 
        if (state is CheckInHistoryLoadedState) {
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
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(pastCheckIns.length, (index) {
                final checkIn = pastCheckIns[index];
                final history = widget.bloc.chekinHistory(checkIn.messages[0].text.toLowerCase());
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
                  title: widget.bloc.parseHumanMessage(checkIn.messages[0].text)[0],
                  body: widget.bloc.parseHumanMessage(checkIn.messages[0].text)[1],
                  text_color: widget.textColor ?? Colors.white,
                  // ... other properties
                );
              }),
            ),
          );

        } else if (state is CheckInHistoryErrorState) {
          return Text('Error: ${state.errorMessage}'); // Show an error message
        }
        return Container(); // default return, can be an empty container or some placeholder
      },
    );
  }
}
