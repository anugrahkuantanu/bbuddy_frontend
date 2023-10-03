import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc.dart';

//bloc


class FeelingBloc extends Bloc<FeelingEvent, FeelingState> {

  FeelingBloc() : super(InitialState());

  @override
  Stream<FeelingState> mapEventToState(FeelingEvent event) async* {
    if (event is InitialState){
      yield ProvideFeelingDataState(buttonColors, feelingForms);
    }
    else if (event is ButtonPressedEvent) {
      // For the sake of completeness, let's assume that ButtonPressedEvent also has `feeling` and `textColor` properties.
      yield NavigateToReasonPageState(event.feeling, event.feelingForm, event.textColor);
    }
    else if (event is ResetEvent) {
      yield InitialState();
    }
  }

  final Map<String, Color> buttonColors = {
    'Hurt': const Color(0xFF68d0ff),
    'Sad': const Color(0xFFb383ff),
    'Happy': const Color(0xFF65dc99),
    'Anxious': const Color(0xFFFF8C00),
    'Embarrassed': const Color(0xFFFFC300),
    'Angry': const Color(0xFFA63232)
  };

  final Map<String, List<String>> feelingForms = {
    'Hurt': ['Jealous', 'Betrayed', 'Isolated', 'Shocked', 'Victimized', 'Tormented', 'Deprived', 'Abandoned'],
    'Sad': ['Disappointed', 'Regretful', 'Mournful', 'Depressed', 'Disillusioned', 'Pessimistic', 'Tearful', 'Dismayed'],
    'Happy': ['Thankful', 'Trusting', 'Content', 'Comfortable', 'Excited', 'Relieved', 'Elated', 'Confident'],
    'Angry': ['Frustrated', 'Annoyed', 'Grumpy', 'Defensive', 'Irritated', 'Disgusted', 'Offended', 'Spiteful'],
    'Anxious': ['Afraid', 'Confused', 'Stressed', 'Vulnerable', 'Skeptical', 'Worried', 'Cautious', 'Nervous'],
    'Embarrassed': ['Self-Conscious', 'Isolated', 'Lonely', 'Inferior', 'Guilty', 'Ashamed', 'Pathetic', 'Confused']
  };


}