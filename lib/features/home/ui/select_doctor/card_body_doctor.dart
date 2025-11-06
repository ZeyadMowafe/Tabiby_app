import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/data/models/doctor_model.dart';
import 'package:tabiby/features/home/ui/select_doctor/info_ship.dart';


class CardBody extends StatelessWidget {
  const CardBody({super.key, required this.doctor});
final Doctor  doctor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          InfoChip(color: AppColors.warningOrange, 
            icon: Icons.star_rounded,
            text: '${doctor.rating}',
          ),
          Gap(  8.w),
          InfoChip(color: AppColors.primaryBlue,  
            icon: Icons.work_outline_rounded,
            text: '${doctor.experience} y',
          ),
           Gap(  8.w),
          InfoChip(color: AppColors.tertiaryText, 
            icon: Icons.rate_review_outlined,
            text: '${doctor.reviewsCount} Reviews',
          ),
           Gap(  8.w),
        ],
      ),
    );
  }
}