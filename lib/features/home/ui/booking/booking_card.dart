import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/colors.dart';

class BookingCard extends StatelessWidget {
  final int index;

  const BookingCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260.w,
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.reports.withOpacity(0.1),
            AppColors.reportsSecondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.reports.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.reports.withOpacity(0.2),
                  AppColors.reportsSecondary.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.person_rounded,
              color: AppColors.reports,
              size: 24.sp,
            ),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Dr. Mohamed Ali',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(4.h),
                Text(
                  'Cardiologist',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.reports,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(6.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 12.sp,
                      color: AppColors.tertiaryText,
                    ),
                    Gap(4.w),
                    Text(
                      '2 days ago',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.tertiaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

