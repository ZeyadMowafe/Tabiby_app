import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/features/home/data/model/specialties_data.dart';
import 'package:tabiby/features/home/ui/widgets/specialty_card.dart';
import 'package:tabiby/features/home/ui/widgets/unified_section_header.dart';

class SpecialtiesSelection extends StatelessWidget {
  const SpecialtiesSelection({
    super.key,
    this.onViewAllPressed,
  });

  final VoidCallback? onViewAllPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UnifiedSectionHeader(
          subtitle: "اختر التخصص المناسب لك",
          title: 'التخصصات',
          showButton: true,
          onPressed: onViewAllPressed ?? () {}, // استخدم الـ callback
        ),
        Gap(20.h),
        SizedBox(
          height: 115.h,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            scrollDirection: Axis.horizontal,
            itemCount: SpecialtiesData.specialties.length > 5 
                ? 5 
                : SpecialtiesData.specialties.length,
            itemBuilder: (context, index) {
              final specialty = SpecialtiesData.specialties[index];
              return SpecialtyCard(
                icon: specialty.icon,
                title: specialty.title,
                color: specialty.color,
                width: 95.w,
                margin: EdgeInsets.only(left: 12.w),
              );
            },
          ),
        ),
      ],
    );
  }
}