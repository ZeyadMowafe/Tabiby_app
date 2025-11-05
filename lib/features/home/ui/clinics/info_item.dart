
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/colors.dart';

class InfoItem extends StatelessWidget {
  const InfoItem({super.key, required this.icon, required this.value, required this.label, required this.color});
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.sp, color: color),
        Gap(4.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
          ),
        ),
        Gap(2.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.tertiaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}