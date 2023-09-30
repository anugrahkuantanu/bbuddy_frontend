import 'package:bbuddy_app/core/classes/route_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../services/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


abstract class HeadHomeEvent {}

class FetchHeadHomeEvent extends HeadHomeEvent {}

class GoToProfilePageEvent extends HeadHomeEvent{}

class ResetStateEvent extends HeadHomeEvent{}


// STATE
abstract class HeadHomeState {}

class HeadHomeInitial extends HeadHomeState {}

class HeadHomeLoading extends HeadHomeState {}

class HeadHomeLoaded extends HeadHomeState {
  final String? name;

  HeadHomeLoaded(this.name);
}

class HeadHomeError extends HeadHomeState {
  final String error;

  HeadHomeError(this.error);
}

class NavigatedToProfilePageState extends HeadHomeState{}



// BLOC

class HeadHomeBloc extends Bloc<HeadHomeEvent, HeadHomeState> {
  final CounterStats counterStats;

  HeadHomeBloc({required this.counterStats}) : super(HeadHomeInitial()) {
    on<FetchHeadHomeEvent>(_onFetchHeadHomeEvent); 
    on<GoToProfilePageEvent>((event, emit) => emit(NavigatedToProfilePageState()));
    on<ResetStateEvent>((event, emit) => emit(HeadHomeInitial()));

}

  
  

  Future<void> _onFetchHeadHomeEvent(FetchHeadHomeEvent event, Emitter<HeadHomeState> emit) async {
    emit(HeadHomeLoading());
    try {
      List<String>? getName = await FirebaseAuth.instance.currentUser?.displayName?.split(" ");
      String? name = getName?.first; // Directly access the first element if available
      if (getName == null || getName.isEmpty) {  // Corrected the condition
        String? getUserId = await FirebaseAuth.instance.currentUser?.uid;
        final userRef = FirebaseFirestore.instance.collection('users').doc(getUserId);
        try {
          final userData = await userRef.get();
          name = userData.data()?['firstName'];
          print(name);
        } catch (e) {
          print('Error retrieving user data: $e');
        }
      }
      emit(HeadHomeLoaded(name));
    } catch (error) {
      emit(HeadHomeError('Failed to fetch home header name'));
    }
  }
}



// class HeadHomePageWidget extends StatefulWidget {
//   final Color? text_color;

//   const HeadHomePageWidget({this.text_color});

//   @override
//   _HeadHomePageWidgetState createState() => _HeadHomePageWidgetState();
// }

// class _HeadHomePageWidgetState extends State<HeadHomePageWidget> {
//   late HeadHomeBloc _bloc;

//   @override
//   void initState() {
//     super.initState();
//     _bloc = HeadHomeBloc(counterStats: context.read<CounterStats>());
//     _bloc.add(FetchHeadHomeEvent());
//   }

//   @override
//   void dispose() {
//     _bloc.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double text_size_s = 16.0.w;
//     double text_size_xl = 20.0.w;
//     final counter_stats = Provider.of<CounterStats>(context, listen: false);

//     return BlocProvider<HeadHomeBloc>(
//       create: (context) {
//         final bloc = HeadHomeBloc(counterStats: counter_stats);
//         bloc.add(FetchHeadHomeEvent());
//         return bloc;
//       },
//       child: BlocConsumer<HeadHomeBloc, HeadHomeState>(
//         listener: (context, state) {
//           if (state is NavigatedToProfilePageState) {
//               Nav.toNamed(context, '/profile');
//           }
//         },
//         builder: (context, state) {
//           Widget nameWidget;

//           if (state is HeadHomeLoading) {
//             nameWidget = CircularProgressIndicator();
//           } else if (state is HeadHomeError) {
//             nameWidget = Text('Error: ${state.error}');
//           } else if (state is HeadHomeLoaded) {
//             nameWidget = Text(
//               '${state.name ?? 'anonym'}',
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: text_size_xl,
//                 color: widget.text_color ?? Colors.white,
//               ),
//             );
//           } else {
//             nameWidget = Container();  // For initial or any other state
//           }

class HeadHomePageWidget extends StatelessWidget {
  final Color? text_color;

  const HeadHomePageWidget({this.text_color});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double text_size_s = 16.0.w;
    double text_size_xl = 20.0.w;

    return BlocConsumer<HeadHomeBloc, HeadHomeState>(
        listener: (context, state) {
          if (state is NavigatedToProfilePageState) {
            Nav.toNamed(context, '/profile');
          }
        },
        builder: (context, state) {
          Widget nameWidget;

          if (state is HeadHomeLoading) {
            nameWidget = CircularProgressIndicator();
          } else if (state is HeadHomeError) {
            nameWidget = Text('Error: ${state.error}');
          } else if (state is HeadHomeLoaded) {
            nameWidget = Text(
              '${state.name ?? 'anonym'}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: text_size_xl,
                color: text_color ?? Colors.white,
              ),
            );
          }  else {
            nameWidget = Container();  // For initial or any other state
          }


          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 0.7 * screenWidth,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 25.w,
                          right: 10.w,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.person,
                                size: 30.w,
                                color: text_color ?? Colors.white,
                              ),
                              onPressed: () {
                                context.read<HeadHomeBloc>().add(GoToProfilePageEvent());
                                // Navigate to profile page here, if needed.
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 25.w,
                          left: 10.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: text_size_s,
                                  color: text_color ?? Colors.white,
                                ),
                              ),
                              nameWidget
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0.25 * screenWidth,
                left: (screenWidth - 0.95 * screenWidth) / 2,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 1.5),
                  height: 150.w,
                  width: 1.3 * screenWidth,
                  child: NeededCheckinReflectionWidget(
                    text_color: text_color ?? Colors.white,
                    // checkInCount: int.tryParse(counter_stats.checkInCounter?.value ?? '0'),
                    // reflectionCount: int.tryParse(counter_stats.reflectionCounter?.value ?? '0'),
                  ),
                ),
              ),
            ],
          );
        }
        );
  }
}
