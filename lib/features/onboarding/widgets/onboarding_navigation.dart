import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'onboarding_progress_indicator.dart';

class OnboardingNavigation extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final Color primaryColor;
  final VoidCallback onNextPressed;
  final VoidCallback onPreviousPressed;

  const OnboardingNavigation({
    Key? key,
    required this.currentIndex,
    required this.totalPages,
    required this.primaryColor,
    required this.onNextPressed,
    required this.onPreviousPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:  BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OnboardingProgressIndicator(
            currentIndex: currentIndex,
            totalPages: totalPages,
            activeColor: primaryColor,
          ),
          const SizedBox(height: 24),
          _buildContinueButton(),
          if (currentIndex > 0) _buildPreviousButton(),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: onNextPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: primaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentIndex == totalPages - 1
                  ? 'Get Started'
                  : 'Continue',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              currentIndex == totalPages - 1
                  ? Icons.check_circle_rounded
                  : Icons.arrow_forward_ios_rounded,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviousButton() {
    return Column(
      children: [
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: TextButton(
            onPressed: onPreviousPressed,
            style: TextButton.styleFrom(
              foregroundColor: primaryColor,
            ),
            child: const Text(
              'Previous',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}