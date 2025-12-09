// features/login/ui/widgets/login_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/color_manager.dart';
import 'package:tabiby/core/theming/styles.dart';
import 'package:tabiby/features/login/logic/login_state.dart';

class LoginButton extends StatelessWidget {
  final bool isLoading;
  final LoginState state;
  final VoidCallback onPressed;

  const LoginButton({
    Key? key,
    required this.isLoading,
    required this.state,
    required this.onPressed,
  }) : super(key: key);

  bool get _isSignInLoading {
    return isLoading && 
           state is LoginLoading && 
           (state as LoginLoading).isSignIn;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.mainBlue,
          foregroundColor: ColorsManager.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          disabledBackgroundColor: ColorsManager.lightBlue,
        ),
        child: _isSignInLoading
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: const CircularProgressIndicator(
                  color: ColorsManager.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                'تسجيل الدخول',
                style: TextStyles.font16WhiteSemiBold.copyWith(letterSpacing: 1), )
              ),
      
    );
  }
}