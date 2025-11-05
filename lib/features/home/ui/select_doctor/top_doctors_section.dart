// lib/features/home/ui/widgets/doctors/top_doctors_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:tabiby/features/home/ui/select_doctor/doctor_list.dart';
import 'package:tabiby/features/home/ui/widgets/section_header.dart';

class TopDoctorsSection extends StatelessWidget {
  const TopDoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          TextHeader: 'اختر طبيبك',
          SubTextHeader: 'كافة اطباء متخصصين',
        ),
        Gap(16.h),
        DoctorsList(),
      ],
    );
  }
}

final List<Map<String, dynamic>> doctors = [
  {
    'name': 'د. أحمد علي',
    'specialty': 'اطفال',
    'rating': 4.9,
    'reviews': 2847,
    'experience': 15,
    'fee': 500,
    'available': true,
    'image': null,
  },
  {
    'name': 'د. محمد سعيد',
    'specialty': 'باطنة',
    'rating': 4.9,
    'reviews': 2847,
    'experience': 15,
    'fee': 500,
    'available': true,
    'image': null,
  },
  {
    'name': 'د. سارة محمود',
    'specialty': 'جلدية',
    'rating': 4.8,
    'reviews': 1923,
    'experience': 12,
    'fee': 450,
    'available': false,
    'image': null,
  },
  {
    'name': 'د. خالد حسن',
    'specialty': 'قلب',
    'rating': 4.7,
    'reviews': 1654,
    'experience': 10,
    'fee': 400,
    'available': true,
    'image': null,
  },
];
