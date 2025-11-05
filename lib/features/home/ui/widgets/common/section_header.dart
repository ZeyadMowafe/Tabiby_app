import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key,  required this.TextHeader, required this.SubTextHeader});
  final String TextHeader;
  final String SubTextHeader ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            ),
            child: Row(
              children: [
                
                Icon(
                  Icons.arrow_back_rounded,
                  size: 14.sp,
                  color: AppColors.primaryBlue,
                ),
                Gap(4.w),
                Text(
                  "عرض الكل",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
              ],
            ),
          ),
           Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                TextHeader,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                  letterSpacing: -0.5,
                ),
              ),
              Gap(2.h),
              Text(
                SubTextHeader,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}