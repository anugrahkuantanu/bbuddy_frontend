import '../bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class ForgotPasswordVerificationBloc extends Bloc<ForgotPasswordVerificationEvent, ForgotPasswordVerificationState> {

  ForgotPasswordVerificationBloc() : super(VerificationInitial());

  @override
  Stream<ForgotPasswordVerificationState> mapEventToState(ForgotPasswordVerificationEvent event) async* {
    if (event is VerifyPinSubmitted) {
      if (event.pin == "1234") { // Replace with actual pin verification logic.
        yield VerificationSuccess();
      } else {
        yield VerificationError("Incorrect pin!");
      }
    } else if (event is ResendPin) {
      // Logic to resend pin
      yield PinResent();
    }
  }
}
