// import 'package:flutter/material.dart';
// import '../../../auth_mod/screens/screen.dart';
// import '../widgets/widget.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import '../../services/service.dart';
// import '../../../auth_mod/services/service.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';


// abstract class HeadHomePageEvent {}

// class FetchUserDetails extends HeadHomePageEvent {}

// class UpdateCheckInCounter extends HeadHomePageEvent {
//   final String value;
//   UpdateCheckInCounter(this.value);
// }

// class UpdateReflectionCounter extends HeadHomePageEvent {
//   final String value;
//   UpdateReflectionCounter(this.value);
// }

// abstract class HeadHomePageState {}

// class InitialState extends HeadHomePageState {}

// class UserDetailsLoaded extends HeadHomePageState {
//   final UserDetailsProvider userDetails;
//   UserDetailsLoaded(this.userDetails);
// }

// class CounterStatsLoaded extends HeadHomePageState {
//   final String checkInCounter;
//   final String reflectionCounter;
//   CounterStatsLoaded(this.checkInCounter, this.reflectionCounter);
// }

// class HeadHomePageError extends HeadHomePageState {
//   final String error;
//   HeadHomePageError(this.error);
// }


// class HeadHomePageBloc extends Bloc<HeadHomePageEvent, HeadHomePageState> {
//   final CounterStats counterStats = CounterStats();

//   HeadHomePageBloc() : super(InitialState()) {
//     on<FetchUserDetails>(_onFetchUserDetails);
//     on<UpdateCheckInCounter>(_onUpdateCheckInCounter);
//     on<UpdateReflectionCounter>(_onUpdateReflectionCounter);
//   }

//   Future<void> _onFetchUserDetails(FetchUserDetails event, Emitter<HeadHomePageState> emit) async {
//     try {
//       await counterStats.checkCounterStats(); // Ensure counters are initialized
//       // Assuming you'd like to fetch the user details here, you'd do:
//       // final userDetails = await someService.fetchUserDetails();
//       // emit(UserDetailsLoaded(userDetails));
//       // For this example, I'm just emitting a generic success state:
//       emit(UserDetailsLoaded(UserDetailsProvider())); // Placeholder
//     } catch (e) {
//       emit(HeadHomePageError("Failed to fetch user details"));
//     }
//   }

//   Future<void> _onUpdateCheckInCounter(UpdateCheckInCounter event, Emitter<HeadHomePageState> emit) async {
//     try {
//       counterStats.updateCheckInCounter();
//       emit(CounterStatsLoaded(counterStats.checkInCounter?.value ?? "0", counterStats.reflectionCounter?.value ?? "0"));
//     } catch (e) {
//       emit(HeadHomePageError("Failed to update check-in counter"));
//     }
//   }

//   Future<void> _onUpdateReflectionCounter(UpdateReflectionCounter event, Emitter<HeadHomePageState> emit) async {
//     try {
//       counterStats.updateReflectionCounter();
//       emit(CounterStatsLoaded(counterStats.checkInCounter?.value ?? "0", counterStats.reflectionCounter?.value ?? "0"));
//     } catch (e) {
//       emit(HeadHomePageError("Failed to update reflection counter"));
//     }
//   }
// }


// class HeadHomePageWidget extends StatelessWidget {
//   final Color? text_color;

//   const HeadHomePageWidget({Key? key, this.text_color}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HeadHomePageBloc, HeadHomePageState>(
//       builder: (context, state) {
//         double screenWidth = MediaQuery.of(context).size.width;
//         double text_size_s = 16.0.w;
//         double text_size_xl = 20.0.w;

//         if (state is UserDetailsLoaded) {
//           return Stack(
//             children: [
//               // ... rest of your Stack children
//               Positioned(
//                 top: 25.w,
//                 left: 10.w,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Welcome',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: text_size_s,
//                         color: text_color ?? Colors.white,
//                       ),
//                     ),
//                     state.details != null && state.details?.firstName != null
//                         ? Text(
//                             state.details!.firstName,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: text_size_xl,
//                               color: text_color ?? Colors.white,
//                             ),
//                           )
//                         : CircularProgressIndicator(),
//                   ],
//                 ),
//               ),
//               // ... rest of your Stack children
//             ],
//           );
//         } else if (state is CounterStatsLoaded) {
//           return Stack(
//             children: [
//               // ... rest of your Stack children
//               Positioned(
//                 top: 0.25 * screenWidth,
//                 left: (screenWidth - 0.95 * screenWidth) / 2,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 2, horizontal: 1.5),
//                   height: 150.w,
//                   width: 1.3 * screenWidth,
//                   child: NeededCheckinReflectionWidget(
//                     text_color: text_color ?? Colors.white,
//                     checkInCount: int.tryParse(state.checkInCounter), 
//                     reflectionCount: int.tryParse(state.reflectionCounter),
//                   ),
//                 ),
//               ),
//               // ... rest of your Stack children
//             ],
//           );
//         } else if (state is HeadHomePageError) {
//           return Center(child: Text(state.errorMessage));
//         }

//         return CircularProgressIndicator(); // default loading state
//       },
//     );
//   }
// }











// class HeadHomePageWidget extends StatelessWidget {
//   final BuildContext context;
//   final Color? text_color;

//   const HeadHomePageWidget(this.context, {this.text_color});

//   @override
//   Widget build(BuildContext context) {
//     final userDetails = Provider.of<UserDetailsProvider>(context);
//     final counter_stats = CounterStats();
//     // final counter_stats = Provider.of<CounterStats>(context);

//     double screenWidth = MediaQuery.of(context).size.width;
    
//     double text_size_s = 16.0.w;
//     double text_size_xl = 20.0.w;

//     return Stack(
//       children: [
//         Column(
//           children: [
//             Container(
//               height: 0.7 * screenWidth,
//               child: Stack(
//                 children: [
//                   Positioned(
//                     top: 25.w,
//                     right: 10.w,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(7),
//                       ),
//                       child: IconButton(
//                         icon: Icon(
//                           Icons.person,
//                           size: 30.w,
//                           color: text_color ?? Colors.white,
//                         ),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ProfilePage()),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 25.w,
//                     left: 10.w,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Welcome',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: text_size_s,
//                             color: text_color ?? Colors.white,
//                           ),
//                         ),
//                         userDetails.details != null &&
//                                 userDetails.details?.firstName != null
//                             ? Text(
//                                 userDetails.details!.firstName,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: text_size_xl,
//                                   color: text_color ?? Colors.white,
//                                 ),
//                               )
//                             : CircularProgressIndicator(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         Positioned(
//           top: 0.25 * screenWidth,
//           //top: 0.12 * screenHeight,
//           left: (screenWidth - 0.95 * screenWidth) / 2,
//           child: Container(
//             padding: EdgeInsets.symmetric(vertical: 2, horizontal: 1.5),
//             height: 150.w, // Increase the height value to make it taller
//             //height: 0.15 * screenHeight, // Increase the height value to make it taller
//             width:
//                 1.3 * screenWidth, // Increase the width value to make it wider
//             child: NeededCheckinReflectionWidget(
//               text_color: text_color ?? Colors.white,
//               checkInCount: int.tryParse(counter_stats.checkInCounter?.value ?? ''), // Number of check-ins completed
//               reflectionCount: int.tryParse(counter_stats.reflectionCounter?.value ?? ''), // Number of reflections completed
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
