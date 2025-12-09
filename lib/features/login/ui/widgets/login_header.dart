// features/login/ui/widgets/login_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/styles.dart';

class LoginHeader extends StatelessWidget {
  final Animation<double> fadeAnimation;

  const LoginHeader({
    Key? key,
    required this.fadeAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Column(
        children: [
          Text(
            'مرحباً بك',
            style: TextStyles.font32BlueBold,
          ),
          Gap(8.h),
          Text(
            'سجل دخولك لمتابعة رعايتك الصحية',
            textAlign: TextAlign.center,
            style: TextStyles.font15DarkBlueMedium,
          ),
        ],
      ),
    );
  }
}