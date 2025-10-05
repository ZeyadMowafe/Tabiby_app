

import 'package:flutter/widgets.dart';

class HealthData {
  final String title;
  final String value;
  final String unit;
  final String status;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;

  const HealthData({
    required this.title,
    required this.value,
    required this.unit,
    required this.status,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
  });
}