import 'package:flutter/widgets.dart';
import 'package:tabiby/core/theming/app_text_styles.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/data/models/appointment.dart';


class AppointmentItem extends StatelessWidget {
  final Appointment appointment;
  
  const AppointmentItem({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDoctorAvatar(),
        const SizedBox(width: 16),
        _buildAppointmentDetails(),
        _buildTimeInfo(),
      ],
    );
  }
  
  Widget _buildDoctorAvatar() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appointment.color.withOpacity(0.2),
            appointment.color.withOpacity(0.1)
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: appointment.color.withOpacity(0.3)),
      ),
      child: Center(
        child: Text(
          appointment.doctorName.split(' ').map((n) => n[0]).join(''),
          style: TextStyle(
            color: appointment.color,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
  
  Widget _buildAppointmentDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(appointment.doctorName, style: AppTextStyles.cardTitle),
          const SizedBox(height: 4),
          Text(
            appointment.specialty,
            style: AppTextStyles.statusText.copyWith(
              color: appointment.color,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(appointment.type, style: AppTextStyles.cardDescription),
        ],
      ),
    );
  }
  
  Widget _buildTimeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryText.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            appointment.time,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          appointment.date,
          style: AppTextStyles.cardUnit.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}