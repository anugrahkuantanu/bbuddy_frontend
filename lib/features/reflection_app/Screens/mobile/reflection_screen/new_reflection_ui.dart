import 'package:flutter/material.dart';
import 'view_reflection_results_ui.dart';
import '../../../blocs/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/config/config.dart';


class NewReflection extends StatefulWidget {
  final List topics;
  final ReflectionBloc bloc;

  NewReflection({Key? key, required this.topics})
      : bloc = ReflectionBloc(topics),
        super(key: key);

  @override
  _NewReflectionState createState() => _NewReflectionState();
}

class _NewReflectionState extends State<NewReflection> {

  @override
  Widget build(BuildContext context) {
  var tm = context.watch<ThemeProvider>();
  Color? backgroundColor = tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100];
    double screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<ReflectionState>(
      stream: widget.bloc.stateStream,
      builder: (context, snapshot) {
        if (snapshot.data is ReflectionSubmittedState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewReflectionResults(
                  backgroundColor: backgroundColor,
                  topics: (snapshot.data as ReflectionSubmittedState).topics,
                  userReflections: (snapshot.data as ReflectionSubmittedState).userReflections,
                ),
              ),
            );
          });
          return Container(); // Temporary widget after navigating
        }

        return Scaffold(
            backgroundColor: Color(0xFF2D425F),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        SizedBox(height: 16.0),
                        Expanded(
                            child: ListView.builder(
                                itemCount: widget.topics.length,
                                itemBuilder: (context, index) {
                                    return Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                            Container(
                                                margin: EdgeInsets.only(bottom: 16.0),
                                                padding: EdgeInsets.all(16.0),
                                                decoration: BoxDecoration(
                                                    color: Color.fromRGBO(17, 32, 55, 1.0),
                                                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                                                ),
                                                child: Text(
                                                    widget.topics[index],
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                    ),
                                                ),
                                            ),
                                            SizedBox(height: 20),
                                            TextFormField(
                                                decoration: InputDecoration(
                                                    hintText: 'Enter your thoughts here',
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    contentPadding: EdgeInsets.all(16.0),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: Color(0xFF404659),
                                                            width: 1.5,
                                                        ),
                                                    ),
                                                ),
                                                maxLines: 10,
                                                keyboardType: TextInputType.multiline,
                                                onChanged: (value) {
                                                    widget.bloc.add_event(UpdateReflectionEvent(index, value));
                                                },
                                            ),
                                            SizedBox(height: 25),
                                        ],
                                    );
                                },
                            ),
                        ),
                    ],
                ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                    widget.bloc.add_event(SubmitReflectionEvent());
                },
                backgroundColor: Color.fromRGBO(17, 32, 55, 1.0),
                child: Icon(Icons.arrow_forward, color: Colors.white),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endDocked.withOffset(Offset(0, -50.0)),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        );
      }
    );
  }



  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}

  extension CustomFloatingActionButtonLocation on FloatingActionButtonLocation {
  FloatingActionButtonLocation withOffset(Offset offset) {
    return FloatingActionButtonLocationWithOffset(this, offset);
  }
}

class FloatingActionButtonLocationWithOffset extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation delegate;
  final Offset offset;

  FloatingActionButtonLocationWithOffset(this.delegate, this.offset);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final Offset standardOffset = delegate.getOffset(scaffoldGeometry);
    return Offset(standardOffset.dx + offset.dx, standardOffset.dy + offset.dy);
  }

  @override
  String toString() => '$delegate with offset $offset';
}

// Assuming FloatingActionButton extension remains the same
