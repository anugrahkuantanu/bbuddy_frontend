import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../reflection_app/services/service.dart';
import '../../../../main_app/services/service.dart';
import 'reflection_home_ui.dart';
import '../../../models/model.dart';
import 'dart:async';


abstract class ReflectionResultState {}

class ReflectionResultInitial extends ReflectionResultState {}

class ReflectionResultLoading extends ReflectionResultState {}

class ReflectionResultLoaded extends ReflectionResultState {
  final Reflection reflection;

  ReflectionResultLoaded(this.reflection);
}

class ReflectionResultError extends ReflectionResultState {}


// event

abstract class ReflectionResultEvent {}

class LoadMoodReflections extends ReflectionResultEvent {
  final List topics;
  final List? userReflections;
  final String heading;
  final Reflection? reflection;

  LoadMoodReflections(this.topics, this.userReflections, this.heading, this.reflection);
}


//bloc

class ReflectionResultBloc {
  final _stateController = StreamController<ReflectionResultState>();
  StreamSink<ReflectionResultState> get _inState => _stateController.sink;
  Stream<ReflectionResultState> get state => _stateController.stream;

  final _eventController = StreamController<ReflectionResultEvent>();
  Sink<ReflectionResultEvent> get eventSink => _eventController.sink;

  ReflectionResultBloc() {
    _eventController.stream.listen(_mapEventToState);
  }

void _mapEventToState(ReflectionResultEvent event) async {
    if (event is LoadMoodReflections) {
      _inState.add(ReflectionResultLoading());
      if (event.reflection != null) {
        _inState.add(ReflectionResultLoaded(event.reflection!));
      } else {
        try {
          final response = await getMoodReflections(event.topics, event.userReflections, event.heading);
          if (response is Reflection) {
            _inState.add(ReflectionResultLoaded(response));
            // Handle Provider logic here or in the widget depending on how you want to structure it.
          } else {
            _inState.add(ReflectionResultError());
          }
        } catch (e) {
          _inState.add(ReflectionResultError());
        }
      }
    }
}


  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}




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
    reflectionResultBloc = ReflectionResultBloc();
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
          return Scaffold(
            backgroundColor: widget.backgroundColor,
            appBar: AppBar(
              backgroundColor: widget.backgroundColor,
              elevation: 0,
              title: Padding(
                padding: EdgeInsets.only(left: 100.w, top: 10.w),
                child: CircularProgressIndicator(),
              ),
              iconTheme: IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
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
          return Scaffold(
            backgroundColor: widget.backgroundColor,
            appBar: AppBar(
              backgroundColor: widget.backgroundColor,
              elevation: 0,
              title: Text("Error", style: TextStyle(color: Colors.white)),
              iconTheme: IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(child: Text('An error occurred.')),
          );
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
