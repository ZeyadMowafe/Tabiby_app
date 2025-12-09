import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/color_manager.dart';
import 'package:tabiby/core/theming/styles.dart';

class Advertisement extends StatelessWidget {
  const Advertisement({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: ColorsManager.lightBlueBg,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: ColorsManager.lightBlueBorder,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: ColorsManager.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.local_hospital,
                          color: ColorsManager.primaryColor,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'احجز استشارة طبية',
                              style: TextStyles.font16PrimarySemiBold,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'نخبة من الأطباء المتخصصين',
                              style: TextStyles.font13TextGrayRegular,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
  }
}