abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class VerificationSuccess extends VerificationState {}

class VerificationError extends VerificationState {
  final String error;

  VerificationError(this.error);
}

class PinResent extends VerificationState {}
