// features/login/ui/widgets/social_buttons.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/features/login/logic/login_state.dart';

class SocialButtons extends StatelessWidget {
  final bool isLoading;
  final LoginState state;
  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;

  const SocialButtons({
    Key? key,
    required this.isLoading,
    required this.state,
    required this.onGooglePressed,
    required this.onApplePressed,
  }) : super(key: key);

  bool get _isGoogleSignInLoading {
    return isLoading && 
           state is LoginLoading && 
           (state as LoginLoading).isGoogleSignIn;
  }

  bool get _isAppleSignInLoading {
    return isLoading && 
           state is LoginLoading && 
           (state as LoginLoading).isAppleSignIn;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            icon: Icons.g_mobiledata_rounded,
            label: 'Google',
            onPressed: onGooglePressed,
            isLoading: _isGoogleSignInLoading,
          ),
        ),
        Gap(12.w),
        Expanded(
          child: _buildSocialButton(
            icon: Icons.apple,
            label: 'Apple',
            onPressed: onApplePressed,
            isLoading: _isAppleSignInLoading,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      height: 50.h,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          backgroundColor: Colors.white,
        ),
        child: isLoading
            ? SizedBox(
                width: 18.w,
                height: 18.w,
                child: const CircularProgressIndicator(
                  color: Color(0xFF1E40AF),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 22.sp,
                    color: const Color(0xFF0F172A),
                  ),
                  Gap(6.w),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}