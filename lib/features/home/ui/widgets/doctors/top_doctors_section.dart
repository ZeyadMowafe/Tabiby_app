// lib/features/home/ui/widgets/doctors/top_doctors_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/colors.dart';

class TopDoctorsSection extends StatelessWidget {
  const TopDoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        Gap(16.h),
        _buildDoctorsList(),
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
                'Top Doctors',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                  letterSpacing: -0.5,
                ),
              ),
              Gap(4.h),
              Text(
                'Highly rated professionals',
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
                  'View All',
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

  Widget _buildDoctorsList() {
    return SizedBox(
      height: 220.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: _doctors.length,
        itemBuilder: (context, index) {
          return _DoctorCard(doctor: _doctors[index]);
        },
      ),
    );
  }

  static final List<Map<String, dynamic>> _doctors = [
    {
      'name': 'Dr. Ahmed Hassan',
      'specialty': 'Cardiologist',
      'rating': 4.9,
      'reviews': 2847,
      'experience': 15,
      'fee': 500,
      'available': true,
      'image': null,
    },
    {
      'name': 'Dr. Sara Mohamed',
      'specialty': 'Neurologist',
      'rating': 4.8,
      'reviews': 1923,
      'experience': 12,
      'fee': 450,
      'available': false,
      'image': null,
    },
    {
      'name': 'Dr. Omar Ali',
      'specialty': 'Orthopedic',
      'rating': 4.7,
      'reviews': 1654,
      'experience': 10,
      'fee': 400,
      'available': true,
      'image': null,
    },
  ];
}

class _DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const _DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      margin: EdgeInsets.only(right: 16.w),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        elevation: 0,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
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
              children: [
                _buildCardHeader(),
                _buildCardBody(),
                _buildCardFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          _buildDoctorAvatar(),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor['name'] as String,
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
                  doctor['specialty'] as String,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _buildAvailabilityBadge(),
        ],
      ),
    );
  }

  Widget _buildDoctorAvatar() {
    return Container(
      width: 56.w,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryBlue.withOpacity(0.2),
            AppColors.lightBlue.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Icon(
        Icons.person_rounded,
        size: 28.sp,
        color: AppColors.primaryBlue,
      ),
    );
  }

  Widget _buildAvailabilityBadge() {
    final isAvailable = doctor['available'] as bool;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isAvailable
            ? AppColors.successGreen.withOpacity(0.1)
            : AppColors.errorRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: isAvailable ? AppColors.successGreen : AppColors.errorRed,
              shape: BoxShape.circle,
            ),
          ),
          Gap(4.w),
          Text(
            isAvailable ? 'Available' : 'Busy',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: isAvailable ? AppColors.successGreen : AppColors.errorRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _buildInfoChip(
            Icons.star_rounded,
            '${doctor['rating']}',
            AppColors.warningOrange,
          ),
          Gap(8.w),
          _buildInfoChip(
            Icons.work_outline_rounded,
            '${doctor['experience']}y',
            AppColors.primaryBlue,
          ),
          Gap(8.w),
          _buildInfoChip(
            Icons.rate_review_outlined,
            '${doctor['reviews']}',
            AppColors.tertiaryText,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
          Gap(4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFooter() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Consultation Fee',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.tertiaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Gap(4.h),
              Text(
                '${doctor['fee']} EGP',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                  letterSpacing: -0.5,
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
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Book',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(4.w),
                Icon(Icons.arrow_forward_rounded, size: 16.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}