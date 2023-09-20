import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show immutable;

const Map<String, AuthError> authErrorMapping = {
  'user-not-found': AuthErrorUserNotFound(),
  'weak-password': AuthErrorWeakPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'operation-not-allowed': AuthErrorOperationNotAllowed(),
  'email-already-in-use': AuthErrorEmailAlreadyInUse(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
  'no-current-user': AuthErrorNoCurrentUser(),
  'password-not-match': AuthErrorPasswordNotMatch(),
};

@immutable 
abstract class AuthError {
  final String dialogTitle;
  final String dialogText;

  const AuthError({
    required this.dialogText,
    required this.dialogTitle
  });

  factory AuthError.from(FirebaseAuthException exception) => 
    authErrorMapping[exception.code.toLowerCase().trim()] ??
    const AuthErrorUnknown();

}

@immutable 
class AuthErrorUnknown extends AuthError{
  const AuthErrorUnknown()
        :super(
          dialogTitle: 'Authentication Error',
          dialogText: 'Unknown authentication error',
        );
}

@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          dialogTitle: 'No current user!',
          dialogText: 'No current user with this information was found!',
        );
}


@immutable 
class AuthErrorRequiresRecentLogin extends AuthError{
  const AuthErrorRequiresRecentLogin()
        :super(
          dialogTitle: 'Requires recent login',
          dialogText: 'You need to log out and log back in again',
        );
}

@immutable 
class AuthErrorOperationNotAllowed extends AuthError{
  const AuthErrorOperationNotAllowed()
        :super(
          dialogTitle: 'Operation not allowed',
          dialogText: 'You cannot register using this method at this moment!',
        );
}

@immutable 
class AuthErrorUserNotFound extends AuthError{
  const AuthErrorUserNotFound()
        :super(
          dialogTitle: 'User not found',
          dialogText: 'The given user was not found on the server!',
        );
}

@immutable 
class AuthErrorWeakPassword extends AuthError{
  const AuthErrorWeakPassword()
        :super(
          dialogTitle: 'Weak Password',
          dialogText: 'Please chose a strongger password consisting of more characters!',
        );
}

@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
          dialogTitle: 'Invalid email',
          dialogText: 'Please double check your email and try again!',
        );
}

// auth/email-already-in-use

@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
          dialogTitle: 'Email already in use',
          dialogText: 'Please choose another email to register with!',
        );
}

@immutable
class AuthErrorPasswordNotMatch extends AuthError {
  const AuthErrorPasswordNotMatch()
      : super(
          dialogTitle: 'Password Error',
          dialogText: 'Password not match',
        );
}
