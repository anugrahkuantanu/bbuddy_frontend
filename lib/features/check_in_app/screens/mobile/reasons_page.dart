import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'textbox.dart';
import 'package:bbuddy_app/features/check_in_app/bloc/bloc.dart';
import 'package:bbuddy_app/features/check_in_app/screens/widget/widget.dart';

class ReasonPage extends StatefulWidget {
  const ReasonPage({
    Key? key,
    this.feeling,
    this.feelingForm,
    this.textColor,
  }) : super(key: key);
  final String? feeling;
  final String? feelingForm;
  final Color? textColor;

  @override
  _ReasonPageState createState() => _ReasonPageState();
}

class _ReasonPageState extends State<ReasonPage>
    with SingleTickerProviderStateMixin {
  late ReasonPageBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ReasonPageBloc();
  }

  void _handleButtonPress(String entity) {
    if (entity == 'Other') {
      showDialog(
        context: context,
        builder: (context) {
          String enteredReason = '';
          bool showError = false;
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                title: const Text('Enter a reason'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter a one-word reason',
                      ),
                      onChanged: (value) {
                        enteredReason = value.trim();
                        setState(() {
                          showError = false;
                        });
                      },
                    ),
                    if (showError)
                      const Text(
                        'Please enter a single word.',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (enteredReason.split(' ').length == 1 &&
                          enteredReason.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TextBox(
                              feeling: widget.feeling,
                              feelingForm: widget.feelingForm,
                              reasonEntity: enteredReason,
                            ),
                          ),
                        );
                      } else {
                        setState(() {
                          showError = true;
                        });
                      }
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      // Handle the button press for other entities here
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TextBox(
            feeling: widget.feeling,
            feelingForm: widget.feelingForm,
            reasonEntity: entity,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double emojiSize = _bloc.computeEmojiSize(screenWidth);
    double highSpace = _bloc.computeHighSpace(screenWidth, screenHeight);

    double entityButtonWidth =
        screenWidth / 4; // Adjusted for some padding and spacing

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '',
          style: TextStyle(color: widget.textColor),
        ),
        iconTheme: IconThemeData(color: widget.textColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10.0.w),
                  child: Text(
                    "Select a reason associated with your ${widget.feeling}",
                    style: TextStyle(
                      fontSize: 22.0.sp,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(.0.w),
                    child: Wrap(
                      spacing: 20.0.w,
                      runSpacing: highSpace,
                      children: _bloc.entities.map((entity) {
                        return SizedBox(
                          width: entityButtonWidth,
                          child: EntityButton(
                            entity: entity,
                            icon: _bloc.getIcon(entity),
                            iconSize: emojiSize,
                            onTap: () => _handleButtonPress(entity),
                            textStyle: TextStyle(
                              fontSize: 12.w,
                              color:
                                  Theme.of(context).textTheme.labelSmall!.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
