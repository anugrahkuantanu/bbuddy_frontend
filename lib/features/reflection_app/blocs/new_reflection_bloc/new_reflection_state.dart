class NewReflectionState {}

class ReflectionInitialState extends NewReflectionState {
  final List<String> userReflections;

  ReflectionInitialState({required this.userReflections});
}

class ReflectionSubmittedState extends NewReflectionState {
  final List<dynamic> topics;
  final List<String> userReflections;

  ReflectionSubmittedState({required this.topics, required this.userReflections});
}

