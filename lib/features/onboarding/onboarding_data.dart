import 'package:flutter/cupertino.dart';

class OnboardingData {
  final String title;
  final String subtitle;
  final String description;
  final String stats;
  final IconData primaryIcon;
  final List<IconData> backgroundIcons;
  final Color color;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.stats,
    required this.primaryIcon,
    required this.backgroundIcons,
    required this.color,
  });
}