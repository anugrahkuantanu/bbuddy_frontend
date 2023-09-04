class NewReflectionEvent {}

class UpdateReflectionEvent extends NewReflectionEvent {
  final int index;
  final String value;

  UpdateReflectionEvent(this.index, this.value);
}

class SubmitReflectionEvent extends NewReflectionEvent {}
