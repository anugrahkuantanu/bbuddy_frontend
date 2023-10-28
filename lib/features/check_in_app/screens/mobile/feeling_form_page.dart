import 'package:flutter/material.dart';
import 'reasons_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bbuddy_app/features/check_in_app/bloc/bloc.dart';
import 'package:bbuddy_app/features/check_in_app/screens/widget/widget.dart';

class FeelingFormPage extends StatelessWidget {
  final String feeling;
  final FeelingBloc _bloc = FeelingBloc();

  FeelingFormPage({
    Key? key,
    required this.feeling,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<FeelingBloc, FeelingState>(
        listener: (context, state) {
          if (state is NavigateToReasonPageState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReasonPage(
                  feeling: state.feeling,
                  feelingForm: state.feelingForm,
                ),
              ),
            ).then((_) {
              // After coming back from the ReasonPage, reset the BLoC's state.
              _bloc.add(ResetEvent());
            });
          }
        },
        builder: (context, state) {
          if (state is InitialState) {
            // On initial state, we will load the feelings form with their button colors.
            return _buildPage(context, _bloc.buttonColors, _bloc.feelingForms);
          }
          return Container(); // Fallback, should not be reached.
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, Map<String, Color> buttonColors,
      Map<String, List<String>> feelingForms) {
    double screenWidth = MediaQuery.of(context).size.width;
    ScreenUtil.init(context, designSize: const Size(414, 896));

    double textSize;
    if (screenWidth < 380) {
      textSize = 15.sp;
    } else if (screenWidth < 400) {
      textSize = 16.sp;
    } else {
      textSize = 17.sp;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          '',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, 'refresh');
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10.0.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Text(
                    "What manifestation of ${feeling.toLowerCase()} are you feeling?",
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 20.0.w,
                    runSpacing: 30.0.w,
                    children: feelingForms[feeling]!
                        .map(
                          (feelingForm) => SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: EntityButton(
                              entity: feelingForm,
                              onTap: () => _handleButtonPress(feelingForm),
                              buttonStyle: ElevatedButton.styleFrom(
                                backgroundColor: buttonColors[feeling] ??
                                    const Color(0xFF0077C2),
                                padding: const EdgeInsets.all(16.0),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleButtonPress(String feelingForm) {
    _bloc.add(ButtonPressedEvent(feelingForm, feeling));
  }
}
