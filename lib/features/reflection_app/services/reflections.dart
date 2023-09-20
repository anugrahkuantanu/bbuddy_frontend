// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dio/dio.dart';
// import '/config/config.dart';
// import '../../../core/classes/dio_util.dart';
// import '../models/reflection.dart';

// // 1. States
// abstract class ReflectionState {}

// class ReflectionInitial extends ReflectionState {}

// class ReflectionLoading extends ReflectionState {}

// class ReflectionLoaded<T> extends ReflectionState {
//   final T data;
//   ReflectionLoaded(this.data);
// }

// class ReflectionError extends ReflectionState {
//   final String message;
//   ReflectionError(this.message);
// }

// // 2. Events
// abstract class ReflectionEvent {}

// class GetReflectionTopicsEvent extends ReflectionEvent {}

// class GetReflectionHistoryEvent extends ReflectionEvent {
//   final DateTime? startDate;
//   final DateTime? endDate;
//   GetReflectionHistoryEvent({this.startDate, this.endDate});
// }

// class GetMoodReflectionsEvent extends ReflectionEvent {
//   final List topics;
//   final List? userReflections;
//   final String heading;
//   GetMoodReflectionsEvent({required this.topics, this.userReflections, required this.heading});
// }

// class FetchHeadingEvent extends ReflectionEvent {
//   final List topics;
//   FetchHeadingEvent(this.topics);
// }

// class CountReflectionsEvent extends ReflectionEvent {}

// // 3. Bloc
// class ReflectionBloc extends Bloc<ReflectionEvent, ReflectionState> {
//   final dio = Dio(BaseOptions(baseUrl: ApiEndpoint.baseURL));

//   ReflectionBloc() : super(ReflectionInitial()) {
//     on<GetReflectionTopicsEvent>(_onGetReflectionTopicsEvent);
//     on<GetReflectionHistoryEvent>(_onGetReflectionHistoryEvent);
//     on<GetMoodReflectionsEvent>(_onGetMoodReflectionsEvent);
//     on<FetchHeadingEvent>(_onFetchHeadingEvent);
//     on<CountReflectionsEvent>(_onCountReflectionsEvent);
//   }

//   void _onGetReflectionTopicsEvent(GetReflectionTopicsEvent event, Emitter<ReflectionState> emit) async{
//     emit(ReflectionLoading());
//     try {
//       final response = await dio.get('/reflection_topics');
//       if (response.statusCode == 200) {
//         emit(ReflectionLoaded<List>(response.data["questions"]));
//       } else {
//         emit(ReflectionError('Failed to load check-ins'));
//       }
//     } catch (e) {
//       emit(ReflectionError('Failed to load check-ins: $e'));
//     }
//   }

//   void _onGetReflectionHistoryEvent(GetReflectionHistoryEvent event, Emitter<ReflectionState> emit) async{
//     emit(ReflectionLoading());
//     try {
//       final response = await dio.get(
//         '/reflection_history',
//         queryParameters: {
//           'start_date': event.startDate?.toIso8601String(),
//           'end_date': event.endDate?.toIso8601String(),
//         },
//       );
//       if (response.statusCode == 200) {
//         if (response.data is! List) {
//           emit(ReflectionError('Unexpected data format received'));
//         }
//         final List<dynamic> reflectionsJson = response.data as List<dynamic>;
//         final List<Reflection> reflections = reflectionsJson
//             .map((reflectionJson) => Reflection.fromJson(reflectionJson))
//             .toList();
//         emit(ReflectionLoaded<List<Reflection>>(reflections));
//       } else {
//         emit(ReflectionError('Failed to load reflections'));
//       }
//     } catch (e) {
//       emit(ReflectionError('Failed to load reflections: $e'));
//     }
//   }

//   void _onGetMoodReflectionsEvent(GetMoodReflectionsEvent event, Emitter<ReflectionState> emit) async{
//     emit(ReflectionLoading());
//     try {
//       final response = await dio.post(
//         '/mood_reflection',
//         data: {
//           'topics': event.topics,
//           'user_reflections': event.userReflections,
//           'heading': event.heading
//         },
//       );
//       final responseData = Map<String, dynamic>.from(response.data);
//       final reflection = Reflection.fromJson(responseData);
//       emit(ReflectionLoaded<Reflection>(reflection));
//     } catch (e) {
//       emit(ReflectionError('Failed to process mood reflections: $e'));
//     }
//   }

