import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/colors.dart';

class SpecialtiesRow extends StatelessWidget {
  const SpecialtiesRow({super.key, required this.clinic});
  final Map<String, dynamic> clinic;
List get specialties => clinic['specialties'] as List<String>;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: specialties.take(3).map((specialty) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: AppColors.primaryBlue.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Text(
            specialty as String,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        );
      }).toList(),
    );
  }
}