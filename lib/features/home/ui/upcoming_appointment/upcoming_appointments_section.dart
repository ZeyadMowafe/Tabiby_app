import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/ui/widgets/doctor_info_booking.dart';
import 'package:tabiby/features/home/ui/booking/recent_bookings_section.dart';
import 'package:tabiby/features/home/ui/widgets/section_header.dart';

class UpcomingAppointmentsSection extends StatelessWidget {
  const UpcomingAppointmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          TextHeader: 'المواعيد القادمة',
          SubTextHeader: 'تابع مواعيدك الطبية القادمة بسهولة',
        ),
        Gap(16.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: 5,
          itemBuilder: (context, index) => AppointmentCard(
            index: index,
            status: 'Confirmed',
            date: 'Tomorrow',
            time: '10:00 AM',
            clinic: 'Cairo MC',
          ),
        ),
      ],
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final int index;
  final String status;
  final String date;
  final String time;
  final String clinic;

  const AppointmentCard({
    super.key,
    required this.index,
    required this.status,
    required this.date,
    required this.time,
    required this.clinic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
        children: [
          Row(
            children: [
              const DoctorInfo(),
              const Spacer(),
              StatusBadge(status: status),
            ],
          ),
          Gap(16.h),
          AppointmentDetails(
            date: date,
            time: time,
            clinic: clinic,
          ),
          Gap(16.h),
          const AppointmentActionButtons(),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.successGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.successGreen.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 14.sp,
            color: AppColors.successGreen,
          ),
          Gap(4.w),
          Text(
            status,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.successGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentDetails extends StatelessWidget {
  final String date;
  final String time;
  final String clinic;

  const AppointmentDetails({
    super.key,
    required this.date,
    required this.time,
    required this.clinic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceBlue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          AppointmentDetailItem(
            icon: Icons.calendar_today_rounded,
            label: 'Date',
            value: date,
            color: AppColors.primaryBlue,
          ),
          Container(
            width: 1,
            height: 40.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            color: AppColors.cardBorder,
          ),
          AppointmentDetailItem(
            icon: Icons.access_time_rounded,
            label: 'Time',
            value: time,
            color: AppColors.warningOrange,
          ),
          Container(
            width: 1,
            height: 40.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            color: AppColors.cardBorder,
          ),
          AppointmentDetailItem(
            icon: Icons.location_on_rounded,
            label: 'Clinic',
            value: clinic,
            color: AppColors.appointment,
          ),
        ],
      ),
    );
  }
}

class AppointmentDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const AppointmentDetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20.sp, color: color),
          Gap(6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.tertiaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          Gap(2.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class AppointmentActionButtons extends StatelessWidget {
  const AppointmentActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.errorRed,
              side: BorderSide(color: AppColors.errorRed.withOpacity(0.3)),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.close_rounded, size: 16.sp),
                Gap(6.w),
                Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        Gap(12.w),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline_rounded, size: 16.sp),
                Gap(6.w),
                Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}