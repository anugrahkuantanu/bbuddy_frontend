import 'package:bbuddy_app/features/check_in_app/controllers/main/feelings_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/core.dart';
import '/config/config.dart';
import '../../bloc/bloc.dart';
import '../widget/widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class CheckInHome extends StatelessWidget {
  const CheckInHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckInHomeBloc()..add(UpdateUIEvent()),
      child: BlocConsumer<CheckInHomeBloc, CheckInHomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is UpdateUIState) {
            return _buildUI(context, state);
          }
          return const CircularProgressIndicator(); // Default state for loading or initial
        },
      ),
    );
  }

  Widget _buildUI(BuildContext context, UpdateUIState state) {

    var tm = context.watch<ThemeProvider?>();
    var bloc = BlocProvider.of<CheckInHomeBloc>(context);

    double emojiSize = 50.w;
    double textSize = 16.sp;  // Calculate this
    Color textColor = tm!.isDarkMode ? AppColors.textlight : AppColors.textdark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-In'),
        centerTitle: true,
        actions: actionsMenu(context), // Assuming you have this function defined somewhere
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Helper().ScreenHeadingContainer(context, 'How are you feeling?'),
                Column(
                  children: _buildFeelingButtons(context, bloc.feelings, emojiSize, textSize, textColor),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(), // Assuming you have this widget defined somewhere
    );
  }

_buildFeelingButtons(BuildContext context, List<Map<String, dynamic>> feelings, double emojiSize, double textSize, Color textColor) {
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
        rowChildren.add(SizedBox(width: 60.w));
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