//   void _onFetchHeadingEvent(FetchHeadingEvent event, Emitter<ReflectionState> emit) async{
//     emit(ReflectionLoading());
//     try {
//       final response = await dio.post(
//         '$ApiEndpoint.baseURL/reflection_heading',
//         data: {'topics': event.topics},
//       );
//       if (response.statusCode == 200) {
//         final heading = response.data["heading"];
//         emit(ReflectionLoaded<String>(heading));
//       } else {
//         emit(ReflectionError('Failed to load data'));
//       }
//     } catch (e) {
//       emit(ReflectionError('Failed to fetch heading: $e'));
//     }
//   }

//   void _onCountReflectionsEvent(CountReflectionsEvent event, Emitter<ReflectionState> emit) async{
//     emit(ReflectionLoading());
//     try {
//       final response = await dio.get('/count_reflections');
//       if (response.statusCode == 200) {
//         final count = response.data as int;
//         emit(ReflectionLoaded<int>(count));
//       } else {
//         emit(ReflectionError('Failed to load check-ins'));
//       }
//     } catch (e) {
//       emit(ReflectionError('Failed to load check-ins: $e'));
//     }
//   }
// }





import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '/config/config.dart';
import '../../../core/classes/dio_util.dart';
import '../models/reflection.dart';

Future<List> getReflectionTopics() async {
  final dio = Dio(BaseOptions(baseUrl: ApiEndpoint.baseURL));
  dio.interceptors.add(AuthInterceptor(dio));

  try {
    final response = await dio.get(
      '/reflection_topics',
      //queryParameters: {'session_id': session_id},
    );
    if (response.statusCode == 200) {
      return response.data["questions"];
    } else {
      throw Exception('Failed to load check-ins');
    }
  } catch (e) {
    throw Exception('Failed to load check-ins: $e');
  }
}



Future<List<Reflection>> getReflectionHistory(
    {DateTime? startDate, DateTime? endDate}) async {
  final dio = Dio(BaseOptions(baseUrl: ApiEndpoint.baseURL));
  // code here
  dio.interceptors.add(AuthInterceptor(dio));
  try {
    final response = await dio.get(
      '/reflection_history',
      queryParameters: {
        'start_date': startDate?.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
      },
    );
    if (response.statusCode == 200) {
      if (response.data is! List) {
        throw Exception('Unexpected data format received');
      }
      final List<dynamic> reflectionsJson = response.data as List<dynamic>;
      final List<Reflection> reflections = reflectionsJson
          .map((reflectionJson) => Reflection.fromJson(reflectionJson))
          .toList();
      return reflections;
    } else {
      throw Exception('Failed to load reflections');
    }
  } catch (e) {
    throw Exception('Failed to load reflections: $e');
  }
}


Future<Reflection> getMoodReflections(
    List topics, List? userReflections, String heading) async {
  final dio = Dio(BaseOptions(baseUrl: ApiEndpoint.baseURL));
  dio.interceptors.add(AuthInterceptor(dio));
  final response = await dio.post(
    '/mood_reflection',
    data: {
      'topics': topics,
      'user_reflections': userReflections,
      'heading': heading
    },
  );

  final responseData = Map<String, dynamic>.from(response.data);

  return Reflection.fromJson(responseData);
}

class ReflectionHeading extends ChangeNotifier {
  String heading = '';

  String get result => heading;

  final dio = Dio();

  Future<void> fetchHeading(List topics) async {
    final response = await dio.post(
      '$ApiEndpoint.baseURL/reflection_heading',
      data: {'topics': topics},
    );
    if (response.statusCode == 200) {
      heading = response.data["heading"];
      notifyListeners();
    } else {
      throw Exception('Failed to load data');
    }
  }
}

Future<int> countReflections() async {
  final dio = Dio(BaseOptions(baseUrl: ApiEndpoint.baseURL));
  dio.interceptors.add(AuthInterceptor(dio));
  try {
    final response = await dio.get('/count_reflections');
    if (response.statusCode == 200) {
      return response.data as int;
    } else {
      throw Exception('Failed to load check-ins');
    }
  } catch (e) {
    throw Exception('Failed to load check-ins: $e');
  }
}


