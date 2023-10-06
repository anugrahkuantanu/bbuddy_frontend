import 'package:flutter/material.dart';
import './chat_screen.dart';
import '/core/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextBox extends StatefulWidget {
  final String? feeling;
  final String? feelingForm;
  final String? reasonEntity;

  const TextBox({
    this.feeling,
    this.feelingForm,
    this.reasonEntity,
    
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
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(10.0.w),
                child: Text(
                  'Share more about what\'s making you ${widget.feeling!.toLowerCase()}',
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              if (showWarning)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
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
                    border: Border.all(color: Colors.white, width: screenWidth * 0.005),
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
                            hintStyle: Theme.of(context).textTheme.bodySmall,
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
                                    feeling: widget.feeling!.toLowerCase(),
                                    feelingForm: widget.feelingForm!.toLowerCase(),
                                    reasonEntity: widget.reasonEntity ?? "",
                                    reason: inputText,
                                    isPastCheckin: false,
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ThemeHelper().buttonStyle().copyWith(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
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
