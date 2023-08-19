import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import '../../../../checkIn_app/services/service.dart';
import '../../../../reflection_app/services/service.dart';
import '../../../../main_app/services/service.dart';
import './newReflections.dart';
import '../../../../auth_mod/utils/theme_helper.dart';
import './view_reflection_results.dart';



class ReflectionHome extends StatefulWidget {
  final int selectedIndex;
  

  ReflectionHome({Key? key, this.selectedIndex = 1}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ReflectionHomeState createState() => _ReflectionHomeState();
}

class _ReflectionHomeState extends State<ReflectionHome> {
  bool _isLoading = true;
  bool _hasEnoughCheckIns = false;
  int count = 0;
  List reflectionTopics = [];
  late List history = [];
  final checkInService = CheckInService();

  final String welcomeMessage =
      '''Bbuddy reflection tool helps you gain insights into your emotions. Based on your previous inputs, 
      the tool provides high-level reflective questions, which you can reflect back to increase understanding.''';

  final String notEnoughCheckIns =
      "In order to generate a new reflection, we need a minimum of three new check-ins. Please make sure you have at least three recent check-ins, and come back afterwards.";
  @override
  void initState() {
    super.initState();
    loadPage();
  }

  void loadPage() async {
    count = await checkInService.countCheckIn();
    if (count >= 3) {
      history = await getReflectionHistory();
      setState(() {
        _isLoading = false;
        _hasEnoughCheckIns = true;
      });
    } else {
      setState(() {
        _isLoading = false;
        _hasEnoughCheckIns = false;
      });
    }
  }

  void createNewReflection(BuildContext context) async {
    final counterStats = Provider.of<CounterStats>(context, listen: false);
    if (int.tryParse(counterStats.checkInCounter!.value)! < 3) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              notEnoughCheckIns,
              maxLines: 5,
              //overflow: TextOverflow.ellipsis,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _isLoading = true;
      });
      reflectionTopics = await getReflectionTopics();
      Provider.of<ReflectionHeading>(context, listen: false)
          .fetchHeading(reflectionTopics);

      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewReflection(topics: reflectionTopics),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    ScreenUtil.init(context, designSize: Size(414, 896));

