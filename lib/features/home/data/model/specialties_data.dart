import 'package:flutter/material.dart';
import 'package:tabiby/core/theming/color_manager.dart';

class SpecialtyModel {
  final IconData icon;
  final String title;
  final Color color;

  const SpecialtyModel({
    required this.icon,
    required this.title,
    required this.color,
  });
}

class SpecialtiesData {
  static const List<SpecialtyModel> specialties = [
    SpecialtyModel(
      icon: Icons.medical_services_outlined,
      title: 'أسنان',
      color: ColorsManager.primaryColor,
    ),
    SpecialtyModel(
      icon: Icons.favorite_outline,
      title: 'قلب',
      color: ColorsManager.secondaryColor,
    ),
    SpecialtyModel(
      icon: Icons.psychology_outlined,
      title: 'مخ وأعصاب',
      color: ColorsManager.tertiaryColor,
    ),
    SpecialtyModel(
      icon: Icons.remove_red_eye_outlined,
      title: 'عيون',
      color: ColorsManager.quaternaryColor,
    ),
    SpecialtyModel(
      icon: Icons.accessibility_new_outlined,
      title: 'عظام',
      color: ColorsManager.quinaryColor,
    ),
    SpecialtyModel(
      icon: Icons.child_care_outlined,
      title: 'أطفال',
      color: ColorsManager.primaryColor,
    ),
    SpecialtyModel(
      icon: Icons.face_outlined,
      title: 'جلدية',
      color: ColorsManager.secondaryColor,
    ),
    SpecialtyModel(
      icon: Icons.pregnant_woman_outlined,
      title: 'نساء وتوليد',
      color: ColorsManager.tertiaryColor,
    ),
    SpecialtyModel(
      icon: Icons.healing_outlined,
      title: 'باطنة',
      color: ColorsManager.quaternaryColor,
    ),
    SpecialtyModel(
      icon: Icons.coronavirus_outlined,
      title: 'صدرية',
      color: ColorsManager.quinaryColor,
    ),
    SpecialtyModel(
      icon: Icons.hearing_outlined,
      title: 'أنف وأذن',
      color: ColorsManager.primaryColor,
    ),
    SpecialtyModel(
      icon: Icons.water_drop_outlined,
      title: 'مسالك بولية',
      color: ColorsManager.secondaryColor,
    ),
  ];
}