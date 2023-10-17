import 'package:bbuddy_app/config/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bbuddy_app/features/main_app/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/widget.dart';
import '../../../check_in_app/screens/screen.dart';
import 'package:bbuddy_app/core/core.dart';

class CheckInHistoryCard extends StatelessWidget {
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
                            reason: history.sublist(3).join('.'),
                            isPastCheckin: true,
                            aiResponse: checkIn.messages[1].text,
                          ),
                        ),
                      );
                    },
                    title: bloc.parseHumanMessage(checkIn.messages[0].text)[0],
                    body: bloc.parseHumanMessage(checkIn.messages[0].text)[1],
                    text_color: Colors.white,
                  );
                } else {
                  // This is where you return a card with "No check-ins available"
                  return CheckInCard(
                    gradientStartColor: cardColors[index % cardColors.length],
                    gradientEndColor: cardColors[index % cardColors.length],
                    onTap: () {
                      var tm = context.read<ThemeProvider>();
                      tm.setNavIndex(1);
                      Nav.toNamed(context, '/checkIn');
                    },
                    title: 'No check-ins available',
                    body: 'No check-ins available',
                    text_color: Colors.white,
                  );
                }
              }),
            ),
          );
        } else if (state is CheckInHistoryErrorState) {
          // return ErrorUI(errorMessage: state.errorMessage);
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 30.w),
            child: Container(
              height: 300.h, // Adjusting for the Padding
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(state.errorMessage,
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
          );
        }
        return Container(); // default return, can be an empty container or some placeholder
      },
    );
  }
}
