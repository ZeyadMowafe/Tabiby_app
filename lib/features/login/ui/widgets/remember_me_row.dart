
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/colors.dart';

class RememberMeRow extends StatelessWidget {
  final bool rememberMe;
  final bool isLoading;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onForgotPasswordTap;

  const RememberMeRow({
    required this.rememberMe,
    required this.isLoading,
    required this.onRememberMeChanged,
    required this.onForgotPasswordTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.9,
          child: Checkbox(
            value: rememberMe,
            onChanged: isLoading
                ? null
                : (value) => onRememberMeChanged(value ?? false),
            activeColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        Text(
          'Remember me',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: isLoading ? null : onForgotPasswordTap,
          child: Text(
            'Forgot Password?',
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