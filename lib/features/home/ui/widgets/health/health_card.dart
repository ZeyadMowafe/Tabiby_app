import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tabiby/core/theming/app_text_styles.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/data/models/health_data.dart';
import 'package:tabiby/features/home/ui/widgets/common/gradient_icon_container.dart';
import 'package:tabiby/features/home/ui/widgets/common/status_badge.dart';

class HealthCard extends StatelessWidget {
  final HealthData data;
  
  const HealthCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _buildCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(),
          const SizedBox(height: 16),
          _buildValueSection(),
          const SizedBox(height: 4),
          Text(data.title, style: AppTextStyles.cardDescription),
        ],
      ),
    );
  }
  
  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: data.primaryColor.withOpacity(0.06),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
  
  Widget _buildCardHeader() {
    return Row(
      children: [
        GradientIconContainer(
          icon: data.icon,
          primaryColor: data.primaryColor,
          secondaryColor: data.secondaryColor,
        ),
        const Spacer(),
        StatusBadge(
          text: data.status,
          color: AppColors.healthySecondary,
          backgroundColor: AppColors.healthyPrimary,
        ),
      ],
    );
  }
  
  Widget _buildValueSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(data.value, style: AppTextStyles.cardValue),
        const SizedBox(width: 4),
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(data.unit, style: AppTextStyles.cardUnit),
        ),
      ],
    );
  }
}
