import 'package:flutter/material.dart';
import './chat_screen.dart';
import '/features/main_app/utils/helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextBox extends StatefulWidget {
  final String feeling;
  final String feelingForm;
  final String reasonEntity;
  final Color backgroundColor;
  final Color textColor;

  const TextBox({
    required this.feeling,
    required this.feelingForm,
    required this.reasonEntity,
    required this.backgroundColor,
    required this.textColor,
    
  });

  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  TextEditingController _textEditingController = TextEditingController();
  String inputText = '';
  bool showWarning = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
              backgroundColor: widget.backgroundColor,
              elevation: 0, // Remove the line dividing the AppBar and the rest of the screen
              title: Text(
                '',
                style: TextStyle(
                  color: widget.textColor, // Set the color of the font to white
                ),
              ),
              iconTheme: IconThemeData(color: widget.textColor),
            ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(10.0.w),
                // decoration: BoxDecoration(
                //   border: Border.all(color: Color(0xFF404659), width: screenWidth * 0.005),
                //   borderRadius: BorderRadius.circular(screenWidth * 0.03),
                // ),
                child: Text(
                  'Share more about what\'s making you ${widget.feeling.toLowerCase()}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              if (showWarning)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Oops! You forgot to share more details. Please provide extra details about your feeling below. These details will be used later during the reflection.',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: widget.textColor, width: screenWidth * 0.005),
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(10.0),
                            hintText: "Write your answer",
                            hintStyle: TextStyle(
                        color: widget.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          onChanged: (text) {
                            setState(() {
                              inputText = text;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (inputText.isEmpty) {
                              setState(() {
                                showWarning = true;
                              });
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    feeling: widget.feeling.toLowerCase(),
                                    feelingForm: widget.feelingForm.toLowerCase(),
                                    reasonEntity: widget.reasonEntity,
                                    reason: inputText,
                                    isPastCheckin: false,
                                    backgroundColor: widget.backgroundColor,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: widget.backgroundColor,
                            ),
                          ),
                          style: ThemeHelper().buttonStyle().copyWith(
                            backgroundColor: MaterialStateProperty.all<Color>(widget.textColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
