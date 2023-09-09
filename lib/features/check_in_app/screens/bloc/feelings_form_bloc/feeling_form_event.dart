import 'package:flutter/material.dart';

abstract class FeelingEvent {}

class ButtonPressedEvent extends FeelingEvent {
  final Color textColor;
  final String feeling;
  final String feelingForm;
  ButtonPressedEvent(this.feelingForm, this.textColor, this.feeling);
}

class ResetEvent extends FeelingEvent{}


