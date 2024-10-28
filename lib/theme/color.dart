// colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Light Mode Colors
  static const primary = Colors.blue;
  static const secondary = Colors.green;
  static const tertiary = Colors.red;
  static const dark = Colors.black;
  static const light = Colors.white;
  static const bg = Color(0xFFE5E5E5);
  
  // Dark Mode Colors
  static const darkPrimary = Color(0xFF2196F3);    // Slightly lighter blue
  static const darkSecondary = Color(0xFF4CAF50);  // Slightly lighter green
  static const darkTertiary = Color(0xFFE57373);   // Lighter red
  static const darkBg = Color(0xFF121212);         // Material dark background
  static const darkSurface = Color(0xFF1E1E1E);    // Slightly lighter than background
  static const darkText = Color(0xFFE0E0E0);       // Light grey text
  
  // Common Colors
  static const error = Color(0xFFD32F2F);
  static const warning = Color(0xFFFFA000);
  static const success = Color(0xFF388E3C);
  static const info = Color(0xFF1976D2);
  
  // Gradient Colors
  static const gradientStart = Color(0xFF2196F3);
  static const gradientEnd = Color(0xFF1976D2);
  
  // Opacity Colors
  static const overlay30 = Color(0x4D000000); // 30% black
  static const overlay50 = Color(0x80000000); // 50% black
}