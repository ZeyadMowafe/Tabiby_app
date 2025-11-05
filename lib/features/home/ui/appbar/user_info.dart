import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/app_text_styles.dart';
import 'package:tabiby/features/home/data/patient_data.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         const Text('Welcome back', style: AppTextStyles.headerSubtitle),
          Gap(3.h),
          Text(PatientData.userName, style: AppTextStyles.headerTitle),
          Gap(8.h),       
        ],
      ),
    );
  }
}