    double textSize_Headline = 15.0.sp;
    double textSize = 13.sp;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFF2D425F),
        appBar: AppBar(
          backgroundColor: Color(0xFF2D425F),
          elevation:
              0, // Remove the line dividing the AppBar and the rest of the screen
          title: Text(
            'Reflections',
            style: TextStyle(
              color: Colors.white, // Set the color of the font to white
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      if (_hasEnoughCheckIns) {
        if (history.length == 0) {
          return Scaffold(
            backgroundColor: Color(0xFF2D425F),
            appBar: AppBar(
              backgroundColor: Color(0xFF2D425F),
              elevation:
                  0, // Remove the line dividing the AppBar and the rest of the screen
              title: Text(
                'Reflections',
                style: TextStyle(
                  color: Colors.white, // Set the color of the font to white
                ),
              ),
               automaticallyImplyLeading: false, // Remove the back button
            ),
            body: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05.w),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Card(
                          elevation: 20.0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.03),
                            side: BorderSide(
                              color: Color(0xFF404659),
                              width: screenWidth * 0.005,
                            ),
                          ),
                          child: Container(
                            width: screenWidth - 32.0.w,
                            height: 200.0.h,
                            padding: EdgeInsets.all(12.0.w),
                            child: Text(
                              welcomeMessage,
                              style: TextStyle(
                                fontSize: textSize_Headline,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20.0.h,
                    right: 20.w,
                    child: ElevatedButton(
                      onPressed: () {
                        createNewReflection(context);
                      },
                      child: Icon(
                        Icons.add,
                        size: 24.0.w,
                        color: Colors.white,
                      ),
                      style: ThemeHelper().buttonStyle().copyWith(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Color(0xFF2D425F),
            appBar: AppBar(
              backgroundColor: Color(0xFF2D425F),
              elevation:
                  0, // Remove the line dividing the AppBar and the rest of the screen
              title: Text(
                'Reflections',
                style: TextStyle(
                  color: Colors.white, // Set the color of the font to white
                ),
              ),
              iconTheme: IconThemeData(color: Colors.white),
               automaticallyImplyLeading: false, // Remove the back button
            ),
            body: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05.w),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16.0.h,
                              crossAxisSpacing: 16.0.w,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: history.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 10.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: Color(0xFFff9a96),
                                    width: 1.50,
                                  ),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color.fromRGBO(17, 32, 55, 1.0),
                                    // Use the random gradient
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      List topics = history[index]
                                          .topicReflections
                                          .map((reflectionPerTopic) =>
                                              reflectionPerTopic.topic)
                                          .toList();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ViewReflectionResults(
                                            topics: topics,
                                            reflection: history[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0.w),
                                            child: Text(
                                              history[index].heading,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: textSize_Headline,
                                                  color: Colors.white
                                                   ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                        Divider(),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0.w),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  history[index]
                                                      .topicReflections[0]
                                                      .topic,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: textSize,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(height: 20.0.h),
                                                Text(
                                                  history[index]
                                                      .topicReflections[1]
                                                      .topic,
                                                  style: TextStyle(
                                                    fontSize: textSize,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20.0.h,
                    right: 20.w,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 15,
                            offset: Offset(
                                2, 3), // controls the position of the shadow
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          createNewReflection(context);
                        },
                        child: Icon(
                          Icons.add,
                          size: 24.0.w,
                          color: Colors.black,
                        ),
                        style: ThemeHelper().buttonStyle().copyWith(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.white,
                              ),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      } 
      else {
        return Scaffold(
          backgroundColor: Color(0xFF2D425F),
          appBar: AppBar(
            backgroundColor: Color(0xFF2D425F),
            elevation:
                0, // Remove the line dividing the AppBar and the rest of the screen
            title: Text(
              'Reflections',
              style: TextStyle(
                color: Colors.white, // Set the color of the font to white
              ),
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 18.0.sp,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: 'You need\n\n',
                  ),
                  TextSpan(
                    text: count > 0 ? '$count' : '3',
                    style: TextStyle(
                      fontSize: 52.0.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    style: TextStyle(
                      fontSize: 18.0.sp,
                      color: Colors.white,
                    ),
                    text: '\n\nCheck-in(s) to generate the reflections',
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
  }

  // Function to generate a random color
  List<List<Color>> colorDictionary = [
    [
      Color.fromARGB(255, 151, 217, 181),
      Color(0xFF65DC9A)
    ], // Blue and Light Blue
    [
      Color.fromARGB(255, 244, 180, 178),
      Color(0xFFFF9A96)
    ], // Green and Light Green
    [
      Color.fromARGB(255, 227, 204, 119),
      Color.fromARGB(255, 234, 207, 101)
    ], // Yellow and Light Yellow
    [
      Color.fromARGB(255, 144, 211, 246),
      Color(0xFF74CEFF)
    ], // Purple and Light Purple
    [
      Color.fromARGB(255, 134, 210, 200),
      Color(0xFF69DCCD)
    ], // Pink and Light Pink
    [
      Color.fromARGB(255, 195, 163, 244),
      Color(0xFFB484FE)
    ], // Pink and Light Pink
  ];

  Color getRandomColor(List<List<Color>> colorDictionary) {
    final random = Random();
    final index = random.nextInt(colorDictionary.length);
    final colorList = colorDictionary[index];
    final baseColor = colorList[0];
    final lightColor = colorList[1];
    return random.nextBool() ? baseColor : lightColor;
  }

  Gradient getRandomGradient(List<List<Color>> colorDictionary) {
    final random = Random();
    final index = random.nextInt(colorDictionary.length);
    final baseColor = colorDictionary[index][0];
    final lightColor = colorDictionary[index][1];
    return LinearGradient(
      colors: [baseColor, lightColor],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );
  }
}
