import 'package:flutter/widgets.dart';
import 'package:tabiby/core/theming/app_text_styles.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/data/models/report.dart';
import 'package:tabiby/features/home/ui/widgets/common/status_badge.dart';

class ReportItem extends StatelessWidget {
  final Report report;
  
  const ReportItem({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: report.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: report.color.withOpacity(0.2)),
          ),
          child: Icon(report.icon, color: report.color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(report.title, style: AppTextStyles.cardTitle),
                  ),
                  StatusBadge(
                    text: report.status,
                    color: AppColors.healthySecondary,
                    backgroundColor: AppColors.healthyPrimary,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(report.description, style: AppTextStyles.cardDescription),
              const SizedBox(height: 4),
              Text(
                report.date,
                style: AppTextStyles.cardUnit.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}