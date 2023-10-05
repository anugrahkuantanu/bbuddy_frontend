import 'package:bbuddy_app/features/reflection_app/models/model.dart';

abstract class ReflectionState {}

class ReflectionInitial extends ReflectionState {}

class ReflectionLoading extends ReflectionState {}

class ReflectionInsufficientCheckIns extends ReflectionState {
  final String errorMessage;
  ReflectionInsufficientCheckIns({required this.errorMessage});
}

class ReflectionHasEnoughCheckIns extends ReflectionState {
  final List<Reflection> history;
  ReflectionHasEnoughCheckIns(this.history);
}

class ReflectionError extends ReflectionState {
  final String errorMessage;
  ReflectionError(this.errorMessage);
}

class NavigateToNewReflectionPage extends ReflectionState {
  final List<dynamic> reflectionTopics;
  NavigateToNewReflectionPage(this.reflectionTopics);
}

class NeedsMoreCheckIns extends ReflectionState {}

class ReflectionSubmittedState extends ReflectionState {
  final List<dynamic> topics;
  final List<String> userReflections;

  ReflectionSubmittedState({required this.topics, required this.userReflections});
}
