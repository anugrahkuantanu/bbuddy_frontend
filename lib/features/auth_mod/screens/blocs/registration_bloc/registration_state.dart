abstract class RegistrationState {}
class EmailAlreadyRegisteredState extends RegistrationState {}

class UsernameAlreadyRegisteredState extends RegistrationState {}

class InitialRegistrationState extends RegistrationState {}

class LoadingRegistrationState extends RegistrationState {}

class SuccessRegistrationState extends RegistrationState {}

class ErrorRegistrationState extends RegistrationState {
  final String error;

  ErrorRegistrationState(this.error);
}
