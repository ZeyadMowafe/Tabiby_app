// lib/features/home/ui/widgets/clinics/clinics_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/ui/clinics/clinic_info.dart';
import 'package:tabiby/features/home/ui/widgets/common/section_header.dart';
import 'package:tabiby/features/home/ui/clinics/specialties_clinic_row.dart';

class ClinicsSection extends StatelessWidget {
  const ClinicsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(TextHeader: 'العيادات ', SubTextHeader: 'اختر العيادة المناسبة',),
        Gap(14.h),
       ClinicsList(clinics: clinics,),
      ],
    );
  }


}

class ClinicCard extends StatelessWidget {
  final Map<String, dynamic> clinic;

  const ClinicCard({required this.clinic});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      elevation: 0,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.cardBorder,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClinicHeader(clinic: clinic),
              Gap(12.h),
              ClinicInfo(clinic: clinic),
              Gap(12.h),
              SpecialtiesRow(clinic: clinic),
              Gap(12.h),
              ClinicFooter(clinic: clinic),
            ],
          ),
        ),
      ),
    );
  }

 




  // Widget _buildOpenBadge() {
  //   final isOpen = clinic['isOpen'] as bool;

  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
  //     decoration: BoxDecoration(
  //       color: isOpen
  //           ? AppColors.successGreen.withOpacity(0.1)
  //           : AppColors.errorRed.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(8.r),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Container(
  //           width: 6.w,
  //           height: 6.h,
  //           decoration: BoxDecoration(
  //             color: isOpen ? AppColors.successGreen : AppColors.errorRed,
  //             shape: BoxShape.circle,
  //           ),
  //         ),
  //         Gap(4.w),
  //         Text(
  //           isOpen ? 'Open' : 'Closed',
  //           style: TextStyle(
  //             fontSize: 10.sp,
  //             fontWeight: FontWeight.w600,
  //             color: isOpen ? AppColors.successGreen : AppColors.errorRed,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  

  
}







class ClinicLogo extends StatelessWidget {
  const ClinicLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.appointment.withOpacity(0.2),
            AppColors.appointmentSecondary.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Icon(
        Icons.local_hospital_rounded,
        size: 28.sp,
        color: AppColors.appointment,
      ),
    );
  }
}

class ClinicFooter extends StatelessWidget {
  const ClinicFooter({super.key, required this.clinic});
    final Map<String, dynamic> clinic;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 16.sp,
              color: AppColors.successGreen,
            ),
            Gap(6.w),
            Text(
              clinic['hours'] as String,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.successGreen,
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'المزيد',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gap(2.w),
              Icon(Icons.arrow_forward_rounded, size: 14.sp),
            ],
          ),
        ),
      ],
    );
  }
}

class ClinicHeader extends StatelessWidget {
  const ClinicHeader({super.key, required this.clinic});
  final Map<String, dynamic> clinic;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      
      children: [
       
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                clinic['name'] as String,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(4.h),
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 14.sp,
                    color: AppColors.tertiaryText,
                  ),
                  Gap(4.w),
                  Expanded(
                    child: Text(
                      clinic['address'] as String,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.tertiaryText,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ClinicLogo(),
        // _buildOpenBadge(),
      ],
    );
  }
}


class ClinicsList extends StatelessWidget {
  const ClinicsList({super.key, required this.clinics});
  final List<Map<String, dynamic>> clinics;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230.h, // حدد ارتفاع مناسب للكارد
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // هنا التغيير المهم
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        itemCount: clinics.length,
        itemBuilder: (context, index) {
          return Container(
            width: 300.w, // عرض ثابت لكل كارد
            margin: EdgeInsets.only(left: index == clinics.length - 1 ? 0 : 16.w),
            child: ClinicCard(clinic: clinics[index]),
          );
        },
      ),
    );
  }
}

final List<Map<String, dynamic>> clinics = [
  {
    'name': 'مركز القاهرة الطبي',
    'address': '١٢٣ شارع التحرير، وسط البلد',
    'city': 'القاهرة',
    'rating': 4.8,
    'reviews': 842,
    'doctors': 48,
    'specialties': ['أمراض القلب', 'الأعصاب', 'العظام'],
    'isOpen': true,
    'hours': 'مفتوح حتى 10:00 مساءً',
    'distance': 2.5,
  },
  {
    'name': 'مستشفى النيل',
    'address': '٤٥٦ طريق الكورنيش، المعادي',
    'city': 'القاهرة',
    'rating': 4.9,
    'reviews': 1234,
    'doctors': 72,
    'specialties': ['طب الأطفال', 'الأمراض الجلدية', 'طب العيون'],
    'isOpen': true,
    'hours': 'مفتوح 24 ساعة',
    'distance': 4.2,
  },
];
