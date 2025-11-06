
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/data/models/doctor_model.dart';
import 'package:tabiby/features/home/ui/select_doctor/doctor_avater.dart';

class CardHeaderDoctor extends StatelessWidget {
  const CardHeaderDoctor({super.key, required this.doctor, });
  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          DoctorAvatar(),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  doctor.name as String,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(4.h),
                Text(
                  doctor.specialtyName as String,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // AvailabilityBadge(doctor: doctor,),
        ],
      ),
    );
  }
}