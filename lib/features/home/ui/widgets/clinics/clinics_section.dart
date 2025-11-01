// lib/features/home/ui/widgets/clinics/clinics_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/colors.dart';

class ClinicsSection extends StatelessWidget {
  const ClinicsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        Gap(16.h),
        _buildClinicsList(),
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
                'Nearby Clinics',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                  letterSpacing: -0.5,
                ),
              ),
              Gap(4.h),
              Text(
                'Find the best healthcare centers',
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
                  'Browse',
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

  Widget _buildClinicsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: _clinics.length,
      itemBuilder: (context, index) {
        return _ClinicCard(clinic: _clinics[index]);
      },
    );
  }

  static final List<Map<String, dynamic>> _clinics = [
    {
      'name': 'Cairo Medical Center',
      'address': '123 Tahrir Street, Downtown',
      'city': 'Cairo',
      'rating': 4.8,
      'reviews': 842,
      'doctors': 48,
      'specialties': ['Cardiology', 'Neurology', 'Orthopedics'],
      'isOpen': true,
      'hours': 'Open until 10:00 PM',
      'distance': 2.5,
    },
    {
      'name': 'Nile Hospital',
      'address': '456 Corniche Road, Maadi',
      'city': 'Cairo',
      'rating': 4.9,
      'reviews': 1234,
      'doctors': 72,
      'specialties': ['Pediatrics', 'Dermatology', 'Ophthalmology'],
      'isOpen': true,
      'hours': 'Open 24/7',
      'distance': 4.2,
    },
  ];
}

class _ClinicCard extends StatelessWidget {
  final Map<String, dynamic> clinic;

  const _ClinicCard({required this.clinic});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        elevation: 0,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.all(16.w),
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
                _buildClinicHeader(),
                Gap(12.h),
                _buildClinicInfo(),
                Gap(12.h),
                _buildSpecialtiesRow(),
                Gap(12.h),
                _buildClinicFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClinicHeader() {
    return Row(
      children: [
        _buildClinicLogo(),
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
        _buildOpenBadge(),
      ],
    );
  }

  Widget _buildClinicLogo() {
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

  Widget _buildOpenBadge() {
    final isOpen = clinic['isOpen'] as bool;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isOpen
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
              color: isOpen ? AppColors.successGreen : AppColors.errorRed,
              shape: BoxShape.circle,
            ),
          ),
          Gap(4.w),
          Text(
            isOpen ? 'Open' : 'Closed',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: isOpen ? AppColors.successGreen : AppColors.errorRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicInfo() {
    return Row(
      children: [
        _buildInfoItem(
          Icons.star_rounded,
          '${clinic['rating']}',
          '(${clinic['reviews']})',
          AppColors.warningOrange,
        ),
        Container(
          width: 1,
          height: 16.h,
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          color: AppColors.cardBorder,
        ),
        _buildInfoItem(
          Icons.medical_services_outlined,
          '${clinic['doctors']}',
          'Doctors',
          AppColors.primaryBlue,
        ),
        Container(
          width: 1,
          height: 16.h,
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          color: AppColors.cardBorder,
        ),
        _buildInfoItem(
          Icons.near_me_rounded,
          '${clinic['distance']}',
          'km',
          AppColors.tertiaryText,
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.sp, color: color),
        Gap(4.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
          ),
        ),
        Gap(2.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.tertiaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialtiesRow() {
    final specialties = clinic['specialties'] as List<dynamic>;

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: specialties.take(3).map((specialty) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: AppColors.primaryBlue.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Text(
            specialty as String,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildClinicFooter() {
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
                'View Details',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gap(4.w),
              Icon(Icons.arrow_forward_rounded, size: 14.sp),
            ],
          ),
        ),
      ],
    );
  }
}