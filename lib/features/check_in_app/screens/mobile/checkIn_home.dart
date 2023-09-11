import 'package:bbuddy_app/features/check_in_app/controllers/main/feelings_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/core.dart';
import 'package:provider/provider.dart';
import '/config/config.dart';
import '../bloc/bloc.dart';
import '../widget/widget.dart';







class CheckInHome extends StatelessWidget {
  const CheckInHome({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider?>();
    var bloc = CheckInHomeBloc();  // Instantiate the BLoC

    ScreenUtil.init(context, designSize: const Size(414, 896));

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double emojiSize = bloc.computeEmojiSize(screenWidth);
    double textSize = bloc.computeTextSize(screenWidth);
    double buttonHeight = bloc.computeButtonHeight(screenWidth, screenHeight);
    Color textColor = bloc.getTextColor(tm!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-In'),
        centerTitle: true,
        actions: actionsMenu(context),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04.w),
            child: Column(
              children: [
                Helper().ScreenHeadingContainer(context, 'How are you feeling?'),
                Column(
                  children: _buildFeelingButtons(context, bloc.feelings, emojiSize, textSize, textColor, buttonHeight, screenWidth),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  List<Widget> _buildFeelingButtons(BuildContext context, List<Map<String, dynamic>> feelings, double emojiSize, double textSize, Color textColor, double buttonHeight, double screenWidth) {
    List<Widget> feelingButtons = [];

    for (int i = 0; i < feelings.length; i += 2) {
      List<Widget> rowChildren = [];

      // First button
      rowChildren.add(
        Expanded(
          child: 
          EntityButton(
            entity: feelings[i]['name']!,
            emoji: feelings[i]['emoji']!,
            textColor: textColor,
            fontSize: textSize,
            onTap: () => _navigateToFeelingFormScreen(context, feelings[i]['name']!, textColor),
            emojiSize: emojiSize,
          ),
        ),
      );
      if (i + 1 < feelings.length) {
        rowChildren.add(SizedBox(width: screenWidth * 0.05.w));
        rowChildren.add(
          Expanded(
            child: 

              EntityButton(
              entity: feelings[i + 1]['name']!,
              emoji: feelings[i + 1]['emoji']!,
              textColor: textColor,
              fontSize: textSize,
              onTap: () => _navigateToFeelingFormScreen(context, feelings[i + 1]['name'], textColor),
              icon: null,
              emojiSize: emojiSize,
            ),
          ),
        );
      }

      feelingButtons.add(SizedBox(height: 0.10.sh));
      feelingButtons.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowChildren,
      ));
    }
    return feelingButtons;
  }

  void _navigateToFeelingFormScreen(BuildContext context, String? feelingName, Color? textColor) {
    if (feelingName != null && textColor != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => 
          FeelingsFormController(
            feeling: feelingName,
            textColor: textColor,
            ),
        ),
      );
    }
  }
}
