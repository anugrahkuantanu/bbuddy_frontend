import 'package:flutter/material.dart';
import 'view_reflection_results.dart';
import '../blocs/bloc.dart';
import '../../../../core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controllers/controller.dart';

class NewReflectionPage extends StatelessWidget {
  final List<dynamic> topics;

  NewReflectionPage({Key? key, required this.topics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewReflectionBloc(topics),
      child: Builder(builder: (context) {
        final bloc = BlocProvider.of<NewReflectionBloc>(context);
        return BlocConsumer<NewReflectionBloc, NewReflectionState>(
          listener: (context, state) {
            if (state is ReflectionSubmittedState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewReflectionController(
                    topics: state.topics,
                    userReflections: state.userReflections,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ReflectionInitialState) {
              return _buildMainUI(context, bloc, topics, state.userReflections);
            }
            else if (state is ReflectionUpdatedState) {
              return _buildMainUI(context, bloc, topics, state.userReflections);
            }
            // Handle other states...
            return Container(); // Fallback UI
          },
        );
      }),
    );
  }

  Widget _buildMainUI(BuildContext context, NewReflectionBloc bloc, List<dynamic> topics, List<String> userReflections) {
    double screenWidth = MediaQuery.of(context).size.width;

            return Scaffold(
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        SizedBox(height: 16.0),
                        Expanded(
                            child: ListView.builder(
                                itemCount: topics.length,
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
                                                    topics[index],
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
                                                    hintText: AppStrings.enterYourThought,
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
                                                    bloc.add(UpdateReflectionEvent(index: index, value: value));
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
                    bloc.add(SubmitReflectionEvent());
                },
                backgroundColor: Color.fromRGBO(17, 32, 55, 1.0),
                child: Icon(Icons.arrow_forward, color: Colors.white),
            ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked.withOffset(Offset(0, -50.0)),
            // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        );
  }
}


// class FloatingActionButtonLocationWithOffset extends FloatingActionButtonLocation {
//   final FloatingActionButtonLocation delegate;
//   final Offset offset;

//   FloatingActionButtonLocationWithOffset(this.delegate, this.offset);

//   @override
//   Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
//     final Offset standardOffset = delegate.getOffset(scaffoldGeometry);
//     return Offset(standardOffset.dx + offset.dx, standardOffset.dy + offset.dy);
//   }

//   @override
//   String toString() => '$delegate with offset $offset';
// }

