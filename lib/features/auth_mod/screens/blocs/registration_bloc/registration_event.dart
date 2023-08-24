import '../../../models/model.dart';


abstract class RegistrationEvent {}

class RegisterUserEvent extends RegistrationEvent {
  final UserCreate user;

  RegisterUserEvent(this.user);
}