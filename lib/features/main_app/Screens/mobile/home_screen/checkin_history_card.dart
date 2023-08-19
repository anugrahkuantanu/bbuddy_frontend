import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/widget.dart';
import '/config/config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../checkIn_app/services/service.dart';
import '../../../../checkIn_app/models/checkIn.dart';
import '../../../../checkIn_app/Screens/screen.dart';


class CheckInHistoryCard extends StatefulWidget {
  final Color? textColor;
  final Color backgroundColor;

  const CheckInHistoryCard({
    this.textColor,
    required this.backgroundColor,
  });

  @override
  State<CheckInHistoryCard> createState() => CheckInHistoryCardState();
}


class CheckInHistoryCardState extends State<CheckInHistoryCard> {
  List<CheckIn>? pastCheckIns;
  bool isLoading = true;
  final checkInService = CheckInService();

  @override
  void initState() {
    super.initState();
    fetchCheckInHistory();
  }

  @override
  void dispose() {
    // Cancel any ongoing asynchronous tasks here
    super.dispose();
  }

  Future<void> fetchCheckInHistory() async {
    try {
      // Replace this with your actual API call to get the check-in history
      List<CheckIn> checkIns = await checkInService.getCheckInHistory();
      if (mounted) {
        setState(() {
          pastCheckIns = checkIns;
          isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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

  // Add sentences from index 1 to length-1 to the chekinHistoryList
  for (int i = 1; i < sentences.length; i++) {
    chekinHistoryList.add(sentences[i]);
  }
  return chekinHistoryList;
}


  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider>();
    //pastCheckIns == null ? Container() : 
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
        children: [
          CheckInCard(
            onTap: pastCheckIns != null && pastCheckIns!.isNotEmpty
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          backgroundColor: widget.backgroundColor,
                          feeling: chekinHistory(pastCheckIns![3].humanMessage.text.toLowerCase())[0],
                          feelingForm: chekinHistory(pastCheckIns![3].humanMessage.text.toLowerCase())[1],
                          reasonEntity: chekinHistory(pastCheckIns![3].humanMessage.text.toLowerCase())[2],
                          reason: chekinHistory(pastCheckIns![3].humanMessage.text.toLowerCase()).last,
                          isPastCheckin: true,
                          aiResponse: pastCheckIns![3].aiMessage.text,
                        ),
                      ),
                    );
                  }
                : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckInHome()
                  ),
                );
                  },
            title: isLoading
                ? null
                : (pastCheckIns!.isNotEmpty && pastCheckIns!.length > 3)
                    ? parseHumanMessage(pastCheckIns![3].humanMessage.text)[0]
                    : 'No check-ins available', //"Calming",
            body: isLoading
                ? null
                : (pastCheckIns!.isNotEmpty && pastCheckIns!.length > 3)
                    ? parseHumanMessage(pastCheckIns![3].humanMessage.text)[1]
                    : 'No check-ins available',
            text_color: widget.textColor ?? Colors.white,
            gradientStartColor: Color(0xFFff9a96),
            gradientEndColor: Color(0xFFff9a96),
            // borderColor: Color.fromRGBO(17, 32, 55, 1.0),
          ),
          CheckInCard(
            onTap: pastCheckIns != null && pastCheckIns!.isNotEmpty
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          backgroundColor: widget.backgroundColor,
                          feeling: chekinHistory(pastCheckIns![2].humanMessage.text.toLowerCase())[0],
                          feelingForm: chekinHistory(pastCheckIns![2].humanMessage.text.toLowerCase())[1],
                          reasonEntity: chekinHistory(pastCheckIns![2].humanMessage.text.toLowerCase())[2],
                          reason: chekinHistory(pastCheckIns![2].humanMessage.text.toLowerCase()).last,
                          isPastCheckin: true,
                          aiResponse: pastCheckIns![2].aiMessage.text,
                        ),
                      ),
                    );
                  }
                : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckInHome()
                  ),
                );
                  },
            title: isLoading
                ? null
                : (pastCheckIns!.isNotEmpty && pastCheckIns!.length > 2)
                    ? parseHumanMessage(pastCheckIns![2].humanMessage.text)[0]
                    : 'No check-ins available',
            body: isLoading
                ? null
                : (pastCheckIns!.isNotEmpty && pastCheckIns!.length > 2)
                    ? parseHumanMessage(pastCheckIns![2].humanMessage.text)[1]
                    : 'No check-ins available',
            text_color: widget.textColor ?? Colors.white,
            gradientStartColor: Color(0xFF68d0ff),
            gradientEndColor: Color(0xFF68d0ff),
            // borderColor: Color.fromRGBO(17, 32, 55, 1.0),
          ),
          CheckInCard(
                        onTap: pastCheckIns != null && pastCheckIns!.isNotEmpty
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          backgroundColor: widget.backgroundColor,
                          feeling: chekinHistory(pastCheckIns![1].humanMessage.text.toLowerCase())[0],
                          feelingForm: chekinHistory(pastCheckIns![1].humanMessage.text.toLowerCase())[1],
                          reasonEntity: chekinHistory(pastCheckIns![1].humanMessage.text.toLowerCase())[2],
                          reason: chekinHistory(pastCheckIns![1].humanMessage.text.toLowerCase()).last,
                          isPastCheckin: true,
                          aiResponse: pastCheckIns![1].aiMessage.text,
                        ),
                      ),
                    );
                  }
                : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckInHome()
                  ),
                );
                  },
            title: isLoading
                ? null
                : (pastCheckIns!.isNotEmpty && pastCheckIns!.length > 1)
                    ? parseHumanMessage(pastCheckIns![1].humanMessage.text)[0]
                    : 'No check-ins available',
            body: isLoading
                ? null
                : (pastCheckIns!.isNotEmpty && pastCheckIns!.length > 1)
                    ? parseHumanMessage(pastCheckIns![1].humanMessage.text)[1]
                    : 'No check-ins available',
            text_color: widget.textColor ?? Colors.white,
            gradientStartColor:Color(0xFFb383ff),
            gradientEndColor: Color(0xFFb383ff),
            // borderColor: Color.fromRGBO(17, 32, 55, 1.0), // Set the border color here
          ),
          CheckInCard(
            onTap: pastCheckIns != null && pastCheckIns!.isNotEmpty
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          backgroundColor: widget.backgroundColor,
                          feeling: chekinHistory(pastCheckIns![0].humanMessage.text.toLowerCase())[0],
                          feelingForm: chekinHistory(pastCheckIns![0].humanMessage.text.toLowerCase())[1],
                          reasonEntity: chekinHistory(pastCheckIns![0].humanMessage.text.toLowerCase())[2],
                          reason: chekinHistory(pastCheckIns![0].humanMessage.text.toLowerCase()).last,
                          isPastCheckin: true,
                          aiResponse: pastCheckIns![0].aiMessage.text,
                        ),
                      ),
                    );
                  }
                : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckInHome()
                  ),
                );
                  },
            title: isLoading
                ? null
                : (pastCheckIns!.isNotEmpty && pastCheckIns!.length > 0)
                    ? parseHumanMessage(pastCheckIns![0].humanMessage.text)[0]
                    : 'No check-ins available',
            text_color: widget.textColor ?? Colors.white,
            body: isLoading
                ? null
                : (pastCheckIns!.isNotEmpty && pastCheckIns!.length > 0)
                    ? parseHumanMessage(pastCheckIns![0].humanMessage.text)[1]
                    : 'No check-ins available',
                    gradientStartColor: Color(0xFF65dc99),
                    gradientEndColor: Color(0xFF65dc99),
                    // borderColor:Color.fromRGBO(17, 32, 55, 1.0),
                
          ),
        ],
      ),
    );
  }
}
