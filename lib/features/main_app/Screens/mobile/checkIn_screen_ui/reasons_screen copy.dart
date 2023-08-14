import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './textbox_screen.dart';

class ReasonScreen extends StatefulWidget {
  ReasonScreen({Key? key, 
  required this.feeling, 
  required this.feelingForm,
  required this.backgroundColor,
  required this.textColor,
  }): super(key: key);
  final String feeling;
  final String feelingForm;
  final Color backgroundColor;
  final Color textColor;
  @override
  _ReasonScreenState createState() => _ReasonScreenState();
}

class _ReasonScreenState extends State<ReasonScreen>
    with SingleTickerProviderStateMixin {
  final List<String> entities = [
    'School',
    'Work',
    'Family',
    'Relationships',
    'Partner',
    'Money',
    'Health',
    'Friendship',
    'Social Media',
    'Good Sleep',
    'Career',
    'Goals',
    'Sex',
    'Boredom',
    'Addiction',
    'Food',
    'Other', // Added "Other" entity
  ];

  final Map<String, IconData> iconsMap = {
    'School': Icons.school,
    'Work': Icons.work,
    'Family': Icons.family_restroom,
    'Relationships': Icons.favorite,
    'Partner': Icons.favorite_border,
    'Money': Icons.attach_money,
    'Health': Icons.health_and_safety,
    'Friendship': Icons.emoji_people,
    'Social Media': Icons.social_distance,
    'Good Sleep': Icons.nights_stay,
    'Career': Icons.work_outline,
    'Goals': Icons.check_box_outline_blank,
    'Sex': Icons.people_alt,
    'Boredom': Icons.sentiment_dissatisfied,
    'Addiction': Icons.smoking_rooms,
    'Food': Icons.fastfood,
    'Other': Icons.more_horiz,
  };

  final List<Color> buttonColors = [
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
    Color(0xFF404659),
  ];

  IconData _getIcon(String entity) {
    return iconsMap[entity]!;
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
                title: Text('Enter a reason'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
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
                      Text(
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
                    child: Text('Cancel'),
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
                    child: Text('OK'),
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

    ScreenUtil.init(context, designSize: Size(414, 896));

    double emojiSize;
    double textSize;
    double high_space;

    if (screenWidth < 380) {
      emojiSize = screenWidth * 0.08.w;
      textSize = 15.sp;
      high_space = screenHeight * 0.03;
    } else if (screenWidth < 400) {
      emojiSize = screenWidth * 0.10.w;
      textSize = 17.sp;
      high_space = screenHeight * 0.06;
    } else {
      emojiSize = screenWidth * 0.09.w;
      textSize = 16.sp;
      high_space = screenHeight * 0.04;
    }

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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10.0.w),
                  child: Text(
                    "What is making you ${widget.feeling.toLowerCase()}?",
                    style: TextStyle(
                      fontSize: 22.0.sp,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  // color: Color(0xFF2D425F),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: Wrap(
                        spacing: 25.0.w,
                        runSpacing: high_space,
                        children: entities
                            .map(
                              (entity) => SizedBox(
                                width: screenWidth / 5,
                                child: GestureDetector(
                                  onTap: () => _handleButtonPress(entity),
                                  child: Column(
                                    children: [
                                      Icon(
                                        _getIcon(entity),
                                        size: emojiSize,
                                        color: widget.textColor,
                                      ),
                                      Text(
                                        entity,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: widget.textColor,
                                          fontSize: textSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
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
