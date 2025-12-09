// features/login/ui/widgets/options_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/helper/extentation.dart';
import 'package:tabiby/core/routing/routes.dart';
import 'package:tabiby/core/theming/color_manager.dart';
import 'package:tabiby/core/theming/styles.dart';
import 'package:tabiby/features/login/ui/forget_password.dart';

class OptionsRow extends StatelessWidget {
  final bool rememberMe;
  final bool isLoading;
  final ValueChanged<bool> onRememberMeChanged;

  const OptionsRow({
    Key? key,
    required this.rememberMe,
    required this.isLoading,
    required this.onRememberMeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: Checkbox(
                value: rememberMe,
                onChanged: isLoading
                    ? null
                    : (value) {
                        onRememberMeChanged(value ?? false);
                      },
                activeColor: ColorsManager.darkBlue,
                checkColor: ColorsManager.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                side: BorderSide(
                  color: ColorsManager.mainBlue
                      .withOpacity(rememberMe ? 1 : 0.2),
                  width: 1.5,
                ),
              ),
            ),
            Gap(8.w),
            Text(
              'تذكرني',
              style: TextStyles.font14GrayRegular
            ),
          ],
        ),
        TextButton(
          onPressed: isLoading
              ? null
              : () {context.pushNamed(Routes.forgetPasswordScreen);
                  
                },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'نسيت كلمة المرور؟',
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorsManager.darkBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}