import 'package:flutter/material.dart';

class AppColors {
  static const primaryDarkColor = Color(0xFF222467);
  static const primaryColor = Color(0xFF3D3FB5);
  static const accentColor = Color(0xFFED3E55);

  static const primaryColor1 = Color(0xFF92A3FD);
  static const primaryColor2 = Color(0xFF9DCEFF);

  static const secondaryColor1 = Color(0xFFC58BF2);
  static const secondaryColor2 = Color(0xFFEEA4CE);

  static const whiteColor = Color(0xFFFFFFFF);
  static const blackColor = Color(0xFF1D1617);
  static const grayColor = Color(0xFF7B6F72);
  static const lightGrayColor = Color(0xFFF7F8F8);
  static const midGrayColor = Color(0xFFADA4A5);

  static List<Color> get primaryG => [primaryColor1, primaryColor2];

  static List<Color> get secondaryG => [secondaryColor1, secondaryColor2];

  static const splashAppGradientBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      // Color.fromARGB(122, 224, 234, 255),
      // Color.fromARGB(166, 224, 234, 255),
      // Color.fromARGB(255, 224, 234, 255),

      Color.fromRGBO(255, 255, 255, 1),
      Color.fromRGBO(224, 234, 255, 0.52),
      Color.fromRGBO(224, 234, 255, 0.68),
      Color.fromRGBO(224, 234, 255, 1),
    ],
  );

  static const appGradientBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(243, 246, 255, 1),
      Color.fromRGBO(243, 246, 255, 1),
      // Color.fromRGBO(224, 234, 255, 0.48),
      // Color.fromRGBO(224, 234, 255, 0.52),
      // Color.fromRGBO(224, 234, 255, 1),
    ],
  );

  static const appLoginGradientBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(224, 234, 255, 0.48),
      Color.fromRGBO(224, 234, 255, 0.52),
      Color.fromRGBO(224, 234, 255, 1),
    ],
  );
}
