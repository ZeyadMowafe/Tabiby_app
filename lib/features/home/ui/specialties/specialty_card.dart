import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/colors.dart';

class SpecialtyCard extends StatelessWidget {
  final Map<String, dynamic> specialty;

  const SpecialtyCard({required this.specialty});

  @override
  Widget build(BuildContext context) {
    final color = specialty['color'] as Color;

    return Container(
      width: 100.w,
      margin: EdgeInsets.only(right: 12.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.1),
                  color.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    specialty['icon'] as IconData,
                    color: color,
                    size: 24.sp,
                  ),
                ),
                Gap(12.h),
                Text(
                  specialty['name'] as String,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(4.h),
                Text(
                  '${specialty['count']} طبيب',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.tertiaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}