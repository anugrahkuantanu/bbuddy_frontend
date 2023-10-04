abstract class FeelingEvent {}

class ButtonPressedEvent extends FeelingEvent {
  final String feeling;
  final String feelingForm;
  ButtonPressedEvent(this.feelingForm, this.feeling);
}

class ResetEvent extends FeelingEvent{}


