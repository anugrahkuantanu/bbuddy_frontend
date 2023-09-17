class NewReflectionEvent {}

class UpdateReflectionEvent extends NewReflectionEvent {
  final int index;
  final String value;

  UpdateReflectionEvent({required this.index, required this.value});
}

class SubmitReflectionEvent extends NewReflectionEvent {}
