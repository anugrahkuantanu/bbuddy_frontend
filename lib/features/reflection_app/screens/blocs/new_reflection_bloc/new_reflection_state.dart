class ReflectionState {}

class ReflectionInitialState extends ReflectionState {
  final List userReflections;

  ReflectionInitialState(this.userReflections);
}

class ReflectionUpdatedState extends ReflectionState {
  final List<String> userReflections;

  ReflectionUpdatedState(this.userReflections);
}

class ReflectionSubmittedState extends ReflectionState {
  final List topics;
  final List<String> userReflections;

  ReflectionSubmittedState(this.topics, this.userReflections);
}
