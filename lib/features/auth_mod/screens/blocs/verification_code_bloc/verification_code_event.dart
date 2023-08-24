abstract class ForgotPasswordVerificationEvent {}

class VerifyPinSubmitted extends ForgotPasswordVerificationEvent {
  final String pin;

  VerifyPinSubmitted(this.pin);
}

class ResendPin extends ForgotPasswordVerificationEvent {}

class ResendPinRequested extends ForgotPasswordVerificationEvent {}
