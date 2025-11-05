import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/ui/clinics/info_item.dart';

class ClinicInfo extends StatelessWidget {
  const ClinicInfo({super.key, required this.clinic});
    final Map<String, dynamic> clinic ;
  Widget build(BuildContext context) {
    return Row(
      children: [
      InfoItem(
          
          
          
           icon: Icons.star_rounded, value: '${clinic['rating']}', label: '(${clinic['reviews']})', color: AppColors.warningOrange,
        ),
        Container(
          width: 1,
          height: 16.h,
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          color: AppColors.cardBorder,
        ),
        InfoItem(
          
          
          
           icon: Icons.medical_services_outlined, value: '${clinic['doctors']}', label: 'Doctors', color:AppColors.primaryBlue,
        ),
        Container(
          width: 1,
          height: 16.h,
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          color: AppColors.cardBorder,
        ),
        InfoItem(

          
          
          
          
           icon: Icons.near_me_rounded, value: '${clinic['distance']}', label: 'Km', color: AppColors.tertiaryText,
        ),
      ],
    );
  }
}