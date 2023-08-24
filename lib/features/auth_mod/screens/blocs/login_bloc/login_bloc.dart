import 'package:dio/dio.dart';
import '../../../services/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc.dart';


class LoginFormBloc extends Bloc<LoginEvent, LoginState> {
  LoginFormBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginSubmitted) {
      yield LoginLoading();
      
      FormData loginData = FormData();
      loginData.fields.add(MapEntry('username', event.username));
      loginData.fields.add(MapEntry('password', event.password));

      final errorMessage = await loginForAccessToken(loginData); // directly use the service's function

      if (errorMessage.isEmpty) {
        yield LoginSuccess();
      } else if (errorMessage.contains('The username you entered isn\'t connected to an account')) {
        yield UsernameInvalid();
      } else if (errorMessage.contains('Incorrect password')) {
        yield PasswordInvalid();
      } else {
        yield LoginFailure(errorMessage);
      }
    }
  }
}

