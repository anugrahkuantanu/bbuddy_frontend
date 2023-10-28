import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;
import '../errors/auth_error.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;

  const AppState({
    required this.isLoading,
    this.authError,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final bool? firstUser;
  const AppStateLoggedIn({
    required bool isLoading,
    required this.user,
    this.firstUser = false,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );


  @override
  String toString() => 'AppStateLoggedIn';
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({
    required bool isLoading,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );

  @override
  String toString() =>
      'AppStateLoggedOut, isLoading = $isLoading, authError = $authError';
}

@immutable
class AppStateIsInRegistrationView extends AppState {
  const AppStateIsInRegistrationView({
    required bool isLoading,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );
}

@immutable
class AppStatePasswordReset extends AppState {
  final bool isSuccessful;

  const AppStatePasswordReset({
    required bool isLoading,
    AuthError? authError,
    required this.isSuccessful,
  }) : super(isLoading: isLoading, authError: authError);
}



extension GetUser on AppState {
  User? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

