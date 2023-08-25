import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../reflection_app/services/service.dart';
import '../../../main_app/services/service.dart';
import 'reflection_home_ui.dart';
import '../../models/model.dart';


class ViewReflectionResults extends StatefulWidget {
  
  final List topics;
  final List? userReflections;
  final Reflection? reflection;

  const ViewReflectionResults({
    Key? key,
    required this.topics,
    this.userReflections,
    this.reflection,
  }) : super(key: key);

  @override
  _ViewReflectionResultsState createState() => _ViewReflectionResultsState();
}

class _ViewReflectionResultsState extends State<ViewReflectionResults> {
  bool _isLoading = true;
  late Reflection _result;
  String heading = '';

  @override
  void initState() {
    super.initState();
    heading = Provider.of<ReflectionHeading>(context, listen: false).result;
    loadMoodReflections();
  }

  Future<void> loadMoodReflections() async {
    if (widget.reflection != null) {
      _isLoading = false;
      _result = widget.reflection!;
    } else {
      try {
        final response = await getMoodReflections(
          widget.topics,
          widget.userReflections,
          heading,
        );
        if (response is Reflection) {
          setState(() {
            _isLoading = false;
            _result = response;
          });
          final counterStats =
              Provider.of<CounterStats>(context, listen: false);
          counterStats.resetCheckInCounter();
          counterStats.updateReflectionCounter();
        } else {
          setState(() {
            _isLoading = true;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D425F),
      appBar: AppBar(
        backgroundColor: Color(0xFF2D425F),
        elevation:
            0, // Remove the line dividing the AppBar and the rest of the screen
        title: _isLoading
            ? Padding(
                padding: EdgeInsets.only(left: 100.w, top: 10.w),
                child: CircularProgressIndicator())
            : Text(
                _result.heading,
                style: TextStyle(
                  color: Colors.white, // Set the color of the font to white
                ),
              ),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
           if (widget.reflection != null) {
            Navigator.pop(context);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReflectionHome()),
            );
          }
        },   // Replace '/home' with the route for your Home Screen
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              children: [
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _result.topicReflections.length,
                        itemBuilder: (BuildContext context, int index) {
                          final reflection = _result.topicReflections[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Card(
                              elevation: 7,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      ' ${reflection.topic}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(height: 8),
                                    if (reflection.humanInsight.content != '')
                                      Text(
                                        '"' +
                                            '${reflection.humanInsight.content}' +
                                            '"',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF3C896D),
                                        ),
                                      ),
                                    SizedBox(height: 8),
                                    Column(
                                      children: reflection.aiInsights
                                          .map(
                                            (ai) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Text(
                                                '${ai.content}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
