import 'package:flutter/widgets.dart';
import 'package:tabiby/core/theming/app_text_styles.dart';
import 'package:tabiby/features/home/data/patient_data.dart';
import 'package:tabiby/features/home/ui/widgets/health/health_card.dart';

class HealthOverviewSection extends StatelessWidget {
  const HealthOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final healthData = PatientData.getHealthData();
    
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Health Overview', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: HealthCard(data: healthData[0])),
              const SizedBox(width: 16),
              Expanded(child: HealthCard(data: healthData[1])),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: HealthCard(data: healthData[2])),
              const SizedBox(width: 16),
              Expanded(child: HealthCard(data: healthData[3])),
            ],
          ),
        ],
      ),
    );
  }
}