import 'package:bbuddy_app/config/config.dart';
import 'package:bbuddy_app/core/classes/route_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../services/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HeadHomeEvent {}

class FetchHeadHomeEvent extends HeadHomeEvent {}

class GoToProfilePageEvent extends HeadHomeEvent {}

class ResetStateEvent extends HeadHomeEvent {}

// STATE
abstract class HeadHomeState {}

class HeadHomeInitial extends HeadHomeState {}

class HeadHomeLoading extends HeadHomeState {}

class HeadHomeLoaded extends HeadHomeState {
  final String? name;
  final CounterStats counterStats;

  HeadHomeLoaded(this.name, this.counterStats);
}

class HeadHomeError extends HeadHomeState {
  final String error;

  HeadHomeError(this.error);
}

class NavigatedToProfilePageState extends HeadHomeState {}

// BLOC

class HeadHomeBloc extends Bloc<HeadHomeEvent, HeadHomeState> {
  final CounterStats counterStats;

  HeadHomeBloc({required this.counterStats}) : super(HeadHomeInitial()) {
    on<FetchHeadHomeEvent>(_onFetchHeadHomeEvent);
    on<GoToProfilePageEvent>(
        (event, emit) => emit(NavigatedToProfilePageState()));
    on<ResetStateEvent>((event, emit) => emit(HeadHomeInitial()));
  }

  Future<void> _onFetchHeadHomeEvent(
      FetchHeadHomeEvent event, Emitter<HeadHomeState> emit) async {
    emit(HeadHomeLoading());
    try {
      counterStats.checkCounterStats();
      List<String>? getName =
          await FirebaseAuth.instance.currentUser?.displayName?.split(" ");
      String? name =
          getName?.first; // Directly access the first element if available
      if (getName == null || getName.isEmpty) {
        // Corrected the condition
        String? getUserId = await FirebaseAuth.instance.currentUser?.uid;
        final userRef =
            FirebaseFirestore.instance.collection('users').doc(getUserId);
        try {
          final userData = await userRef.get();
          name = userData.data()?['firstName'];
        } catch (e) {
          emit(HeadHomeError('Error retrieving user data: $e'));
        }
      }
      emit(HeadHomeLoaded(name, counterStats));
    } catch (e) {
      emit(HeadHomeError('Failed to fetch home header name $e'));
    }
  }
}

class HeadHomePageWidget extends StatefulWidget {
  const HeadHomePageWidget({super.key});

  @override
  _HeadHomePageWidgetState createState() => _HeadHomePageWidgetState();
}

class _HeadHomePageWidgetState extends State<HeadHomePageWidget> {
  //late HeadHomeBloc _bloc;

  @override
  void initState() {
    super.initState();
    //_bloc = HeadHomeBloc(counterStats: context.read<CounterStats>());
    //_bloc.add(FetchHeadHomeEvent());
  }

  @override
  void dispose() {
    //_bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textSizeS = 16.0.w;
    double textSizeXl = 20.0.w;
    final counterStats = Provider.of<CounterStats>(context, listen: false);
    var tm = context.watch<ThemeProvider>();
    Color textColor = tm.isDarkMode
        ? const Color.fromRGBO(238, 238, 238, 0.933)
        : AppColors.textdark;

    return BlocProvider<HeadHomeBloc>(
      create: (context) {
        final bloc = HeadHomeBloc(counterStats: counterStats);
        bloc.add(FetchHeadHomeEvent());
        return bloc;
      },
      child: BlocConsumer<HeadHomeBloc, HeadHomeState>(
        listener: (context, state) {
          if (state is NavigatedToProfilePageState) {
            Nav.toNamed(context, '/profile');
          }
          // if (state is NavigatedToProfilePageState) {
          //   WidgetsBinding.instance?.addPostFrameCallback((_) {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const ProfileController()),
          //     );
          //   });
          // }
        },
        builder: (context, state) {
          Widget nameWidget;

          if (state is HeadHomeLoading) {
            nameWidget = const CircularProgressIndicator();
          } else if (state is HeadHomeError) {
            nameWidget = Text('Error: ${state.error}');
          } else if (state is HeadHomeLoaded) {
            nameWidget = Text(
              '${state.name ?? 'anonym'}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: textSizeXl,
                color: textColor,
              ),
            );
          } else {
            nameWidget = Container(); // For initial or any other state
          }

          return Stack(
            children: [
              Column(
                children: [
                  SizedBox(
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
                                color: textColor,
                              ),
                              onPressed: () {
                                context
                                    .read<HeadHomeBloc>()
                                    .add(GoToProfilePageEvent());
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
                                  fontSize: textSizeS,
                                  color: textColor,
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 1.5),
                  height: 150.w,
                  width: 1.3 * screenWidth,
                  child: NeededCheckinReflectionWidget(
                    checkInCount: state is HeadHomeLoaded
                        ? int.tryParse(
                            counterStats.checkInCounter?.value ?? '0')
                        : -1,
                    reflectionCount: state is HeadHomeLoaded
                        ? int.tryParse(
                            counterStats.reflectionCounter?.value ?? '0')
                        : -1,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
