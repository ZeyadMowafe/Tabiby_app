import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tabiby/core/theming/colors.dart';

class AppTextStyles {
  static const TextStyle headerTitle = TextStyle(
    fontSize: 28,
    color: Colors.white,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
  );
  
  static const TextStyle headerSubtitle = TextStyle(
    fontSize: 16,
    color: AppColors.headerText,
    fontWeight: FontWeight.w400,
  );
  
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryText,
    letterSpacing: -0.5,
  );
  
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  );
  
  static const TextStyle cardValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryText,
    letterSpacing: -0.5,
  );
  
  static const TextStyle cardUnit = TextStyle(
    fontSize: 12,
    color: AppColors.tertiaryText,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle cardDescription = TextStyle(
    fontSize: 13,
    color: AppColors.secondaryText,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle statusText = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
}
