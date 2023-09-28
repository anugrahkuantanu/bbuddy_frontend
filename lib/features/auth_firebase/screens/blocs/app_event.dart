import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvent {
  const AppEvent();
}


@immutable
class AppEventDeleteAccount implements AppEvent {
  const AppEventDeleteAccount();
}

@immutable
class AppEventLogOut implements AppEvent {
  const AppEventLogOut();
}

@immutable
class AppEventInitialize implements AppEvent {
  const AppEventInitialize();
}

@immutable
class AppEventLogIn implements AppEvent {
  final String email;
  final String password;

  const AppEventLogIn({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventGoogleLogin implements AppEvent {}

@immutable
class AppEventGoToRegistration implements AppEvent {
  const AppEventGoToRegistration();
}

@immutable
class AppEventGoToLogin implements AppEvent {
  const AppEventGoToLogin();
}

@immutable
class AppEventRegister implements AppEvent {
  final String email;
  final String password;
  final String verifiedPassword;
  final String userName;
  final String lastName;
  final String firstName;


  const AppEventRegister({
    required this.email,
    required this.password,
    required this.verifiedPassword,
    required this.userName,
    required this.lastName,
    required this.firstName,

  });
}
