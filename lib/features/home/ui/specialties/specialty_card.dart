// lib/features/home/ui/widgets/specialties/specialty_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/data/models/specialty_model.dart';

class SpecialtyCard extends StatelessWidget {
  final Specialty specialty;

  const SpecialtyCard({
    super.key,
    required this.specialty,
  });

  IconData _getIconFromString(String iconName) {
    final iconMap = {
      'favorite_rounded': Icons.favorite_rounded,
      'psychology_rounded': Icons.psychology_rounded,
      'accessibility_new_rounded': Icons.accessibility_new_rounded,
      'child_care_rounded': Icons.child_care_rounded,
      'spa_rounded': Icons.spa_rounded,
      'remove_red_eye_rounded': Icons.remove_red_eye_rounded,
      'local_hospital_rounded': Icons.local_hospital_rounded,
      'medical_services_rounded': Icons.medical_services_rounded,
    };
    
    return iconMap[iconName] ?? Icons.medical_services_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = specialty.color;
    
    return Container(
      width: 115.w,
      margin: EdgeInsets.only(right: 14.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Navigate to specialty details
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor.withOpacity(0.08),
                  primaryColor.withOpacity(0.03),
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: primaryColor.withOpacity(0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // الأيقونة
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Container(
                      margin: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primaryColor,
                            primaryColor.withOpacity(0.7),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconFromString(specialty.icon),
                        color: Colors.white,
                        size: 26.sp,
                      ),
                    ),
                  ),
                  
                  Gap(18.h),
                  
                  // اسم التخصص
                  Text(
                    specialty.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                      height: 1.2,
                      letterSpacing: -0.3,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  Gap(8.h),
                  
                  // عدد الأطباء
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_hospital_rounded,
                          size: 12.sp,
                          color: primaryColor,
                        ),
                        Gap(4.w),
                        Text(
                          '${specialty.doctorsCount}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}