import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData lightTheme = ThemeData(

  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,

  colorScheme: ColorScheme.light(

    primary: AppColors.primaryLight,

    surface: const Color(0xFFF5F5F5),
  ),


  
);
