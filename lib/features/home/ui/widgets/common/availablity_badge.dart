import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/colors.dart';

class AvailabilityBadge extends StatelessWidget {
  const AvailabilityBadge({super.key, required this.doctor});
   final Map<String, dynamic> doctor;

  @override
  Widget build(BuildContext context) {
    
    final isAvailable = doctor['available'] as bool;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isAvailable
            ? AppColors.successGreen.withOpacity(0.1)
            : AppColors.errorRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: isAvailable ? AppColors.successGreen : AppColors.errorRed,
              shape: BoxShape.circle,
            ),
          ),
          Gap(4.w),
          Text(
            isAvailable ? 'Available' : 'Busy',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: isAvailable ? AppColors.successGreen : AppColors.errorRed,
            ),
          ),
        ],
      ),
    );
  }
}


