// lib/features/home/ui/widgets/specialties/specialties_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/features/home/ui/widgets/section_header.dart';
import 'package:tabiby/features/home/ui/specialties/specialties_list.dart';

class SpecialtiesSection extends StatelessWidget {
  const SpecialtiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(TextHeader: 'التخصصات', SubTextHeader: 'اختر التخصص المناسب لك',),
        Gap(16.h),
        SpecialtiesList(),
      ],
    );
  }  
}





final List<Map<String, dynamic>> specialties = [
  {
    'name': 'أمراض القلب',
    'icon': Icons.favorite_rounded,
    'color': const Color(0xFFEF4444),
    'count': 124,
  },
  {
    'name': 'الأعصاب',
    'icon': Icons.psychology_rounded,
    'color': const Color(0xFF8B5CF6),
    'count': 98,
  },
  {
    'name': 'العظام',
    'icon': Icons.accessibility_new_rounded,
    'color': const Color(0xFF06B6D4),
    'count': 156,
  },
  {
    'name': 'طب الأطفال',
    'icon': Icons.child_care_rounded,
    'color': const Color(0xFFF59E0B),
    'count': 203,
  },
  {
    'name': 'الأمراض الجلدية',
    'icon': Icons.spa_rounded,
    'color': const Color(0xFF10B981),
    'count': 87,
  },
  {
    'name': 'طب العيون',
    'icon': Icons.remove_red_eye_rounded,
    'color': const Color(0xFF3B82F6),
    'count': 72,
  },
];



  