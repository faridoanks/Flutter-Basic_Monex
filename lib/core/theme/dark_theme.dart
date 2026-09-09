import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData darkTheme = ThemeData(

  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,

  colorScheme: ColorScheme.dark(

    primary: AppColors.primaryDark,

    surface: const Color(0xFF121212),
  ),


  
);
