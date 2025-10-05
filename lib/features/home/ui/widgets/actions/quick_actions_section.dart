import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tabiby/core/theming/app_text_styles.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/ui/widgets/actions/action_card.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ActionCard(
                  title: 'Book Appointment',
                  subtitle: 'Schedule new visit',
                  icon: Icons.calendar_month_rounded,
                  primaryColor: AppColors.appointment,
                  secondaryColor: AppColors.appointmentSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ActionCard(
                  title: 'My Reports',
                  subtitle: 'View test results',
                  icon: Icons.description_outlined,
                  primaryColor: AppColors.reports,
                  secondaryColor: AppColors.reportsSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ActionCard(
                  title: 'Medications',
                  subtitle: 'Track prescriptions',
                  icon: Icons.medication_liquid_rounded,
                  primaryColor: AppColors.medications,
                  secondaryColor: AppColors.medicationsSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ActionCard(
                  title: 'Emergency',
                  subtitle: 'Contact help',
                  icon: Icons.emergency_rounded,
                  primaryColor: AppColors.emergency,
                  secondaryColor: AppColors.emergencySecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
