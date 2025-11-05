import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/ui/appbar/brand_section.dart';
import 'package:tabiby/features/home/ui/appbar/profile_buttom.dart';

class HomeAppBar extends StatelessWidget {
  final bool showShadow;

  const HomeAppBar({
    super.key,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.headerPrimary,
            AppColors.headerSecondary,
          ],
        ),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppColors.headerPrimary.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BrandSection(),
              ProfileButton(),
            ],
          ),
        ),
      ),
    );
  }
}