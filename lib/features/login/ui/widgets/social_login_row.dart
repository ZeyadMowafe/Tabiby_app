import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/features/login/ui/widgets/social_login_buttom.dart';

class SocialLoginRow extends StatelessWidget {
  final VoidCallback onGoogleTap;
  final VoidCallback onAppleTap;
  final bool isGoogleLoading;
  final bool isAppleLoading;

  const SocialLoginRow({
    required this.onGoogleTap,
    required this.onAppleTap,
    required this.isGoogleLoading,
    required this.isAppleLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SocialLoginButton(
            icon: Icons.g_mobiledata_rounded,
            label: 'Google',
            onTap: onGoogleTap,
            isLoading: isGoogleLoading,
          ),
        ),
        Gap(16.w),
        Expanded(
          child: SocialLoginButton(
            icon: Icons.apple_rounded,
            label: 'Apple',
            onTap: onAppleTap,
            isLoading: isAppleLoading,
          ),
        ),
      ],
    );
  }
}