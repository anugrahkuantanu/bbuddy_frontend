import 'package:flutter/material.dart';

class FeelingFormBloc {
  final Map<String, Color> buttonColors = {
    'Hurt': Color(0xFF68d0ff),
    'Sad': Color(0xFFb383ff),
    'Happy': Color(0xFF65dc99),
    'Anxious': Color(0xFFFF8C00),
    'Embarrassed': Color(0xFFFFC300),
    'Angry': Color(0xFFA63232)
  };

  final Map<String, List<String>> feelingForms = {
    'Hurt': [
      'Jealous',
      'Betrayed',
      'Isolated',
      'Shocked',
      'Victimized',
      'Tormented',
      'Deprived',
      'Abandoned',
    ],
    'Sad': [
      'Disappointed',
      'Regretful',
      'Mournful',
      'Depressed',
      'Disillusioned',
      'Pessimistic',
      'Tearful',
      'Dismayed',
    ],
    'Happy': [
      'Thankful',
      'Trusting',
      'Content',
      'Comfortable',
      'Excited',
      'Relieved',
      'Elated',
      'Confident',
    ],
    'Angry': [
      'Frustrated',
      'Annoyed',
      'Grumpy',
      'Defensive',
      'Irritated',
      'Disgusted',
      'Offended',
      'Spiteful'
    ],
    'Anxious': [
      'Afraid',
      'Confused',
      'Stressed',
      'Vulnerable',
      'Skeptical',
      'Worried',
      'Cautious',
      'Nervous'
    ],
    'Embarrassed': [
      'Self-Conscious',
      'Isolated',
      'Lonely',
      'Inferior',
      'Guilty',
      'Ashamed',
      'Pathetic',
      'Confused'
    ]
  };

  double computeTextSize(double screenWidth) {
    if (screenWidth < 380) {
      return 15;
    } else if (screenWidth < 400) {
      return 16;
    } else {
      return 17;
    }
  }
}