import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../reflection_app/services/service.dart';
import '../../../main_app/services/service.dart';
import 'reflection_home_ui.dart';
import '../../models/model.dart';
import '../blocs/bloc.dart';
import '/core/utils/utils.dart';


class ViewReflectionResults extends StatefulWidget {
  final List topics;
  final List? userReflections;
  final Reflection? reflection;
  final Color? backgroundColor;

  const ViewReflectionResults({
    Key? key,
    required this.topics,
    this.userReflections,
    this.reflection,
    this.backgroundColor = Colors.black
  }) : super(key: key);

  @override
  _ViewReflectionResultsState createState() => _ViewReflectionResultsState();
}

class _ViewReflectionResultsState extends State<ViewReflectionResults> {
  late ReflectionResultBloc reflectionResultBloc;

  @override
void initState() {
    super.initState();
    final counterStats = Provider.of<CounterStats>(context, listen: false);
    reflectionResultBloc = ReflectionResultBloc(counterStats: counterStats);
    reflectionResultBloc.eventSink.add(LoadMoodReflections(
      widget.topics,
      widget.userReflections,
      Provider.of<ReflectionHeading>(context, listen: false).result,
      widget.reflection,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ReflectionResultState>(
      stream: reflectionResultBloc.state,
      initialData: ReflectionResultInitial(),
      builder: (context, snapshot) {
        if (snapshot.data is ReflectionResultLoading) {
          return LoadingUI(title: "",);
        } else if (snapshot.data is ReflectionResultLoaded) {
          final reflectionData = (snapshot.data as ReflectionResultLoaded).reflection;
          return Scaffold(
            backgroundColor: widget.backgroundColor,
            appBar: AppBar(
              backgroundColor: widget.backgroundColor,
              elevation: 0,
              title: Text(reflectionData.heading, style: TextStyle(color: Colors.white)),
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
                },
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: reflectionData.topicReflections.length,
                        itemBuilder: (BuildContext context, int index) {
                          final reflection = reflectionData.topicReflections[index];
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
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                        '"' + '${reflection.humanInsight.content}' + '"',
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
                                              padding: const EdgeInsets.only(bottom: 8.0),
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
        } else if (snapshot.data is ReflectionResultError) {
          return ErrorUI(errorMessage: 'An error occurred.');
        }
        return Container(); // Default empty state
      },
    );
  }

  @override
  void dispose() {
    reflectionResultBloc.dispose();
    super.dispose();
  }
}
