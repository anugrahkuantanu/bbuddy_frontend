import 'dart:async';
import 'package:flutter/material.dart';
import '../bloc.dart';
import '../../../models/model.dart';
import '../../../services/service.dart';


class RegistrationBloc {
  final registrationController = {
    'firstName': TextEditingController(),
    'lastName': TextEditingController(),
    'username': TextEditingController(),
    'email': TextEditingController(),
    'phone': TextEditingController(),
    'password': TextEditingController(),
  };

  final _stateStreamController = StreamController<RegistrationState>();
  Stream<RegistrationState> get state => _stateStreamController.stream;

  void dispatch(RegistrationEvent event) async {
    if (event is RegisterUserEvent) {
      _stateStreamController.sink.add(LoadingRegistrationState());
      String errorMessage = await register(event.user);
      if (errorMessage.isEmpty) {
        _stateStreamController.sink.add(SuccessRegistrationState());
      } else if (errorMessage.contains('Email already registered')) {
        _stateStreamController.sink.add(EmailAlreadyRegisteredState());
      } else if (errorMessage.contains('Username already registered')) {
        _stateStreamController.sink.add(UsernameAlreadyRegisteredState());
      } else {
        _stateStreamController.sink.add(ErrorRegistrationState(errorMessage));
      }
    }
  }


  Future<String> register(UserCreate user) async {
    String errorMessage = await registerUser(user);
    return errorMessage;
  }

  void dispose() {
    _stateStreamController.close();
  }
}