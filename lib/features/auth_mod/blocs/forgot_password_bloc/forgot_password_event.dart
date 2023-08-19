abstract class ForgotPasswordEvent {}

class SendForgotPasswordEmail extends ForgotPasswordEvent {
  final String email;

  SendForgotPasswordEmail(this.email);
}
