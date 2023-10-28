import 'package:bbuddy_app/core/bloc/bloc.dart';

class CheckinChatInitialEvent extends ChatEvent {
  final String? feeling;
  final String? feelingForm;
  final String? reasonEntity;
  final String? reason;
  final String? aiResponse;
  final bool? isPastCheckin;

  CheckinChatInitialEvent({
    this.feeling,
    this.feelingForm,
    this.reasonEntity,
    this.reason,
    this.aiResponse,
    this.isPastCheckin,
  });
}
