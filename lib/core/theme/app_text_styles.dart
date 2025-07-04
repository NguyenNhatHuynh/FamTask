import 'package:flutter/material.dart';
import 'package:famtask/core/theme/app_colors.dart';

class AppTextStyles {
  static final titleLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static final bodyMedium = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );

  static final button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}