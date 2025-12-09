import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/color_manager.dart';
import 'package:tabiby/core/theming/styles.dart';

class SearchBarScreen extends StatelessWidget {
  const SearchBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: ColorsManager.borderGray, width: 1),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'ابحث عن دكتور أو تخصص',
          hintStyle: TextStyles.font14GrayRegular.copyWith(
            color: ColorsManager.lightTextGray,
          ),
          suffixIcon: Icon(
            Icons.search,
            color: ColorsManager.lightTextGray,
            size: 22.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: ColorsManager.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 16.h,
          ),
        ),
      ),
    );
  }
}
