import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tabiby/core/theming/app_text_styles.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/data/models/medication.dart';


class MedicationItem extends StatelessWidget {
  final Medication medication;
  final VoidCallback? onMarkTaken;
  
  const MedicationItem({
    super.key,
    required this.medication,
    this.onMarkTaken,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: medication.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: medication.color.withOpacity(0.2)),
          ),
          child: Icon(
            Icons.medication_liquid_rounded,
            color: medication.color,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: _buildMedicationInfo()),
        _buildActionButton(),
      ],
    );
  }
  
  Widget _buildMedicationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          medication.name,
          style: AppTextStyles.cardTitle.copyWith(
            color: medication.isTaken ? AppColors.tertiaryText : AppColors.primaryText,
            decoration: medication.isTaken ? TextDecoration.lineThrough : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(medication.instructions, style: AppTextStyles.cardDescription),
        const SizedBox(height: 4),
        Text(
          medication.time,
          style: AppTextStyles.cardUnit.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onMarkTaken?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: medication.isTaken 
              ? AppColors.healthyPrimary.withOpacity(0.1)
              : AppColors.appointment.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: medication.isTaken 
                ? AppColors.healthyPrimary.withOpacity(0.3)
                : AppColors.appointment.withOpacity(0.3),
          ),
        ),
        child: Text(
          medication.isTaken ? 'Taken' : 'Mark Taken',
          style: AppTextStyles.statusText.copyWith(
            color: medication.isTaken 
                ? AppColors.healthySecondary 
                : AppColors.appointment,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}