class ReflectionEvent {}

class UpdateReflectionEvent extends ReflectionEvent {
  final int index;
  final String value;

  UpdateReflectionEvent(this.index, this.value);
}

class SubmitReflectionEvent extends ReflectionEvent {}
