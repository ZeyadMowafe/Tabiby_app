import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tabiby/core/theming/app_text_styles.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/data/patient_data.dart';
import 'package:tabiby/features/home/ui/widgets/common/status_badge.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: _buildHeaderDecoration(),
      child: Row(
        children: [
          _buildUserInfo(),
          _buildNotificationButton(),
          const SizedBox(width: 16),
          _buildUserAvatar(),
        ],
      ),
    );
  }
  
  BoxDecoration _buildHeaderDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.headerPrimary, AppColors.headerSecondary],
      ),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: AppColors.headerPrimary.withOpacity(0.3),
          blurRadius: 32,
          offset: const Offset(0, 16),
        ),
      ],
    );
  }
  
  Widget _buildUserInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back', style: AppTextStyles.headerSubtitle),
          const SizedBox(height: 8),
          Text(PatientData.userName, style: AppTextStyles.headerTitle),
          const SizedBox(height: 12),
          const StatusBadge(
            text: 'Healthy',
            color: AppColors.healthyPrimary,
            backgroundColor: AppColors.healthyPrimary,
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationButton() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        Positioned(
          right: 12,
          top: 12,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.notificationDot,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.notificationDot.withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildUserAvatar() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.avatarPrimary, AppColors.avatarSecondary],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.avatarPrimary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text(
          PatientData.userInitials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}