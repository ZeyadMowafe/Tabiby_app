import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/colors.dart';

class DoctorInfo extends StatelessWidget {
  const DoctorInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52.w,
          height: 52.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.appointment.withOpacity(0.2),
                AppColors.appointmentSecondary.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(
            Icons.person_rounded,
            color: AppColors.appointment,
            size: 26.sp,
          ),
        ),
        Gap(12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dr. Sarah Ahmed',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryText,
              ),
            ),
            Gap(4.h),
            Text(
              'Neurologist',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.appointment,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}