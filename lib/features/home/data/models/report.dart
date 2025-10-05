

import 'package:flutter/widgets.dart';

class Report {
  final String title;
  final String description;
  final String date;
  final IconData icon;
  final Color color;
  final String status;

  const Report({
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
    required this.color,
    required this.status,
  });
}