import 'forgot_password_event.dart';
import 'forgot_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial());

  @override
  Stream<ForgotPasswordState> mapEventToState(ForgotPasswordEvent event) async* {
    if (event is SendForgotPasswordEmail) {
      yield ForgotPasswordLoading();
      // You can add your logic here to handle the email sending.
      yield ForgotPasswordSuccess(); // Or yield ForgotPasswordError(error);
    }
  }
}