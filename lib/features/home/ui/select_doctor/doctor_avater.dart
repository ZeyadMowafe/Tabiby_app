import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/colors.dart';

class DoctorAvatar extends StatelessWidget {
  const DoctorAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryBlue.withOpacity(0.2),
            AppColors.lightBlue.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Icon(
        Icons.person_rounded,
        size: 28.sp,
        color: AppColors.primaryBlue,
      ),
    );
  }
}