import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/color_manager.dart';
import 'package:tabiby/core/theming/styles.dart';

class MinimalDoctorCard extends StatelessWidget {
  const MinimalDoctorCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.patients,
    required this.price,
    required this.icon,
  });
  final String name;
  final String specialty;
  final String rating;
  final String patients;
  final String price;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorsManager.borderGray, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64.w,
                height: 64.h,
                decoration: BoxDecoration(
                  color: ColorsManager.lightBlueBg,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  icon,
                  color: ColorsManager.primaryColor,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyles.font16PrimarySemiBold.copyWith(
                        letterSpacing: 0.1,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      specialty,
                      style: TextStyles.font12TextGrayMedium.copyWith(
                        height: 1.3,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
            decoration: BoxDecoration(
              color: ColorsManager.backgroundGray,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: ColorsManager.ratingYellow,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(rating, style: TextStyles.font13PrimaryDarkSemiBold),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      color: ColorsManager.textGray,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text('$patients+', style: TextStyles.font12TextGrayMedium),
                  ],
                ),
                Text(price, style: TextStyles.font14PrimaryBold),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primaryColor,
                foregroundColor: ColorsManager.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'احجز الآن',
                style: TextStyles.font14BlueSemiBold.copyWith(
                  color: ColorsManager.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
