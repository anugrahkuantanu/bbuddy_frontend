import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './textbox_screen.dart';
import '../../../bloc/bloc.dart';
import '../../../widget/widget.dart';


class ReasonScreen extends StatefulWidget {
  const ReasonScreen({Key? key, 
  this.feeling, 
  this.feelingForm,
  this.backgroundColor,
  this.textColor,
  }): super(key: key);
  final String? feeling;
  final String? feelingForm;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  _ReasonScreenState createState() => _ReasonScreenState();
}

class _ReasonScreenState extends State<ReasonScreen>
    with SingleTickerProviderStateMixin {
  late ReasonScreenBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ReasonScreenBloc();
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
                      decoration:const InputDecoration(
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
                              backgroundColor: widget.backgroundColor,
                              textColor: widget.textColor,
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
            backgroundColor: widget.backgroundColor,
            textColor: widget.textColor,
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
    double textSize = _bloc.computeTextSize(screenWidth);
    double highSpace = _bloc.computeHighSpace(screenWidth, screenHeight);
    
    double entityButtonWidth = screenWidth / 4; // Adjusted for some padding and spacing

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        backgroundColor: widget.backgroundColor,
        elevation: 0,
        title: Text(
          '',
          style: TextStyle(color: widget.textColor),
        ),
        iconTheme: IconThemeData(color: widget.textColor),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
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
                SizedBox(height: 40),
                Container(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: Wrap(
                        // spacing: 10.0.w,
                        spacing: 25.0.w,
                        runSpacing: highSpace,
                        children: _bloc.entities.map((entity) {
                          return SizedBox(
                            width: entityButtonWidth,
                            child: EntityButton(
                              entity: entity,
                              icon: _bloc.getIcon(entity),
                              emojiSize: emojiSize,
                              textColor: widget.textColor,
                              onTap: () => _handleButtonPress(entity),
                              fontSize: textSize,

                            ),
                          );
                        }).toList(),
                      ),
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
