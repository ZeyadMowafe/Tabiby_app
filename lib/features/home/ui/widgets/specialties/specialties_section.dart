// lib/features/home/ui/widgets/specialties/specialties_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/colors.dart';

class SpecialtiesSection extends StatelessWidget {
  const SpecialtiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        Gap(16.h),
        _buildSpecialtiesList(),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Specialties',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                  letterSpacing: -0.5,
                ),
              ),
              Gap(4.h),
              Text(
                'Find your specialist',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            ),
            child: Row(
              children: [
                Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(4.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.sp,
                  color: AppColors.primaryBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtiesList() {
    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: _specialties.length,
        itemBuilder: (context, index) {
          return _SpecialtyCard(specialty: _specialties[index]);
        },
      ),
    );
  }

  static final List<Map<String, dynamic>> _specialties = [
    {
      'name': 'Cardiology',
      'icon': Icons.favorite_rounded,
      'color': const Color(0xFFEF4444),
      'count': 124,
    },
    {
      'name': 'Neurology',
      'icon': Icons.psychology_rounded,
      'color': const Color(0xFF8B5CF6),
      'count': 98,
    },
    {
      'name': 'Orthopedics',
      'icon': Icons.accessibility_new_rounded,
      'color': const Color(0xFF06B6D4),
      'count': 156,
    },
    {
      'name': 'Pediatrics',
      'icon': Icons.child_care_rounded,
      'color': const Color(0xFFF59E0B),
      'count': 203,
    },
    {
      'name': 'Dermatology',
      'icon': Icons.spa_rounded,
      'color': const Color(0xFF10B981),
      'count': 87,
    },
    {
      'name': 'Ophthalmology',
      'icon': Icons.remove_red_eye_rounded,
      'color': const Color(0xFF3B82F6),
      'count': 72,
    },
  ];
}

class _SpecialtyCard extends StatelessWidget {
  final Map<String, dynamic> specialty;

  const _SpecialtyCard({required this.specialty});

  @override
  Widget build(BuildContext context) {
    final color = specialty['color'] as Color;

    return Container(
      width: 100.w,
      margin: EdgeInsets.only(right: 12.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.1),
                  color.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    specialty['icon'] as IconData,
                    color: color,
                    size: 24.sp,
                  ),
                ),
                Gap(12.h),
                Text(
                  specialty['name'] as String,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(4.h),
                Text(
                  '${specialty['count']} Doctors',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.tertiaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}