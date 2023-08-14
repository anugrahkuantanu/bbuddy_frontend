import 'package:flutter/material.dart';
import './feeling_form_screen.dart';
import '/features/main_app/utils/helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/core.dart';
import 'package:provider/provider.dart';
import '/config/config.dart';
import '../../../bloc/bloc.dart';





class CheckInHome extends StatelessWidget {
  const CheckInHome({Key key = const Key('myHomePage')}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider>();
    var bloc = CheckInHomeBloc();  // Instantiate the BLoC

    ScreenUtil.init(context, designSize: Size(414, 896));

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double emojiSize = bloc.computeEmojiSize(screenWidth);
    double textSize = bloc.computeTextSize(screenWidth);
    double buttonHeight = bloc.computeButtonHeight(screenWidth, screenHeight);
    Color textColor = bloc.getTextColor(tm);
    Color backgroundColor= bloc.getBackgroundColor(tm);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: bloc.getAppBarColor(tm),
        title: const Text('Check-In'),
        actions: actionsMenu(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05.w),
            child: Column(
              children: [
                Helper().ScreenHeadingContainer(context, 'How are you feeling?'),
                Column(
                  children: _buildFeelingButtons(context, bloc.feelings, emojiSize, textSize, textColor, backgroundColor, buttonHeight, screenWidth),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  List<Widget> _buildFeelingButtons(BuildContext context, List<Map<String, dynamic>> feelings, double emojiSize, double textSize, Color textColor, Color backgroundColor, double buttonHeight, double screenWidth) {
      List<Widget> feelingButtons = [];

      for (int i = 0; i < feelings.length; i += 2) {
          List<Widget> rowChildren = [];

          // First button
          rowChildren.add(
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.black.withOpacity(0.0),
                    width: 0.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _navigateToFeelingFormScreen(context, feelings[i]['name'], textColor, backgroundColor);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0,
                  ),
                  child: Column(children: [
                    Text(
                      feelings[i]['emoji'],
                      style: TextStyle(
                        fontSize: emojiSize,
                      ),
                    ),
                    SizedBox(height: 0.02.sh),
                    Text(
                      feelings[i]['name'],
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: textSize,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          );

          // If there's another feeling after the current one, add it
          if (i + 1 < feelings.length) {
            rowChildren.add(SizedBox(width: screenWidth * 0.05.w));

            // Second button
            rowChildren.add(
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.black.withOpacity(0.0),
                      width: 0.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _navigateToFeelingFormScreen(context, feelings[i + 1]['name'], textColor, backgroundColor);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                    ),
                    child: Column(children: [
                      Text(
                        feelings[i + 1]['emoji'],
                        style: TextStyle(
                          fontSize: emojiSize,
                        ),
                      ),
                      SizedBox(height: buttonHeight * 0.2),
                      Text(
                        feelings[i + 1]['name'],
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: textSize,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            );
          }

          feelingButtons.add(SizedBox(height: 0.12.sh));
          feelingButtons.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: rowChildren,
          ));
      }
      return feelingButtons;
  }

void _navigateToFeelingFormScreen(BuildContext context, String feelingName, Color textColor, Color backgroundColor) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeelingFormScreen(feeling: feelingName, textColor: textColor, backgroundColor: backgroundColor),
      ),
    );
}

}
