import '../bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {

  VerificationBloc() : super(VerificationInitial());

  @override
  Stream<VerificationState> mapEventToState(VerificationEvent event) async* {
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
