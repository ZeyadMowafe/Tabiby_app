import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/color_manager.dart';
import 'package:tabiby/core/theming/styles.dart';

class HomeHeaderScreen extends StatelessWidget {
  const HomeHeaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('مرحباً', style: TextStyles.font15GrayRegular),
            Gap(4.h),
            Text('أحمد محمود', style: TextStyles.font24PrimaryDarkBold),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorsManager.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ColorsManager.borderGray, width: 1),
          ),
          child: IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: ColorsManager.textGray,
              size: 24.sp,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
