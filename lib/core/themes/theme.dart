import 'package:dlza_legal_app/core/constants/app_colors.dart';
import 'package:dlza_legal_app/core/constants/app_defaults.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFF0bbfdf),
      primaryColor: const Color(0xFF0bbfdf),
      indicatorColor: Colors.black,
      fontFamily: "Muli",
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: kTextColor),
        bodyMedium: TextStyle(color: kTextColor),
        bodySmall: TextStyle(color: kTextColor),
        titleLarge: TextStyle(
          fontSize: AppDefaults.fontSizeTitleLarge,
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          fontSize: AppDefaults.fontSizeTitleMedium,
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          fontSize: AppDefaults.fontSizeTitleSmall,
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: AppColors.black,
          fontSize: AppDefaults.fontSizeLabelMedium,
        ),
        labelLarge: TextStyle(
          color: AppColors.black,
          fontSize: AppDefaults.fontSizeSubTitle,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        border: outlineInputBorder,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.navigationBarLight,
        indicatorColor: AppColors.navigationOptionLight,
      ),
    );
  }
}

const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(28)),
  borderSide: BorderSide(color: kTextColor),
  gapPadding: 10,
);
