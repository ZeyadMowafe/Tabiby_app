// lib/features/home/ui/widgets/specialties/specialties_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/features/home/data/models/specialty_model.dart';
import 'package:tabiby/features/home/ui/widgets/common/section_header.dart';
import 'package:tabiby/features/home/ui/specialties/specialties_list.dart';

class SpecialtiesSection extends StatelessWidget {
  const SpecialtiesSection({super.key, required this.specialties});
final List<Specialty> specialties;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(TextHeader: 'التخصصات', SubTextHeader: 'اختر التخصص المناسب لك',),
        Gap(16.h),
        SpecialtiesList(specialties: specialties,),
      ],
    );
  }  
}






  