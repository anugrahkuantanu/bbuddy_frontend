import 'package:flutter/material.dart';

class AppColors {
  static const int _black = 0xFF222831;
  static const MaterialColor black = MaterialColor(_black, {
    500: Color(_black),
  });


  static const int _grey = 0xEEEEEEEE;
  static const MaterialColor grey = MaterialColor(_grey, {
    500: Color(_grey),
  });


static final MaterialColor darkgrey = MaterialColor(
  _darkGreyPrimaryValue,
  <int, Color>{
    50: Colors.grey[100]!,
    100: Colors.grey[200]!,
    200: Colors.grey[300]!,
    300: Colors.grey[400]!,
    400: Colors.grey[500]!,
    500: Colors.grey[600]!,
    600: Colors.grey[700]!,
    700: Colors.grey[800]!,
    800: Colors.grey[900]!,
    900: Colors.grey[900]!,
  },
);

static const int _darkGreyPrimaryValue = 0xFF616161; 






  static const MaterialColor textdark= MaterialColor(_black, {
    500: Color(_black),
  });


  static const MaterialColor textlight = MaterialColor(_grey, {
    500: Color(_grey),
  });


  static const int _space = 0xFF393E46;
  static const MaterialColor space = MaterialColor(_space, {
    400: Color(0xFF424242),
    500: Color(_space),
  });


  static const int _teal = 0xFF00ADB5;
  static const MaterialColor lightscreen = MaterialColor(
    _teal,
    <int, Color>{
      50: Color(0xFFE0F7FA),
      100: Color(0xFFB2EBF2),
      200: Color(0xFF80DEEA),
      300: Color(0xFF4DD0E1),
      400: Color(0xFF26C6DA),
      500: Color(_teal),
      600: Color(0xFF00ACC1),
      700: Color(0xFF0097A7),
      800: Color(0xFF00838F),
      900: Color(0xFF006064),
    },
  );

// static const int _deepBlue = 0xFF2D425F;
// static const MaterialColor deepBlue = MaterialColor(_deepBlue, {
//   400: Color(0xFF2D425F),  // You can adjust this shade if needed
//   500: Color(_deepBlue),
// });

  static const int _deepBlue = 0xFF2D425F;
  static const MaterialColor darkscreen = MaterialColor(
    _deepBlue, 
    <int, Color>{
    50: Color(0xFFA5A9B8),   // Lightest shade
    100: Color(0xFF7C8096),
    200: Color(0xFF53576E),
    300: Color(0xFF2A2E46),
    400: Color(0xFF2D425F),   // The original color you provided
    500: Color(_deepBlue),    // Same as 400
    600: Color(0xFF283C57),   // Slightly darker than 500
    700: Color(0xFF22364F),
    800: Color(0xFF1C3047),
    900: Color(0xFF121A2F),   // Darkest shade
  }
  );

}