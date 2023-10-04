import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'textbox.dart';
import '../../bloc/bloc.dart';
import '../widget/widget.dart';

class ReasonPageBloc {
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
    'Other',
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

  IconData getIcon(String entity) {
    return iconsMap[entity]!;
  }

  double computeEmojiSize(double screenWidth) {
    if (screenWidth < 380) {
      return screenWidth * 0.08.w;
    } else if (screenWidth < 400) {
      return screenWidth * 0.10.w;
    } else {
      return screenWidth * 0.09.w;
    }
  }

  double computeTextSize(double screenWidth) {
    return 14.sp;
  }

  double computeHighSpace(double screenWidth, double screenHeight) {
    if (screenWidth < 380) {
      return screenHeight * 0.03;
    } else if (screenWidth < 400) {
      return screenHeight * 0.06;
    } else {
      return screenHeight * 0.04;
    }
  }
}



class ReasonPage extends StatefulWidget {
  const ReasonPage({Key? key, 
  this.feeling, 
  this.feelingForm,
  this.textColor,
  }): super(key: key);
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
    
    double entityButtonWidth = screenWidth / 4; // Adjusted for some padding and spacing

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '',
          style: TextStyle(color: widget.textColor),
        ),
        iconTheme: IconThemeData(color: widget.textColor),
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
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
