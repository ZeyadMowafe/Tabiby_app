import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tabiby/core/theming/app_text_styles.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/data/patient_data.dart';
import 'package:tabiby/features/home/ui/widgets/reports/report_item.dart';

class ReportsSection extends StatelessWidget {
  const ReportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = PatientData.getRecentReports();
    
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: _buildCardDecoration(),
            child: Column(
              children: reports.asMap().entries.map((entry) {
                final isLast = entry.key == reports.length - 1;
                return Column(
                  children: [
                    ReportItem(report: entry.value),
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
  
  Widget _buildSectionHeader() {
    return Row(
      children: [
        Text('Recent Reports', style: AppTextStyles.sectionTitle),
        const Spacer(),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            backgroundColor: AppColors.reports.withOpacity(0.1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            'View all',
            style: AppTextStyles.buttonText.copyWith(color: AppColors.reports),
          ),
        ),
      ],
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
