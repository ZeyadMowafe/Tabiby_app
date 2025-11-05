import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/theming/colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isTablet;
  final bool isSmallScreen;

  const AuthHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.isTablet,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo Section with Enhanced Design
        Container(
          width: (isTablet ? 110 : 90).w,
          height: (isTablet ? 110 : 90).w,
          margin: EdgeInsets.only(top: isSmallScreen ? 16.h : 32.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBlue,
                AppColors.primaryBlue.withOpacity(0.8),
                AppColors.lightBlue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.5, 1.0],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.4),
                blurRadius: 32,
                offset: const Offset(0, 16),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow Effect
              Container(
                width: (isTablet ? 90 : 70).w,
                height: (isTablet ? 90 : 70).w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
              // Icon
              Icon(
                Icons.health_and_safety_rounded,
                color: Colors.white,
                size: isTablet ? 55.sp : 45.sp,
              ),
            ],
          ),
        ),

        SizedBox(height: isSmallScreen ? 24.h : 32.h),

        // Welcome Text with Enhanced Typography
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isTablet ? 36.sp : 30.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -1.0,
            height: 1.1,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),

        Gap(8.h),

        // Subtitle with Modern Design
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? 17.sp : 15.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
              height: 1.4,
            ),
          ),
        ),

        // Decorative Line
        Container(
          margin: EdgeInsets.only(top: 20.h),
          width: 120.w,
          height: 4.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBlue.withOpacity(0.3),
                AppColors.primaryBlue,
                AppColors.primaryBlue.withOpacity(0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ],
    );
  }
}