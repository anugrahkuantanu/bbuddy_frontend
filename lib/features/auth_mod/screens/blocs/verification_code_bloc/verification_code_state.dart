abstract class ForgotPasswordVerificationState {}

class VerificationInitial extends ForgotPasswordVerificationState {}

class VerificationSuccess extends ForgotPasswordVerificationState {}

class VerificationError extends ForgotPasswordVerificationState {
  final String error;

  VerificationError(this.error);
}

class PinResent extends ForgotPasswordVerificationState {}
