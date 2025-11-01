import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/theming/colors.dart';

class OnboardingHeader extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final VoidCallback onSkipPressed;

  const OnboardingHeader({
    Key? key,
    required this.currentIndex,
    required this.totalPages,
    required this.onSkipPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBrand(),
          if (currentIndex < totalPages - 1) _buildSkipButton(),
        ],
      ),
    );
  }

  Widget _buildBrand() {
    return Row(
      children: [
        Container(
          width: 32.w,
          height: 36.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [ColorsManager.primaryBlue, ColorsManager.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child:  Icon(
            Icons.medical_information_outlined,
            color: Colors.white,
            size: 16.w,
          ),
        ),
        Gap(10.w),
         Text(
          'Tabiby',
          style: TextStyle(
            fontSize: 14.w,
            fontWeight: FontWeight.w700,
            color: ColorsManager.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildSkipButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primaryBlue.withOpacity(0.6),
            blurRadius: 6.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onSkipPressed,
        style: TextButton.styleFrom(
          foregroundColor: ColorsManager.textSecondary,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        ),
        child: Text(
          'Skip',
          style: TextStyle(
            fontSize: 12.w,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}