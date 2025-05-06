import 'package:flutter/material.dart';

class AppColors {
  static const Color DeepBlueButton = Color(0xFF00203F);
  static const Color SlateGrayText = Color(0xFF4A4A4A);
  static const Color PremiumFeature = Color(0xFFFFC857);
  static const Color White = Color(0xFFFFFFFF);
  static const Color Black = Color(0xFF000000);
  static const Color Grey = Color(0xFF808080); // Example gray color
  static const Color LightGrey = Color.fromRGBO(185, 212, 223, 0.5);

  // Gradient for sea colors
  static const LinearGradient SeaGradient = LinearGradient(
    colors: [
      Color(0xFF006994), // Ocean Blue (deep part of the sea)
      Color(0xFF40E0D0), // Turquoise (lighter, shallow water)
      Color.fromARGB(255, 127, 240, 182), // Seafoam Green (foam and waves)
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
