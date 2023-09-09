import 'package:flutter/material.dart';

// state

abstract class FeelingState {}

class InitialState extends FeelingState {}

class ProvideFeelingDataState extends FeelingState {
  final Map<String, Color> buttonColors;
  final Map<String, List<String>> feelingForms;

  ProvideFeelingDataState(this.buttonColors, this.feelingForms);
}

class NavigateToReasonPageState extends FeelingState {
  final String feeling;
  final String feelingForm;
  final Color textColor;

  NavigateToReasonPageState(this.feeling, this.feelingForm, this.textColor);
}


