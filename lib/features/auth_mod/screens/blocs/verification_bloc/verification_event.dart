abstract class VerificationEvent {}

class VerifyPinSubmitted extends VerificationEvent {
  final String pin;

  VerifyPinSubmitted(this.pin);
}

class ResendPin extends VerificationEvent {}

class ResendPinRequested extends VerificationEvent {}
