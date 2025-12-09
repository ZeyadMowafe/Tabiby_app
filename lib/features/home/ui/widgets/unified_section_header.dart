import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/color_manager.dart';
import 'package:tabiby/core/theming/styles.dart';

class UnifiedSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showButton;
  final String buttonText;
  final VoidCallback? onPressed;

  const UnifiedSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showButton = false,
    this.buttonText = 'عرض الكل',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyles.font20PrimaryDarkBold),

              if (showButton)
                TextButton(
                  onPressed: onPressed,
                  style: TextButton.styleFrom(
                    foregroundColor: ColorsManager.primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(buttonText, style: TextStyles.font13PrimaryMedium),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12.sp,
                        color: ColorsManager.textGray,
                      ),
                    ],
                  ),
                ),
            ],
          ),

          if (subtitle != null) ...[
            Text(subtitle!, style: TextStyles.font13TextGrayRegular),
          ],
        ],
      ),
    );
  }
}
