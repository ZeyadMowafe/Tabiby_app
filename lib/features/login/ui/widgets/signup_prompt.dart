// features/login/ui/widgets/signup_prompt.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/styles.dart';

class SignupPrompt extends StatelessWidget {
  final VoidCallback onSignupPressed;

  const SignupPrompt({
    Key? key,
    required this.onSignupPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ليس لديك حساب؟ ',
          style: TextStyles.font14GrayRegular,)
        ,
        TextButton(
          onPressed: onSignupPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'سجل الآن',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF1E40AF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}