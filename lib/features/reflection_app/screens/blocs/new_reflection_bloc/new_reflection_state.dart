class NewReflectionState {}

class ReflectionInitialState extends NewReflectionState {
  final List userReflections;

  ReflectionInitialState(this.userReflections);
}

class ReflectionUpdatedState extends NewReflectionState {
  final List<String> userReflections;

  ReflectionUpdatedState(this.userReflections);
}

class ReflectionSubmittedState extends NewReflectionState {
  final List topics;
  final List<String> userReflections;

  ReflectionSubmittedState(this.topics, this.userReflections);
}
