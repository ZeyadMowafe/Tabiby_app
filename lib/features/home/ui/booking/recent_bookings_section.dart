// lib/features/home/ui/widgets/bookings/recent_bookings_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/ui/booking/booking_card.dart';

class RecentBookingsSection extends StatelessWidget {
  const RecentBookingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'الحجوزات الأخيرة',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryText,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
        Gap(16.h),
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: 3,
            itemBuilder: (context, index) => BookingCard(index: index),
          ),
        ),
      ],
    );
  }
}




