import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/colors.dart';

class SignUpPrompt extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSignUpTap;

  const SignUpPrompt({
    required this.isLoading,
    required this.onSignUpTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextButton(
          onPressed: isLoading ? null : onSignUpTap,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
          ),
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}