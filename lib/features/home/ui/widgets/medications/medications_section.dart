import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tabiby/core/theming/app_text_styles.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/data/patient_data.dart';
import 'package:tabiby/features/home/ui/widgets/medications/medication_item.dart';

class MedicationsSection extends StatelessWidget {
  const MedicationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final medications = PatientData.getMedications();
    
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Medication Reminders', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: _buildCardDecoration(),
            child: Column(
              children: medications.asMap().entries.map((entry) {
                final isLast = entry.key == medications.length - 1;
                return Column(
                  children: [
                    MedicationItem(
                      medication: entry.value,
                      onMarkTaken: () {
                        // Handle medication taken action
                      },
                    ),
                    if (!isLast) const SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
  
  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.tertiaryText.withOpacity(0.06),
          blurRadius: 32,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}